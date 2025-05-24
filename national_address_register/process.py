#!/usr/bin/env python
# coding: utf-8
import os
import sys 

import geopandas as gpd
import pandas as pd
from sqlalchemy import create_engine

statcan_nar_addresses_csv = sys.argv[1]
statcan_nar_locations_csv = sys.argv[2]
vintage = sys.argv[3]
encoding = sys.argv[4]

print(f"Reading {statcan_nar_addresses_csv}")
statcan_nar_addresses = pd.read_csv(filepath_or_buffer=statcan_nar_addresses_csv,
                                   dtype={
                                       "CIVIC_NO": "Int32", 
                                       "PROV_CODE": object,
                                       "BU_USE": "Int8",
                                       "BG_DLS_LSD": object,
                                       "BG_DLS_QTR": object,
                                       "BG_DLS_SCTN": object,
                                       "BG_DLS_TWNSHP": object,
                                       "BG_DLS_RNG": object,
                                       "BG_DLS_MRD": object
                                   },
                                   encoding=encoding)

print(f"Reading {statcan_nar_locations_csv}")
statcan_nar_locations = pd.read_csv(filepath_or_buffer=statcan_nar_locations_csv,
                                   usecols=["LOC_GUID", 
                                            "REPPOINT_LATITUDE",
                                            "REPPOINT_LONGITUDE"],
                                   encoding=encoding)

print(f"Combining {statcan_nar_addresses_csv} and {statcan_nar_locations_csv}")
statcan_nar_addresses_combined = pd.merge(statcan_nar_addresses, 
                                          statcan_nar_locations,
                                         on="LOC_GUID", how="inner")

del statcan_nar_addresses
del statcan_nar_locations

DATABASE = os.environ.get("POSTGRES_DB")
HOST = os.environ.get("WAREHOUSE_PG_HOST")
USER = os.environ.get("POSTGRES_USER")
PASSWORD = os.environ.get("POSTGRES_PASSWORD")

engine = create_engine(f"postgresql://{USER}:{PASSWORD}@{HOST}:5432/{DATABASE}")

print("Creating geodataframe from combined address file")
gdf = gpd.GeoDataFrame(
    statcan_nar_addresses_combined, 
    geometry=gpd.points_from_xy(statcan_nar_addresses_combined.REPPOINT_LONGITUDE,
                                statcan_nar_addresses_combined.REPPOINT_LATITUDE),
    crs="EPSG:4326"
)

print("Dropping 'REPPOINT_LATITUDE', 'REPPOINT_LONGITUDE' from geodataframe")
gdf.drop(columns=["REPPOINT_LATITUDE", "REPPOINT_LONGITUDE"], 
         inplace=True)

print("Converting geodataframe to EPSG:3857")
gdf.to_crs(3857, inplace=True)
print(f"Loading geodatframe to PostgreSQL as statcan_nar_addresses_combined_{vintage}")
gdf.to_postgis(name=f"statcan_nar_addresses_combined_{vintage}", 
               con=engine,
               chunksize=150000)
