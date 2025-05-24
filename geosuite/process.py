#!/usr/bin/env python
# coding: utf-8
import os
import sys

import geopandas as gpd
import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy import text

placenames_2021_csv = sys.argv[1]

DATABASE = os.environ.get("POSTGRES_DB")
USER = os.environ.get("POSTGRES_USER")
PASSWORD = os.environ.get("POSTGRES_PASSWORD")

engine = create_engine(f"postgresql://{USER}:{PASSWORD}@db:5432/{DATABASE}")

print(f"Reading {placenames_2021_csv}")
placenames = pd.read_csv(filepath_or_buffer=placenames_2021_csv,
                         encoding='ISO-8859-1',
                         usecols=['PNdguid', 'PNname', 'PNsource', 'PNrplat', 'PNrplong'])

placenames.rename(columns={
    'PNdguid': 'pn_dguid',
    'PNname': 'pn_name',
    'PNsource': 'pn_source',
    'PNrplat': 'latitude',
    'PNrplong': 'longitude'
}, inplace=True)

print("Creating geodataframe from placenames file")
gdf = gpd.GeoDataFrame(
    placenames, 
    geometry=gpd.points_from_xy(placenames.longitude,
                                placenames.latitude),
    crs="EPSG:4326"
)

print("Dropping 'latitude', 'longitude' from geodataframe")
gdf.drop(columns=["latitude", "longitude"], 
         inplace=True)

print(f"Loading geodataframe to PostgreSQL as bronze.pn_2021_tmp")
gdf.to_postgis(name=f"pn_2021_tmp", 
               con=engine,
               chunksize=150000,
               if_exists='replace',
               schema='bronze')

print("Creating silver.pn_2021")
sql = """
DROP TABLE IF EXISTS silver.pn_2021;

CREATE TABLE silver.pn_2021 AS
SELECT 
db.country_dguid,
db.country_en_name, 
db.country_fr_name,
db.country_en_abbreviation,
db.country_fr_abbreviation,
db.grc_dguid,
db.grc_en_name,
db.grc_fr_name,
db.pr_dguid,
db.pr_en_name,
db.pr_fr_name,
db.pr_en_abbreviation,
db.pr_fr_abbreviation,
db.pr_iso_code,
db.car_dguid,
db.car_en_name,
db.car_fr_name,
db.er_dguid,
db.er_name,
db.cd_dguid,
db.cd_name,
db.cd_type,
db.ccs_dguid,
db.ccs_name,
db.cma_dguid,
db.cma_p_dguid,
db.cma_name,
db.cma_type,
db.csd_dguid,
db.csd_name,
db.csd_type,
db.sac_type,
db.sac_code,
db.fed_dguid,
db.fed_name,
db.fed_en_name,
db.fed_fr_name,
db.ct_dguid,
db.ada_dguid,
db.da_dguid,
db.db_dguid,
placenames.pn_dguid,
placenames.pn_name,
placenames.pn_source,
placenames.geometry as geom
FROM bronze.pn_2021_tmp as placenames,
     silver.db_2021 as db
WHERE ST_Intersects(placenames.geometry, db.geom);

CREATE INDEX pn_2021_geom_idx ON
silver.pn_2021 
	USING GIST(geom) WITH (FILLFACTOR = 100);
"""

with engine.connect() as conn:
    conn.execute(text(sql))
    conn.commit()