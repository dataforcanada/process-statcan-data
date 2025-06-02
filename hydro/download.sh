#!/bin/bash
if [ ! -d "${DATA_FOLDER}/hydro" ]
then
    echo "Making directory ${DATA_FOLDER}/hydro/"
    mkdir -p ${DATA_FOLDER}/hydro/{input,extracted,output}/{2021,2016,2011,2006}
fi

INPUT_FOLDER="${DATA_FOLDER}/hydro/input"

echo "Downloading 2021 hydro"
aria2c -x16 -i "${SCRIPT_DIR}/hydro/hydro_2021.txt" --dir=${INPUT_FOLDER}/2021 --auto-file-renaming=false
echo "Downloading 2016 hydro"
aria2c -x16 -i "${SCRIPT_DIR}/hydro/hydro_2016.txt" --dir=${INPUT_FOLDER}/2016 --auto-file-renaming=false
echo "Downloading 2011 boundaries"
aria2c -x16 -i "${SCRIPT_DIR}/hydro/hydro_2011.txt" --dir=${INPUT_FOLDER}/2011 --auto-file-renaming=false
echo "Downloading 2006 boundaries"
aria2c -x16 -i "${SCRIPT_DIR}/hydro/hydro_2006.txt" --dir=${INPUT_FOLDER}/2006 --auto-file-renaming=false
