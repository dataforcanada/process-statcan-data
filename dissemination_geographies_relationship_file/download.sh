#!/bin/bash
if [ ! -d "${DATA_FOLDER}/dissemination_geographies_relationship_file" ]
then
    echo "Making directory ${DATA_FOLDER}/dissemination_geographies_relationship_file/"
    mkdir -p ${DATA_FOLDER}/dissemination_geographies_relationship_file/{input,extracted,output}
fi

INPUT_FOLDER="${DATA_FOLDER}/dissemination_geographies_relationship_file/input"

echo "Downloading 2021 dissemiantion geographies relationship file"
aria2c -x16 -i "${SCRIPT_DIR}/dissemination_geographies_relationship_file/files.txt" --dir=${INPUT_FOLDER} --auto-file-renaming=false