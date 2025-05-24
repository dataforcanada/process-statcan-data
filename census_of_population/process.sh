#!/bin/bash

INPUT_FOLDER="${DATA_FOLDER}/census_of_population/input"
EXTRACTED_FOLDER="${DATA_FOLDER}/census_of_population/extracted"

process_2021() {
    echo "Processing 2021 Census of Population"
    jupyter execute census_of_population/process_2021.ipynb
}

extract_2021() {
    local INPUT_FOLDER="${INPUT_FOLDER}/2021"
    local EXTRACTED_FOLDER="${EXTRACTED_FOLDER}/2021"
    echo "Extracting Canada, provinces, territories (PRs), census divisions (CDs), census subdivisions (CSDs) and dissemination areas (DAs) (${INPUT_FOLDER}/98-401-X2021006_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2021006_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2021006_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2021006_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2021006_eng_CSV
    
    echo "Extracting Census metropolitan areas (CMAs), tracted census agglomerations (CAs) and census tracts (CTs) (${INPUT_FOLDER}/98-401-X2021007_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2021007_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2021007_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2021007_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2021007_eng_CSV
    
    echo "Extracting Economic regions (ERs) (${INPUT_FOLDER}/98-401-X2021008_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2021008_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2021008_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2021008_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2021008_eng_CSV
    
    echo "Extracting Population centres (POPCTRs) (${INPUT_FOLDER}/98-401-X2021009_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2021009_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2021009_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2021009_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2021009_eng_CSV
    
    echo "Extracting Federal electoral districts, 2013 representation order (${INPUT_FOLDER}/98-401-X2021010_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2021010_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2021010_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2021010_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2021010_eng_CSV

    echo "Extracting Federal electoral districts, 2023 representation order (${INPUT_FOLDER}/98-401-X2021029_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2021029_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2021029_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2021029_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2021029_eng_CSV

    echo "Extracting Designated places (DPLs) (${INPUT_FOLDER}/98-401-X2021011_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2021011_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2021011_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2021011_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2021011_eng_CSV

    echo "Extracting Aggregate dissemination areas (ADAs) (${INPUT_FOLDER}/98-401-X2021012_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2021012_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2021012_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2021012_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2021012_eng_CSV
    
    echo "Extracting Forward Sortation Areas (FSAs) (${INPUT_FOLDER}/98-401-X2021013_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2021013_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2021013_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2021013_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2021013_eng_CSV
    
    echo "Extracting Dissolved census subdivisions (Dissolved CSDs) (98-401-X2021014_eng_CSV.zip)"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2021014_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2021014_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2021014_eng_CSV
    
    echo "Extracting Health Regions (HRs) and Home and Community Care Support Services (HCCCSS) 2022 (${INPUT_FOLDER}/98-401-X2021015_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2021009_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2021015_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2021015_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2021015_eng_CSV
}

extract_2016() {
    local INPUT_FOLDER="${INPUT_FOLDER}/2016"
    local EXTRACTED_FOLDER="${EXTRACTED_FOLDER}/2016"
    echo "Extracting Canada, provinces, territories (PRs), census divisions (CDs), census subdivisions (CSDs) and dissemination areas (DAs) (${INPUT_FOLDER}/98-401-X2016044_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2016044_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2016044_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2016044_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2016044_eng_CSV
    
    echo "Extracting Census metropolitan areas (CMAs), tracted census agglomerations (CAs) and census tracts (CTs) (${INPUT_FOLDER}/98-401-X2016044_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2016044_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2016044_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2016044_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2016044_eng_CSV
    
    echo "Extracting Economic regions (ERs) (${INPUT_FOLDER}/98-401-X2016049_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2016049_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2016049_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2016049_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2016049_eng_CSV
    
    echo "Extracting Population centres (POPCTRs) (${INPUT_FOLDER}/98-401-X2016048_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2016048_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2016048_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2016048_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2016048_eng_CSV
    
    echo "Extracting Canada, provinces, territories and federal electoral districts (FEDs) (2013 Representation Order) (${INPUT_FOLDER}/98-401-X2016045_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2016045_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2016045_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2016045_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2016045_eng_CSV

    echo "Extracting Designated places (DPLs) (${INPUT_FOLDER}/98-401-X2016047_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2016047_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2016047_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2016047_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2016047_eng_CSV

    echo "Extracting Aggregate dissemination areas (ADAs) (${INPUT_FOLDER}/98-401-X2016050_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2016050_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2016050_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2016050_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2016050_eng_CSV
    
    echo "Extracting Forward Sortation Areas (FSAs) (${INPUT_FOLDER}/98-401-X2016046_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2016046_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2016046_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2016046_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2016046_eng_CSV
    
    echo "Extracting Health Regions (HRs) (${INPUT_FOLDER}/98-401-X2016058_eng_CSV.zip). Extracting to ${EXTRACTED_FOLDER}/98-401-X2016058_eng_CSV"
    mkdir -p "${EXTRACTED_FOLDER}/98-401-X2016058_eng_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-401-X2016058_eng_CSV.zip -d ${EXTRACTED_FOLDER}/98-401-X2016058_eng_CSV
}

extract_2011() {
    local INPUT_FOLDER="${INPUT_FOLDER}/2011"
    local EXTRACTED_FOLDER="${EXTRACTED_FOLDER}/2011"
    
    echo "Extracting Canada, provinces, territories (PRs) (98-316-XWE2011001-101_CSV.zip)"
    mkdir -p "${EXTRACTED_FOLDER}/98-316-XWE2011001-101_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-316-XWE2011001-101_CSV.zip -d ${EXTRACTED_FOLDER}/98-316-XWE2011001-101_CSV
    
    echo "Extracting Census divisions (CDs) (98-316-XWE2011001-701_CSV.zip)"
    mkdir -p "${EXTRACTED_FOLDER}/98-316-XWE2011001-701_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-316-XWE2011001-701_CSV.zip -d ${EXTRACTED_FOLDER}/98-316-XWE2011001-701_CSV
    
    echo "Extracting Census metropolitan areas (CMAs), tracted census agglomerations (CAs) (98-316-XWE2011001-201_CSV.zip)"
    mkdir -p "${EXTRACTED_FOLDER}/98-316-XWE2011001-201_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-316-XWE2011001-201_CSV.zip -d ${EXTRACTED_FOLDER}/98-316-XWE2011001-201_CSV
    
    echo "Extracting Census tracts (CTs) (98-316-XWE2011001-401_CSV.zip)"
    mkdir -p "${EXTRACTED_FOLDER}/98-316-XWE2011001-401_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-316-XWE2011001-401_CSV.zip -d ${EXTRACTED_FOLDER}/98-316-XWE2011001-401_CSV
    
    echo "Extracting Federal electoral districts (2003 representation order) (98-316-XWE2011001-501_CSV.zip)"
    mkdir -p "${EXTRACTED_FOLDER}/98-316-XWE2011001-501_CSV.zip"
    unzip -q -n ${INPUT_FOLDER}/98-316-XWE2011001-501_CSV.zip -d ${EXTRACTED_FOLDER}/98-316-XWE2011001-501_CSV.zip

    echo "Extracting Federal electoral districts (2013 representation order) (98-316-XWE2011001-511_CSV.zip)"
    mkdir -p "${EXTRACTED_FOLDER}/98-316-XWE2011001-511_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-316-XWE2011001-511_CSV.zip -d ${EXTRACTED_FOLDER}/98-316-XWE2011001-511_CSV

    echo "Extracting Economic regions (ERs) (98-316-XWE2011001-901_CSV.zip)"
    mkdir -p "${EXTRACTED_FOLDER}/98-316-XWE2011001-901_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-316-XWE2011001-901_CSV.zip -d ${EXTRACTED_FOLDER}/98-316-XWE2011001-901_CSV
    
    echo "Extracting Designated places (98-316-XWE2011001-1301_CSV.zip)"
    mkdir -p "${EXTRACTED_FOLDER}/98-316-XWE2011001-1301_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-316-XWE2011001-1301_CSV.zip -d ${EXTRACTED_FOLDER}/98-316-XWE2011001-1301_CSV
    
    echo "Extracting Population centres (POPCTRs) (98-316-XWE2011001-801_CSV.zip)"
    mkdir -p "${EXTRACTED_FOLDER}/98-316-XWE2011001-801_CSV"
    unzip -q -n ${INPUT_FOLDER}/98-316-XWE2011001-801_CSV.zip -d ${EXTRACTED_FOLDER}/98-316-XWE2011001-801_CSV
}

extract_2006() {
    local INPUT_FOLDER="${INPUT_FOLDER}/2006"
    local EXTRACTED_FOLDER="${EXTRACTED_FOLDER}/2006"
}

extract_2001() {
    local INPUT_FOLDER="${INPUT_FOLDER}/2001"
    local EXTRACTED_FOLDER="${EXTRACTED_FOLDER}/2001"
}

extract_2021
extract_2016
extract_2011
extract_2006

process_2021