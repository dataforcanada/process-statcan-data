#!/bin/bash
if [ ! -d "${DATA_FOLDER}/census_of_agriculture" ]
then
    echo "Making directory ${DATA_FOLDER}/census_of_agriculture/"
    mkdir -p ${DATA_FOLDER}/census_of_agriculture/{input,extracted,output}/{2021,2016,2011,2001}
    mkdir -p ${DATA_FOLDER}/census_of_agriculture/output/{2021,2016,2011,2001}/{tabular,spatial}
fi

INPUT_FOLDER="${DATA_FOLDER}/census_of_agriculture/input"

echo "Downloading 2021 Census of Agriculture"
aria2c -x16 -i "${SCRIPT_DIR}/census_of_agriculture/census_of_agriculture_2021.txt" --dir=${INPUT_FOLDER}/2021 --auto-file-renaming=false

echo "Downloading 2016 Census of Agriculture"
aria2c -x16 -i "${SCRIPT_DIR}/census_of_agriculture/census_of_agriculture_2016.txt" --dir=${INPUT_FOLDER}/2016 --auto-file-renaming=false