#!/usr/bin/env python
# coding: utf-8
import os
import sys

import pandas as pd
from sqlalchemy import create_engine

dgr_2021_csv = sys.argv[1]

DATABASE = os.environ.get("POSTGRES_DB")
USER = os.environ.get("POSTGRES_USER")
PASSWORD = os.environ.get("POSTGRES_PASSWORD")

engine = create_engine(f"postgresql://{USER}:{PASSWORD}@db:5432/{DATABASE}")

"""
Data dictionary is here:
https://web.archive.org/web/20250413152017/https://www150.statcan.gc.ca/n1/pub/98-26-0003/982600032021001-eng.htm

This processes the entire DGUID hierarchy and other useful fields
"""
print(f"Processing {dgr_2021_csv}")
dgr_2021_df = pd.read_csv(dgr_2021_csv)

# Rename columns, remove french portion
dgr_2021_df.rename(columns={
    'PRDGUID_PRIDUGD': 'pr_dguid',
    'CDDGUID_DRIDUGD': 'cd_dguid',
    'FEDDGUID_CEFIDUGD': 'fed_dguid',
    'CSDDGUID_SDRIDUGD': 'csd_dguid',
    'ERDGUID_REIDUGD': 'er_dguid',
    'CARDGUID_RARIDUGD': 'car_dguid',
    'CCSDGUID_SRUIDUGD': 'ccs_dguid',
    'DADGUID_ADIDUGD': 'da_dguid',
    'DBDGUID_IDIDUGD': 'db_dguid',
    'ADADGUID_ADAIDUGD': 'ada_dguid',
    'DPLDGUID_LDIDUGD': 'dpl_dguid',
    'CMAPDGUID_RMRPIDUGD': 'cma_p_dguid',
    'CMADGUID_RMRIDUGD': 'cma_dguid',
    'CTDGUID_SRIDUGD': 'ct_dguid',
    'POPCTRPDGUID_CTRPOPPIDUGD': 'pop_ctr_p_dguid',
    'POPCTRDGUID_CTRPOPIDUGD': 'pop_ctr_dguid',
}, inplace=True)

columns_ordered = ['pr_dguid', 'fed_dguid', 'er_dguid', 'car_dguid', 'cd_dguid',
                   'dpl_dguid', 'ccs_dguid', 'csd_dguid', 
                   'cma_p_dguid', 'cma_dguid',
                   'pop_ctr_p_dguid', 'pop_ctr_dguid', 
                   'ada_dguid', 'ct_dguid', 'da_dguid', 'db_dguid']

dgr_2021_df = dgr_2021_df.reindex(columns_ordered, axis=1)
print("Loading processed 2021 dissemination geographies relationship file to database as dissemination_geographies_relationship_2021")
dgr_2021_df.to_sql(name='dissemination_geographies_relationship_2021', 
                   con=engine, 
                   index=False, 
                   chunksize=50000,
                   if_exists='replace',
                   schema='silver'
                  )