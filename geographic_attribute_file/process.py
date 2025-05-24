#!/usr/bin/env python
# coding: utf-8
import os
import sys

import numpy as np
import pandas as pd
from sqlalchemy import create_engine

filename = sys.argv[1]

DATABASE = os.environ.get("POSTGRES_DB")
USER = os.environ.get("POSTGRES_USER")
PASSWORD = os.environ.get("POSTGRES_PASSWORD")

engine = create_engine(f"postgresql://{USER}:{PASSWORD}@db:5432/{DATABASE}")

"""
Data dictionary is here:
https://web.archive.org/web/20240918110218/https://www150.statcan.gc.ca/n1/pub/92-151-g/2021001/tbl/tbl4_1-eng.htm

This processes the entire DGUID hierarchy and other useful fields
"""
print(f"Processing {filename}")
params = {
    'filepath_or_buffer': filename,
    'encoding': 'latin-1',
    'usecols': ['PRDGUID_PRIDUGD', 'CDDGUID_DRIDUGD', 
                'FEDDGUID_CEFIDUGD', 'CSDDGUID_SDRIDUGD', 
                'DPLDGUID_LDIDUGD', 'ERDGUID_REIDUGD',
                'CCSDGUID_SRUIDUGD', 'SACTYPE_CSSGENRE', 'SACCODE_CSSCODE', 'CMAPDGUID_RMRPIDUGD', 'CMADGUID_RMRIDUGD',
                'CMATYPE_RMRGENRE', 'CTDGUID_SRIDUGD', 'POPCTRRAPDGUID_CTRPOPRRPIDUGD', 'POPCTRRADGUID_CTRPOPRRIDUGD',
                'DADGUID_ADIDUGD', 'DBDGUID_IDIDUGD',
                # 2021 Block population, private dwellings, usual residents
                'DBPOP2021_IDPOP2021', 'DBTDWELL2021_IDTLOG2021', 'DBURDWELL2021_IDRHLOG2021',
                # 2021 Census Indian reserve refusal flag
                'DBIR2021_IDRI2021',
                'ADADGUID_ADAIDUGD'
               ],
    # Apparently they have to be int64 because there's NA values
    'dtype': {
        'DBPOP2021_IDPOP2021': "Int64",
        'DBTDWELL2021_IDTLOG2021': "Int64",
        'DBURDWELL2021_IDRHLOG2021': "Int64"
    }
}
gaf_2021_df = pd.read_csv(**params)

# Rename columns, replace french portion
gaf_2021_df.rename(columns={
    'PRDGUID_PRIDUGD': 'pr_dguid',
    'CDDGUID_DRIDUGD': 'cd_dguid',
    'FEDDGUID_CEFIDUGD': 'fed_dguid',
    'CSDDGUID_SDRIDUGD': 'csd_dguid',
    'DPLDGUID_LDIDUGD': 'dpl_dguid',
    'ERDGUID_REIDUGD': 'er_dguid',
    'CCSDGUID_SRUIDUGD': 'ccs_dguid',
    'SACTYPE_CSSGENRE': 'sac_type',
    'SACCODE_CSSCODE': 'sac_code',
    'CMAPDGUID_RMRPIDUGD': 'cma_p_dguid',
    'CMADGUID_RMRIDUGD': 'cma_dguid',
    'CTDGUID_SRIDUGD': 'ct_dguid',
    'POPCTRRAPDGUID_CTRPOPRRPIDUGD': 'pop_ctr_p_dguid',
    'POPCTRRADGUID_CTRPOPRRIDUGD': 'pop_ctr_dguid',
    'DADGUID_ADIDUGD': 'da_dguid',
    'DBDGUID_IDIDUGD': 'db_dguid',
    'DBPOP2021_IDPOP2021': 'db_pop_2021',
    # This one needs work
    'DBTDWELL2021_IDTLOG2021': 'db_total_private_dwell_2021',
    # I don't particularly like this one
    'DBURDWELL2021_IDRHLOG2021': 'db_usual_residents_dwellings_2021',
    'DBIR2021_IDRI2021': 'db_ir_2021',
    'ADADGUID_ADAIDUGD': 'ada_dguid'
}, inplace=True)

columns_ordered = ['pr_dguid', 'fed_dguid', 'er_dguid', 'cd_dguid',
                   'dpl_dguid', 'ccs_dguid', 'csd_dguid', 'sac_type', 'sac_code',
                   'cma_p_dguid', 'cma_dguid',
                   'pop_ctr_p_dguid', 'pop_ctr_dguid', 
                   'ada_dguid', 'ct_dguid', 'da_dguid', 'db_dguid',
                   'db_pop_2021', 'db_total_private_dwell_2021', 'db_usual_residents_dwellings_2021', 'db_ir_2021']

gaf_2021_df = gaf_2021_df.reindex(columns_ordered, axis=1)
print("Loading 2021 geographic attribute file to PostgreSQL as gaf_2021")
gaf_2021_df.to_sql(name='gaf_2021', 
                   con=engine, 
                   index=False, 
                   chunksize=50000,
                   if_exists='replace',
                   schema='silver'
                  )