import glob
from multiprocessing import Pool
import os
import zipfile

import pandas as pd
import polars as pl

data_folder = "/data/tables"
input_folder = f"{data_folder}/input"
scratch_folder = f"{data_folder}/scratch"
output_folder = f"{data_folder}/output"

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


def process_table(product_id, language="en"):
    extract_zipfile(product_id, language)
    """
    The pandas column reader is better than the Polars one
    Here is an example where polars was not reading it right:
    https://www150.statcan.gc.ca/n1/tbl/csv/98100404-eng.zip
    """
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
    df.write_parquet(f"{output_folder}/{language}/{product_id}.parquet",
                     compression='zstd',
                     compression_level=22)
    # Remove the scratch files
    print("Removing scratch files")
    os.remove(f"{scratch_folder}/{product_id}.csv")
    os.remove(f"{scratch_folder}/{product_id}_MetaData.csv")

if __name__ == '__main__':
    files_to_process = glob.glob(f"{input_folder}/en/*.zip")
    # Get the product_id
    files_to_process = [x.split("/")[-1].split(".zip")[0] for x in files_to_process]
    to_process = len(files_to_process)
    print(f"Processing {to_process}")
    with Pool() as p:
        p.map(process_table, files_to_process)
