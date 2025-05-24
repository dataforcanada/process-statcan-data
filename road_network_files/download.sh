#!/bin/bash
if [ ! -d "${DATA_FOLDER}/road_network_files" ]
then
    echo "Making directory ${DATA_FOLDER}/road_network_files/"
    mkdir -p ${DATA_FOLDER}/road_network_files/{input,extracted,output}/{2021,2016,2011,2006}
fi

INPUT_FOLDER="${DATA_FOLDER}/road_network_files/input"

echo "Downloading 2021 road network file"
aria2c -x16 -i "${SCRIPT_DIR}/road_network_files/road_network_file_2021.txt" --dir="${INPUT_FOLDER}/2021" --auto-file-renaming=false
echo "Downloading 2016 road network file"
aria2c -x16 -i "${SCRIPT_DIR}/road_network_files/road_network_file_2016.txt" --dir="${INPUT_FOLDER}/2016" --auto-file-renaming=false
echo "Downloading 2011 road network file"
aria2c -x16 -i "${SCRIPT_DIR}/road_network_files/road_network_file_2011.txt" --dir="${INPUT_FOLDER}/2011" --auto-file-renaming=false
echo "Downloading 2006 road network file"
aria2c -x16 -i "${SCRIPT_DIR}/road_network_files/road_network_file_2006.txt" --dir="${INPUT_FOLDER}/2006" --auto-file-renaming=false
echo "Downloading 2001 road network file"
aria2c -x16 -i "${SCRIPT_DIR}/road_network_files/road_network_file_2001.txt" --dir="${INPUT_FOLDER}/2001" --auto-file-renaming=false
