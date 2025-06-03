#!/bin/bash
if [ ! -d "${DATA_FOLDER}/boundaries" ]
then
    echo "Making directory ${DATA_FOLDER}/boundaries/"
    mkdir -p ${DATA_FOLDER}/boundaries/{input,extracted,output}/{2021,2016,2011,2001}
fi

INPUT_FOLDER="${DATA_FOLDER}/boundaries/input"

echo "Downloading 2021 boundaries"
aria2c -x16 -i "${SCRIPT_DIR}/boundaries/boundary_files_2021.txt" --dir=${INPUT_FOLDER}/2021 --auto-file-renaming=false
echo "Downloading 2016 boundaries"
aria2c -x16 -i "${SCRIPT_DIR}/boundaries/boundary_files_2016.txt" --dir=${INPUT_FOLDER}/2016 --auto-file-renaming=false
echo "Downloading 2011 boundaries"
aria2c -x16 -i "${SCRIPT_DIR}/boundaries/boundary_files_2011.txt" --dir=${INPUT_FOLDER}/2011 --auto-file-renaming=false
echo "Downloading 2006 boundaries"
aria2c -x16 -i "${SCRIPT_DIR}/boundaries/boundary_files_2006.txt" --dir=${INPUT_FOLDER}/2006 --auto-file-renaming=false
echo "Downloading 2001 boundaries"
aria2c -x16 -i "${SCRIPT_DIR}/boundaries/boundary_files_2001.txt" --dir=${INPUT_FOLDER}/2001 --auto-file-renaming=false