#!/bin/bash

import_to_postgis() {
    local filepath="$1"
    local table_name="$2"
    local extra_parameters="${@:3}"

    # Handle zip files using GDAL's virtual file system
    if [[ "${filepath: -4}" == ".zip" ]]; then
        filepath="/vsizip/${filepath}"
    fi

    echo "Importing ${filepath} into table bronze.${table_name}"
    ogr2ogr \
        --config PG_USE_COPY YES \
        -lco "OVERWRITE=YES" \
        -f "PostgreSQL" \
        "PG:host=db dbname=${POSTGRES_DB} user=${POSTGRES_USER} password=${POSTGRES_PASSWORD} port=5432" \
        -lco GEOMETRY_NAME=geom \
        -progress \
        -gt 500000 \
        -t_srs EPSG:4326 \
        -nln "${table_name}" \
        ${extra_parameters} \
        "${filepath}"
}

# Define input folders
INPUT_FOLDER="${DATA_FOLDER}/road_network_files/input"
EXTRACTED_FOLDER="${DATA_FOLDER}/road_network_files/extracted"

### 2021 Road Network File ###
# https://web.archive.org/web/20230307163203/https://www12.statcan.gc.ca/census-recensement/2021/geo/sip-pis/boundary-limites/index2021-eng.cfm?year=21
export PGCLIENTENCODING=LATIN-1;
import_to_postgis "${INPUT_FOLDER}/2021/lrnf000r21a_e.zip" lrnf000r21a_e "-lco COLUMN_TYPES=afl_val=integer,atl_val=integer,afr_val=integer,atr_val=integer -lco SCHEMA=bronze"
unset PGCLIENTENCODING

### 2016 Road Network File ###
# https://web.archive.org/web/20230120140926/https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2016-eng.cfm
import_to_postgis "${INPUT_FOLDER}/2016/lrnf000r16a_e.zip" lrnf000r16a_e "-lco COLUMN_TYPES=afl_val=integer,atl_val=integer,afr_val=integer,atr_val=integer -lco SCHEMA=bronze"

### 2011 Road Network File ###
# https://web.archive.org/web/20230110163150/https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2011-eng.cfm
export PGCLIENTENCODING=LATIN-1;
import_to_postgis "${INPUT_FOLDER}/2011/grnf000r11a_e.zip" grnf000r11a_e "-lco COLUMN_TYPES=afl_val=integer,atl_val=integer,afr_val=integer,atr_val=integer -lco SCHEMA=bronze"
unset PGCLIENTENCODING

### 2006 Road Network File ###
# https://web.archive.org/web/20221218043125/https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2006-eng.cfm
export PGCLIENTENCODING=LATIN-1;
import_to_postgis "${INPUT_FOLDER}/2006/grnf000r06a_e.zip" grnf000r06a_e "-lco COLUMN_TYPES=addr_fm_le=integer,addr_to_le=integer,addr_fm_rg=integer,addr_to_rg=integer -lco SCHEMA=bronze"
unset PGCLIENTENCODING

# TODO - get working
### 2001 Road Network Files ###
# https://web.archive.org/web/20221218043135/https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2001-eng.cfm
# Census Road Network file
#unzip -n ${INPUT_FOLDER}/grnf000r01m_e.zip -d ${EXTRACTED_FOLDER}
#import_to_postgis ${EXTRACTED_FOLDER}/grnf000r02ml_e.MID statcan_grnf000r02ml_e_tmp
## Census Skeletal Road Network File
#unzip -n ${INPUT_FOLDER}/gsrn000r01m_e.zip -d ${EXTRACTED_FOLDER}
#import_to_postgis ${DATA_FOLDER}/gsrn000r02m_e.MID statcan_gsrn000r02m_e_tmp