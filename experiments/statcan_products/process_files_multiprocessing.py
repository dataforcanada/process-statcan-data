from datetime import datetime
import glob
from multiprocessing import Pool
import json
import os
import sqlite3
import zipfile
from zoneinfo import ZoneInfo

import pandas as pd
import polars as pl
import requests
from tqdm import tqdm

data_folder = "/data/tables"
input_folder = f"{data_folder}/input"
scratch_folder = f"{data_folder}/scratch"
output_folder = f"{data_folder}/output"


if not os.path.exists(f"{data_folder}/processing.db"):
    con = sqlite3.connect(f"{data_folder}/processing.db")
    cur = con.cursor()
    cur.executescript("""
        CREATE TABLE IF NOT EXISTS downloaded (
          product_id TEXT PRIMARY KEY,
          last_updated TEXT,
          last_processed TEXT
        );

        CREATE TABLE IF NOT EXISTS cubes (
          product_id TEXT PRIMARY KEY,
          last_updated TEXT
        );
    """)
    con.commit()
else:
    con = sqlite3.connect(f"{data_folder}/processing.db")
    cur = con.cursor()

def setup():
    """
    Makes data folders
    """
    folders_to_create = [data_folder, input_folder,
                         scratch_folder, output_folder,
                         f"{input_folder}/en", f"{output_folder}/en",
                         f"{input_folder}/fr", f"{output_folder}/fr",
                         f"{input_folder}/metadata"]
    for folder in folders_to_create:
        if not os.path.exists(folder):
            print(f"Making folder {folder}")
            os.mkdir(folder)

def update_last_downloaded(product_id):
    """
    Updates SQLite database with the last time the table was updated
    The datetime is in Eastern timezone, so have to convert to UTC to
    be consistent with https://www150.statcan.gc.ca/t1/wds/rest/getAllCubesListLite
    """
    filepath = f"{input_folder}/metadata/{product_id}.json"
    print(f"Reading metadata {filepath}")
    with open(filepath, 'r') as fp:
        metadata = json.load(fp)
    product_id = metadata.get("object").get("productId")
    last_updated = metadata.get("object").get("releaseTime")
    # Convert last_updated to UTC since /getAllcubesListLite uses UTC
    last_updated = datetime.strptime(last_updated, "%Y-%m-%dT%H:%M")
    last_updated = last_updated.replace(tzinfo=ZoneInfo("America/Toronto"))
    last_updated = last_updated.astimezone(ZoneInfo("UTC")).isoformat()

    data = (product_id, last_updated)
    cur.execute("SELECT product_id FROM downloaded WHERE product_id = ?", (product_id,))
    result = cur.fetchone()
    if not result:
        cur.execute("INSERT INTO downloaded (product_id, last_updated) VALUES (?, ?)", data)
    else:
        cur.execute("UPDATE downloaded SET last_updated = ? WHERE product_id = ?", (last_updated, product_id))

    con.commit()

def update_last_processed(product_id):
    time_finished_processing = datetime.now().isoformat()
    cur.execute("UPDATE downloaded SET last_processed = ? WHERE product_id = ?", (time_finished_processing, product_id))
    con.commit()

def update_tables():
    """
    This currently does not work as expected because Statistics Canada has discrepancies.
    The "releaseTime" listed in https://www150.statcan.gc.ca/t1/wds/rest/getAllCubesListLite
    for every pdocutId is not the same as "releaseTime" listed when making a POST
    https://www150.statcan.gc.ca/t1/wds/rest/getCubeMetadata , for example:
    [{"productId":10100007}]
    """
    cur.execute("""
    DELETE FROM cubes;
    """)
    con.commit()
    response = requests.get("https://www150.statcan.gc.ca/t1/wds/rest/getAllCubesListLite").json()
    cubes_metadata = pl.from_dicts(response)[['productId', 'releaseTime']]
    cubes_metadata = cubes_metadata.rename({"productId": "product_id", "releaseTime": "last_updated"})
    cubes_metadata = cubes_metadata.rows()
    cubes_metadata_new =  []
    for cube in cubes_metadata:
        product_id, last_updated = cube
        # Update the date field so it is formatted the same as date field in downloaded table
        last_updated = datetime.strptime(last_updated, "%Y-%m-%dT%H:%M:%SZ").astimezone(ZoneInfo("UTC"))
        last_updated = last_updated.isoformat()
        cubes_metadata_new.append((product_id, last_updated))

    cur.executemany("INSERT INTO cubes VALUES(?, ?)", cubes_metadata_new)
    con.commit()

    cur.execute("""
    SELECT a.product_id
    FROM downloaded AS a,
         cubes AS b
    WHERE a.product_id = b.product_id
    AND b.last_updated > a.last_updated
    """)
    results = cur.fetchall()
    for result in results:
        product_id = result[0]
        print(f"Updating product_id: {product_id}")
        download_cube(product_id)
        process_cube(product_id)

def convert_to_lowest_type(df):
    """
    Convert columns to the best possible dtypes
    For example, if the column is numerical and has a maximum value of 32,000
    we can assign it a type of int16
    """
    print("Converting dataframe to optimal data types")
    params = {
        'convert_string': False,
        'convert_boolean': False
    }
    df = df.convert_dtypes(**params)

    dtypes = pd.DataFrame(df.dtypes)
    # Downcast to the smallest numerical dtype
    for row in dtypes.itertuples():
        column = row[0]
        the_type = str(row[1])
        # Skipping downcasting Float64 as there were issues with decimal places
        # For example, instead of a value being 65.4, it turned into 65.4000015258789
        if the_type == 'Float64':
            continue
        elif the_type == 'Int64':
            df[column] = pd.to_numeric(df[column], downcast='integer')

    return df

def extract_zipfile(product_id, language):
    """
    It is faster to extract the zip file and read the CSV, than open
    via zipfile and then Pandas
    """
    zip_file = f"{input_folder}/{language}/{product_id}.zip"
    with zipfile.ZipFile(zip_file) as myzip:
        print(f"Extracting {zip_file} to {scratch_folder}")
        myzip.extractall(path=scratch_folder)

def get_cube_metadata(product_id):
    url = f"https://www150.statcan.gc.ca/t1/wds/rest/getCubeMetadata"
    cubes_payload = [{"productId": product_id}]
    result = requests.post(url, json=cubes_payload)
    result = result.json()[0]
    return result

def download_cube(product_id, language="en"):
    """
    Downloads the English CSV for a specific table
    """
    download_url = f"https://www150.statcan.gc.ca/t1/wds/rest/getFullTableDownloadCSV/{product_id}/en"
    response = requests.get(download_url).json()
    zip_url = response['object']
    zip_file_name = f"{input_folder}/{language}/{product_id}.zip"
    print(f"Downloading {zip_url} to {zip_file_name}")
    response = requests.get(zip_url, stream=True, headers={"user-agent": None})
    progress_bar = tqdm(
        desc=zip_file_name,
        total=int(response.headers.get("content-length", 0)),
        unit="B",
        unit_scale=True
    )
    with open(zip_file_name, "wb") as handle:
        for chunk in response.iter_content(chunk_size=512):
            if chunk:  # filter out keep-alive new chunks
                handle.write(chunk)
                progress_bar.update(len(chunk))
        progress_bar.close()

def process_cube(product_id, language="en"):
    extract_zipfile(product_id, language)
    """
    The pandas column reader is better than the Polars one
    Here is an example where polars was not reading it right:
    https://www150.statcan.gc.ca/n1/tbl/csv/98100404-eng.zip
    """
    # Get metadata
    #metadata_file = f"{input_folder}/metadata/{product_id}.json"
    #metadata = get_cube_metadata(product_id)
    #print(f"Writing metadata file {metadata_file}")
    #with open(metadata_file, "w") as outfile:
    #    json.dump(metadata, outfile)
    # Read CSV using Pandas
    product_csv = f"{scratch_folder}/{product_id}.csv"
    parameters = {
        "engine": "c",
        "low_memory": True
    }
    print(f"Reading {product_csv} as a Pandas dataframe")
    df = pd.read_csv(product_csv, **parameters)
    df = convert_to_lowest_type(df)
    print("Import Pandas dataframe as a Polars dataframe")
    df = pl.from_pandas(df)
    output_parquet = f"{output_folder}/{language}/{product_id}.parquet"
    print(f"Exporting dataframe as parquet to {output_parquet}")
    df.write_parquet(output_parquet,
                     compression='zstd',
                     compression_level=22)
    # Remove the scratch files
    print("Removing scratch files")
    os.remove(f"{scratch_folder}/{product_id}.csv")
    os.remove(f"{scratch_folder}/{product_id}_MetaData.csv")
    update_last_downloaded(product_id)
    update_last_processed(product_id)

if __name__ == '__main__':
    setup()
    files_to_process = glob.glob(f"{input_folder}/en/*.zip")
    # Get the product_id
    files_to_process = [x.split("/")[-1].split(".zip")[0] for x in files_to_process]
    to_process = len(files_to_process)
    print(f"Processing {to_process}")
    with Pool(4) as p:
        p.map(process_cube, files_to_process)
