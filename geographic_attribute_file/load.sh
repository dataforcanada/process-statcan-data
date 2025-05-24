#!/bin/bash

INPUT_FOLDER="${DATA_FOLDER}/geographic_attribute_file/input"
EXTRACTED_FOLDER="${DATA_FOLDER}/geographic_attribute_file/extracted"

import_2021() {
    echo "Extracting ${INPUT_FOLDER}/2021_92-151_X.zip"
    unzip -q -n ${INPUT_FOLDER}/2021_92-151_X.zip -d ${EXTRACTED_FOLDER}
    python geographic_attribute_file/process.py ${EXTRACTED_FOLDER}/2021_92-151_X.csv
}

import_2021
