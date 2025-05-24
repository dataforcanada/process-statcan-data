#!/bin/bash

INPUT_FOLDER="${DATA_FOLDER}/geosuite/input"
EXTRACTED_FOLDER="${DATA_FOLDER}/geosuite/extracted"

import_2021() {   
    echo "Unzipping 2021 geosuite data"
    unzip -n "${INPUT_FOLDER}/2021_92-150-X_eng.zip" -d ${EXTRACTED_FOLDER}
    python geosuite/process.py ${EXTRACTED_FOLDER}/2021_92-150-X_eng/PN.csv
}

import_2021