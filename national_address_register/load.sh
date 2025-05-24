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
        -t_srs EPSG:3857 \
        -nln ${table_name} \
        ${extra_parameters} \
        ${filepath}
}

concatenate_csvs() {
    # Concatenates all of the CSVs in the directory
    local input_directory=$1
    local output_file=$2
    for address_file in $(ls ${input_directory}/*.csv);
    do
        echo "Processing ${address_file}. Adding to ${output_file}"
        tail -n +2 $address_file >> ${output_file}
    done
}

INPUT_FOLDER="${DATA_FOLDER}/national_address_register/input"
EXTRACTED_FOLDER="${DATA_FOLDER}/national_address_register/extracted"
SCRATCH_FOLDER="${DATA_FOLDER}/national_address_register/scratch"

import_202412() {
    # Process 202412
    # Extract files
    echo "Extracting ${INPUT_FOLDER}/202412.zip"
    unzip -q -n ${INPUT_FOLDER}/202412.zip -d ${EXTRACTED_FOLDER}/202412
    if [ ! -f ${SCRATCH_FOLDER}/statcan_nar_addresses_202412.csv ]
    then
        echo "Adding header file to ${SCRATCH_FOLDER}/statcan_nar_addresses_202412.csv"
        echo "LOC_GUID,ADDR_GUID,APT_NO_LABEL,CIVIC_NO,CIVIC_NO_SUFFIX,OFFICIAL_STREET_NAME,OFFICIAL_STREET_TYPE,OFFICIAL_STREET_DIR,PROV_CODE,CSD_ENG_NAME,CSD_FRE_NAME,CSD_TYPE_ENG_CODE,CSD_TYPE_FRE_CODE,MAIL_STREET_NAME,MAIL_STREET_TYPE,MAIL_STREET_DIR,MAIL_MUN_NAME,MAIL_PROV_ABVN,MAIL_POSTAL_CODE,BG_DLS_LSD,BG_DLS_QTR,BG_DLS_SCTN,BG_DLS_TWNSHP,BG_DLS_RNG,BG_DLS_MRD,BG_X,BG_Y,BU_N_CIVIC_ADD,BU_USE" > ${SCRATCH_FOLDER}/statcan_nar_addresses_202412.csv
    fi
    
    if [ $(head ${SCRATCH_FOLDER}/statcan_nar_addresses_202412.csv | wc -l) -ne 10 ]
    then
        echo "Appending Addresses CSVs to ${SCRATCH_FOLDER}/statcan_nar_addresses_202412.csv"
        concatenate_csvs "${EXTRACTED_FOLDER}/202412/Addresses" "${SCRATCH_FOLDER}/statcan_nar_addresses_202412.csv"
    fi
    
    if [ ! -f ${SCRATCH_FOLDER}/statcan_nar_locations_202412.csv ]
    then
        echo "Adding header file to ${SCRATCH_FOLDER}/statcan_nar_locations_202412.csv"
        echo "LOC_GUID,CSD_CODE,FED_CODE,FED_ENG_NAME,FED_FRE_NAME,ER_CODE,ER_ENG_NAME,ER_FRE_NAME,REPPOINT_LATITUDE,REPPOINT_LONGITUDE" > ${SCRATCH_FOLDER}/statcan_nar_locations_202412.csv      
    fi
    
    if [ $(head ${SCRATCH_FOLDER}/statcan_nar_locations_202412.csv | wc -l) -ne 10 ]
    then
        echo "Appending Addresses CSVs to ${SCRATCH_FOLDER}/statcan_nar_locations_202412.csv"   
        concatenate_csvs "${EXTRACTED_FOLDER}/202412/Locations" "${SCRATCH_FOLDER}/statcan_nar_locations_202412.csv"
    fi
    python national_address_register/process.py ${SCRATCH_FOLDER}/statcan_nar_addresses_202412.csv ${SCRATCH_FOLDER}/statcan_nar_locations_202412.csv 202412 utf-8
}

import_202406() {
    # Process 202406
    echo "Extracting ${INPUT_FOLDER}/2024.zip"
    unzip -q -n ${INPUT_FOLDER}/2024.zip -d ${EXTRACTED_FOLDER}/202406
    if [ ! -f ${SCRATCH_FOLDER}/statcan_nar_addresses_202406.csv ]
    then
        echo "Adding header file to ${SCRATCH_FOLDER}/statcan_nar_addresses_202406.csv"
        echo "LOC_GUID,ADDR_GUID,APT_NO_LABEL,CIVIC_NO,CIVIC_NO_SUFFIX,OFFICIAL_STREET_NAME,OFFICIAL_STREET_TYPE,OFFICIAL_STREET_DIR,PROV_CODE,CSD_ENG_NAME,CSD_FRE_NAME,CSD_TYPE_ENG_CODE,CSD_TYPE_FRE_CODE,MAIL_STREET_NAME,MAIL_STREET_TYPE,MAIL_STREET_DIR,MAIL_MUN_NAME,MAIL_PROV_ABVN,MAIL_POSTAL_CODE,BG_DLS_LSD,BG_DLS_QTR,BG_DLS_SCTN,BG_DLS_TWNSHP,BG_DLS_RNG,BG_DLS_MRD,BG_X,BG_Y,BU_N_CIVIC_ADD,BU_USE" > ${SCRATCH_FOLDER}/statcan_nar_addresses_202406.csv
    fi
    
    if [ $(head ${SCRATCH_FOLDER}/statcan_nar_addresses_202406.csv | wc -l) -ne 10 ]
    then
        echo "Appending Addresses CSVs to ${SCRATCH_FOLDER}/statcan_nar_addresses_202406.csv"
        concatenate_csvs "${EXTRACTED_FOLDER}/202406/Addresses" "${SCRATCH_FOLDER}/statcan_nar_addresses_202406.csv"
    fi
    
    if [ ! -f ${SCRATCH_FOLDER}/statcan_nar_locations_202406.csv ]
    then
        echo "Adding header file to ${SCRATCH_FOLDER}/statcan_nar_locations_202406.csv"
        echo "LOC_GUID,CSD_CODE,FED_CODE,FED_ENG_NAME,FED_FRE_NAME,ER_CODE,ER_ENG_NAME,ER_FRE_NAME,REPPOINT_LATITUDE,REPPOINT_LONGITUDE" > ${SCRATCH_FOLDER}/statcan_nar_locations_202406.csv      
    fi
    
    if [ $(head ${SCRATCH_FOLDER}/statcan_nar_locations_202406.csv | wc -l) -ne 10 ]
    then
        echo "Appending Addresses CSVs to ${SCRATCH_FOLDER}/statcan_nar_locations_202406.csv"   
        concatenate_csvs "${EXTRACTED_FOLDER}/202406/Locations" "${SCRATCH_FOLDER}/statcan_nar_locations_202406.csv"
    fi
    python national_address_register/process.py ${SCRATCH_FOLDER}/statcan_nar_addresses_202406.csv ${SCRATCH_FOLDER}/statcan_nar_locations_202406.csv 202406 utf-8
}

import_2023() {
    # Process 2023
    echo "Extracting ${INPUT_FOLDER}/2023.zip"
    unzip -q -n ${INPUT_FOLDER}/2023.zip -d ${EXTRACTED_FOLDER}/2023
    if [ ! -f ${SCRATCH_FOLDER}/statcan_nar_addresses_2023.csv ]
    then
        echo "Adding header file to ${SCRATCH_FOLDER}/statcan_nar_addresses_2023.csv"
        echo "LOC_GUID,ADDR_GUID,APT_NO_LABEL,CIVIC_NO,CIVIC_NO_SUFFIX,OFFICIAL_STREET_NAME,OFFICIAL_STREET_TYPE,OFFICIAL_STREET_DIR,PROV_CODE,CSD_ENG_NAME,CSD_FRE_NAME,CSD_TYPE_ENG_CODE,CSD_TYPE_FRE_CODE,MAIL_STREET_NAME,MAIL_STREET_TYPE,MAIL_STEET_DIR,MAIL_MUN_NAME,MAIL_PROV_ABVN,MAIL_POSTAL_CODE,BG_DLS_LSD,BG_DLS_QTR,BG_DLS_SCTN,BG_DLS_TWNSHP,BG_DLS_RNG,BG_DLS_MRD,BG_X,BG_Y,BU_N_CIVIC_ADD,BU_USE" > ${SCRATCH_FOLDER}/statcan_nar_addresses_2023.csv
    fi
    
    if [ $(head ${SCRATCH_FOLDER}/statcan_nar_addresses_2023.csv | wc -l) -ne 10 ]
    then
        echo "Appending Addresses CSVs to ${SCRATCH_FOLDER}/statcan_nar_addresses_2023.csv"
        concatenate_csvs "${EXTRACTED_FOLDER}/2023/Addresses" "${SCRATCH_FOLDER}/statcan_nar_addresses_2023.csv"
    fi
    
    if [ ! -f ${SCRATCH_FOLDER}/statcan_nar_locations_2023.csv ]
    then
        echo "Adding header file to ${SCRATCH_FOLDER}/statcan_nar_locations_2023.csv"
        echo "LOC_GUID,CSD_CODE,FED_2021_CODE,FED_2021_ENG_NAME,FED_2021_FRE_NAME,ER_2021_CODE,ER_2021_ENG_NAME,ER_2021_FRE_NAME,REPPOINT_LATITUDE,REPPOINT_LONGITUDE" > ${SCRATCH_FOLDER}/statcan_nar_locations_2023.csv      
    fi
    
    if [ $(head ${SCRATCH_FOLDER}/statcan_nar_locations_2023.csv | wc -l) -ne 10 ]
    then
        echo "Appending Addresses CSVs to ${SCRATCH_FOLDER}/statcan_nar_locations_2023.csv"   
        concatenate_csvs "${EXTRACTED_FOLDER}/2022/Locations" "${SCRATCH_FOLDER}/statcan_nar_locations_2023.csv"
    fi
    python national_address_register/process.py ${SCRATCH_FOLDER}/statcan_nar_addresses_2023.csv ${SCRATCH_FOLDER}/statcan_nar_locations_2023.csv 2023 latin-1
}

import_2022() {
    # Process 2022
    echo "Extracting ${INPUT_FOLDER}/2022.zip"
    unzip -q -n ${INPUT_FOLDER}/2022.zip -d ${EXTRACTED_FOLDER}/2022
    if [ ! -f ${SCRATCH_FOLDER}/statcan_nar_addresses_2022.csv ]
    then
        echo "Adding header file to ${SCRATCH_FOLDER}/statcan_nar_addresses_2022.csv"
        echo "LOC_GUID,ADDR_GUID,CIVIC_NO,CIVIC_NO_SUFFIX,APT_NO_LABEL,OFFICIAL_STREET_NAME,OFFICIAL_STREET_TYPE,OFFICIAL_STREET_DIR,PROV_CODE,CSD_ENG_NAME,CSD_FRE_NAME,CSD_TYPE_ENG_CODE,CSD_TYPE_FRE_CODE,MAIL_STREET_NAME,MAIL_STREET_TYPE,MAIL_STREET_DIR,MAIL_MUN_NAME,MAIL_POSTAL_CODE,MAIL_PROV_ABVN,BG_DLS_LSD,BG_DLS_QTR,BG_DLS_SCTN,BG_DLS_TWNSHP,BG_DLS_RNG,BG_DLS_MRD,BG_X,BG_Y,BU_N_CIVIC_ADD,BU_USE" > ${SCRATCH_FOLDER}/statcan_nar_addresses_2022.csv
    fi
    
    if [ $(head ${SCRATCH_FOLDER}/statcan_nar_addresses_2022.csv | wc -l) -ne 10 ]
    then
        echo "Appending Addresses CSVs to ${SCRATCH_FOLDER}/statcan_nar_addresses_2022.csv"
        concatenate_csvs "${EXTRACTED_FOLDER}/2022/Addresses" "${SCRATCH_FOLDER}/statcan_nar_addresses_2022.csv"
    fi
    
    if [ ! -f ${SCRATCH_FOLDER}/statcan_nar_locations_2022.csv ]
    then
        echo "Adding header file to ${SCRATCH_FOLDER}/statcan_nar_locations_2022.csv"
        echo "LOC_GUID,CSD_CODE,FED_2016_CODE,FED_2016_ENG_NAME,FED_2016_FRE_NAME,ER_2016_CODE,ER_2016_ENG_NAME,ER_2016_FRE_NAME,REPPOINT_LATITUDE,REPPOINT_LONGITUDE" > ${SCRATCH_FOLDER}/statcan_nar_locations_2022.csv      
    fi
    
    if [ $(head ${SCRATCH_FOLDER}/statcan_nar_locations_2022.csv | wc -l) -ne 10 ]
    then
        echo "Appending Addresses CSVs to ${SCRATCH_FOLDER}/statcan_nar_locations_2022.csv"   
        concatenate_csvs "${EXTRACTED_FOLDER}/2022/Locations" "${SCRATCH_FOLDER}/statcan_nar_locations_2022.csv"
    fi
    python national_address_register/process.py ${SCRATCH_FOLDER}/statcan_nar_addresses_2022.csv ${SCRATCH_FOLDER}/statcan_nar_locations_2022.csv 2022 latin-1
}

import_202412
import_202406
import_2023
import_2022