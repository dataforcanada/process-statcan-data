#!/bin/bash

INPUT_FOLDER="${DATA_FOLDER}/dissemination_geographies_relationship_file/input"
EXTRACTED_FOLDER="${DATA_FOLDER}/dissemination_geographies_relationship_file/extracted"

import_2021() {   
    echo "Unzipping 2021 dissemination geographies relationship file"
    unzip -n "${INPUT_FOLDER}/2021_98260004.zip" -d ${EXTRACTED_FOLDER}
    python dissemination_geographies_relationship_file/process.py ${EXTRACTED_FOLDER}/2021_98260004.csv
}

import_2021
