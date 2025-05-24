#!/bin/bash
if [ ! -d "${DATA_FOLDER}/census_of_population" ]
then
    echo "Making directory ${DATA_FOLDER}/census_of_population/"
    mkdir -p ${DATA_FOLDER}/census_of_population/{input,extracted,output}/{2021,2016,2011,2001}
    mkdir -p ${DATA_FOLDER}/census_of_population/output/{2021,2016,2011,2001}/{tabular,spatial}
fi

INPUT_FOLDER="${DATA_FOLDER}/census_of_population/input"

echo "Downloading 2021 Census of Population"
aria2c -x16 -i "${SCRIPT_DIR}/census_of_population/census_of_population_files_2021.txt" --dir=${INPUT_FOLDER}/2021 --auto-file-renaming=false

echo "Downloading 2016 Census of Population"
aria2c -x16 -i "${SCRIPT_DIR}/census_of_population/census_of_population_files_2016.txt" --dir=${INPUT_FOLDER}/2016 --auto-file-renaming=false

echo "Downloading 2011 Census of Population"
aria2c -x16 -i "${SCRIPT_DIR}/census_of_population/census_of_population_files_2011.txt" --dir=${INPUT_FOLDER}/2011 --auto-file-renaming=false

#echo "Downloading 2006 Census of Population"
#aria2c -x16 -i "${SCRIPT_DIR}/census_of_population/census_of_population_files_2006.txt" --dir=${INPUT_FOLDER}/2006 --auto-file-renaming=false
#
#echo "Downloading 2001 Census of Population"
#aria2c -x16 -i "${SCRIPT_DIR}/census_of_population/census_of_population_files_2001.txt" --dir=${INPUT_FOLDER}/2001 --auto-file-renaming=false