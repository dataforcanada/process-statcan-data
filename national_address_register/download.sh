#!/bin/bash
if [ ! -d "${DATA_FOLDER}/national_address_register" ]
then
    echo "Making directory ${DATA_FOLDER}/national_address_register/"
    mkdir -p ${DATA_FOLDER}/national_address_register/{input,extracted,output,scratch}
fi

echo "Downloading national address register files"
aria2c -x16 -i "${SCRIPT_DIR}/national_address_register/national_address_register_files.txt" --dir=$DATA_FOLDER/national_address_register/input --auto-file-renaming=false
