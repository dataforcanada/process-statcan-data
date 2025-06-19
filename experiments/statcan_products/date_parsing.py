"""
I need to find out what all possible date formats are for the "REF_DATE" field so that when I write the parquet file people will be able to filter on it
"""

import glob
from multiprocessing import Pool
import sqlite3
import polars as pl

data_folder = "/data/tables"
input_folder = f"{data_folder}/input"
scratch_folder = f"{data_folder}/scratch"
output_folder = f"{data_folder}/output"

con = sqlite3.connect(f"{data_folder}/dates.db")
cur = con.cursor()
cur.executescript("""
    DROP TABLE IF EXISTS dates;
    CREATE TABLE IF NOT EXISTS dates (
      product_id TEXT,
      date TEXT
    );
""")
con.commit()

def find_unique_dates(filepath):
    """
    Finds unique dates for a table and writes to SQLite table
    """
    product_id = filepath.split("/")[-1].split(".parquet")[0]
    print(f"Processing {product_id}")
    try:
        result = (
        pl.scan_parquet(filepath)
            .select("REF_DATE")
            .collect()
        )
    except Exception:
        return
    unique_dates = [(product_id, x) for x in result['REF_DATE'].unique(maintain_order=True).to_list()]
    cur.executemany("INSERT INTO dates VALUES(?, ?)", unique_dates)
    con.commit()

if __name__ == '__main__':
    files_to_process = glob.glob(f"{output_folder}/en/other/en/*.parquet")
    with Pool() as p:
        p.map(find_unique_dates, files_to_process)