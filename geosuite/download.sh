#!/bin/bash
if [ ! -d "${DATA_FOLDER}/geosuite" ]
then
    echo "Making directory ${DATA_FOLDER}/geosuite/"
    mkdir -p ${DATA_FOLDER}/geosuite/{input,extracted,output}
fi

INPUT_FOLDER="${DATA_FOLDER}/geosuite/input"

echo "Downloading geosuite files"
aria2c -x16 -i "${SCRIPT_DIR}/geosuite/files.txt" --dir=${INPUT_FOLDER} --auto-file-renaming=false
