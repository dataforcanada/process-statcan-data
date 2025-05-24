#!/bin/bash
if [ ! -d "${DATA_FOLDER}/geographic_attribute_file" ]
then
    echo "Making directory ${DATA_FOLDER}/geographic_attribute_file/"
    mkdir -p ${DATA_FOLDER}/geographic_attribute_file/{input,extracted,output}
fi

INPUT_FOLDER="${DATA_FOLDER}/geographic_attribute_file/input"

echo "Downloading 2021 geographic attribute file"
aria2c -x16 -i "${SCRIPT_DIR}/geographic_attribute_file/files.txt" --dir=${INPUT_FOLDER} --auto-file-renaming=false
