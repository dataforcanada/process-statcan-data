#!/bin/bash

import_to_postgis() {
    local filepath=$1
    local table_name=$2
    local extra_parameters=${@:3}

    # Virtual file system
    if [[ ${filepath: -4} = '.zip' ]]; then
        local filepath="/vsizip/${filepath}"
    fi

    echo "Importing ${filepath}"
    ogr2ogr \
        --config PG_USE_COPY YES \
        -overwrite \
        -f "PostgreSQL" \
        "PG:host=db dbname=${POSTGRES_DB} user=${POSTGRES_USER} password=${POSTGRES_PASSWORD} port=5432" \
        -lco GEOMETRY_NAME=geom \
        -progress \
        -gt 500000 \
        -t_srs EPSG:4326 \
        -nln ${table_name} \
        ${extra_parameters} \
        ${filepath}
}

INPUT_FOLDER="${DATA_FOLDER}/health_regions/input"
EXTRACTED_FOLDER="${DATA_FOLDER}/health_regions/extracted"

import_to_postgis ${INPUT_FOLDER}/hr2024001.zip statcan_hr2024001_tmp "-nlt PROMOTE_TO_MULTI"
import_to_postgis ${INPUT_FOLDER}/hr2023001.zip statcan_hr2023001_tmp "-nlt PROMOTE_TO_MULTI"
unzip -n ${INPUT_FOLDER}/hr2018001.zip -d ${EXTRACTED_FOLDER}
import_to_postgis ${EXTRACTED_FOLDER}/HR_000a18a_e/HR_000a18a_e.shp statcan_hr2018001_tmp "-select HR_UID,ENGNAME,FRENAME -nlt PROMOTE_TO_MULTI"
unzip -n ${INPUT_FOLDER}/hr2017001.zip -d ${EXTRACTED_FOLDER}
import_to_postgis ${EXTRACTED_FOLDER}/HR_000a17a_e/HR_000a17a_e_Dec2017.shp statcan_hr2017001_tmp "-select HR_UID,ENG_LABEL,FRE_LABEL -nlt PROMOTE_TO_MULTI"
import_to_postgis ${INPUT_FOLDER}/hr2015002.zip statcan_hr2015002_tmp "-nlt PROMOTE_TO_MULTI"
import_to_postgis ${INPUT_FOLDER}/hr2015001.zip statcan_hr2015001_tmp "-select HR_UID,ENG_LABEL,FRE_LABEL -nlt PROMOTE_TO_MULTI"
import_to_postgis ${INPUT_FOLDER}/hr2013003.zip statcan_hr2013003_tmp "-select HR_UID,ENG_LABEL,FRE_LABEL -nlt PROMOTE_TO_MULTI"
import_to_postgis ${INPUT_FOLDER}/hr2013002.zip statcan_hr2013002_tmp "-select HR_UID,ENG_LABEL,FRE_LABEL -nlt PROMOTE_TO_MULTI"
import_to_postgis ${INPUT_FOLDER}/hr2013001.zip statcan_hr2013001_tmp "-select PR_HRUID,ENG_LABEL,FRE_LABEL -nlt PROMOTE_TO_MULTI"
import_to_postgis ${INPUT_FOLDER}/hr2011001.zip statcan_hr2011001_tmp "-select PR_HRUID,ENG_LABEL,FRE_LABEL -nlt PROMOTE_TO_MULTI"
import_to_postgis ${INPUT_FOLDER}/hr2009001.zip statcan_hr2009001_tmp "-select HRUID2007,ENG_LABEL,FRE_LABEL -nlt PROMOTE_TO_MULTI"
import_to_postgis ${INPUT_FOLDER}/hr2007001.zip statcan_hr2007001_tmp "-select PR_HRUID,HRNAME,FRNAME -nlt PROMOTE_TO_MULTI"
import_to_postgis ${INPUT_FOLDER}/hr2006001.zip statcan_hr2006001_tmp "-select PR_HRUID,HRNAME,FRNAME -nlt PROMOTE_TO_MULTI"
import_to_postgis ${INPUT_FOLDER}/hr2005001.zip statcan_hr2005001_tmp "-select PR_HRUID,HRNAME,FRNAME -nlt PROMOTE_TO_MULTI"
import_to_postgis ${INPUT_FOLDER}/hr2004001.zip statcan_hr2004001_tmp "-select PR_HRUID,HRNAME -nlt PROMOTE_TO_MULTI"
import_to_postgis ${INPUT_FOLDER}/hr2003001.zip statcan_hr2003001_tmp "-select PR_HRUID,HRNAME -nlt PROMOTE_TO_MULTI"
