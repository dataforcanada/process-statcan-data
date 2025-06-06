#!/bin/bash
if [ ! -d "${DATA_FOLDER}/national_address_register" ]
then
    echo "Making directory ${DATA_FOLDER}/national_address_register/"
    mkdir -p ${DATA_FOLDER}/national_address_register/{input,extracted,output}/{2024-12,2024-06,2023,2022}
fi

INPUT_FOLDER="${DATA_FOLDER}/national_address_register/input"

echo "Downloading 2024-12 vintage of national address register files"
aria2c -x16 -i "${SCRIPT_DIR}/national_address_register/national_address_register_files_2024_12.txt" --dir=${INPUT_FOLDER}/2024-12 --auto-file-renaming=false
echo "Downloading 2024-06 vintage of national address register files"
aria2c -x16 -i "${SCRIPT_DIR}/national_address_register/national_address_register_files_2024_06.txt" --dir=${INPUT_FOLDER}/2024-06 --auto-file-renaming=false
echo "Downloading 2023 vintage of national address register files"
aria2c -x16 -i "${SCRIPT_DIR}/national_address_register/national_address_register_files_2023.txt" --dir=${INPUT_FOLDER}/2023 --auto-file-renaming=false
echo "Downloading 2022 vintage of national address register files"
aria2c -x16 -i "${SCRIPT_DIR}/national_address_register/national_address_register_files_2022.txt" --dir=${INPUT_FOLDER}/2022 --auto-file-renaming=false