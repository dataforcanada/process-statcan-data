#!/bin/bash

import_to_postgis() {
    local filepath="$1"
    local table_name="$2"
    local extra_parameters="${@:3}"

    # Handle zip files using GDAL's virtual file system
    if [[ "${filepath: -4}" == ".zip" ]]; then
        filepath="/vsizip/${filepath}"
    fi

    echo "Importing ${filepath} into table ${table_name}"
    ogr2ogr \
        --config PG_USE_COPY YES \
        -lco "OVERWRITE=YES" \
        -f "PostgreSQL" \
        "PG:host=db dbname=${POSTGRES_DB} user=${POSTGRES_USER} password=${POSTGRES_PASSWORD} port=5432" \
        -lco GEOMETRY_NAME=geom \
        -progress \
        -gt 500000 \
        -t_srs EPSG:4326 \
        -nln "${table_name}" \
        ${extra_parameters} \
        "${filepath}"
}

# Define input folders
INPUT_FOLDER="${DATA_FOLDER}/hydro/input"
EXTRACTED_FOLDER="${DATA_FOLDER}/hydro/extracted"

# Import 2016 hydro data
import_data_2016() {
    # Source: https://web.archive.org/web/20230120140926/https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2016-eng.cfm
    # Lakes and rivers (polygons)
    import_to_postgis "${INPUT_FOLDER}/2016/lhy_000c16a_e.zip" lhy_000c16a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Rivers (lines)
    import_to_postgis "${INPUT_FOLDER}/2016/lhy_000d16a_e.zip" lhy_000d16a_e "-lco SCHEMA=bronze"
    # Coastal waters (polygons)
    import_to_postgis "${INPUT_FOLDER}/2016/lhy_000h16a_e.zip" lhy_000h16a_e "-lco SCHEMA=bronze"
}

# Import 2011 hydro data
import_data_2011() {
    # Source: https://web.archive.org/web/20230110163150/https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2011-eng.cfm
    export PGCLIENTENCODING=LATIN-1;
    # Lakes and rivers (polygons)
    import_to_postgis "${INPUT_FOLDER}/2011/ghy_000c11a_e.zip" ghy_000c11a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Rivers (lines)
    import_to_postgis "${INPUT_FOLDER}/2011/ghy_000d11a_e.zip" ghy_000d11a_e "-lco SCHEMA=bronze"
    # Coastal waters (polygons)
    import_to_postgis "${INPUT_FOLDER}/2011/ghy_000h11a_e.zip" ghy_000h11a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
}

# Import 2006 hydro data
import_data_2006() {
    # Source: https://web.archive.org/web/20221218043125/https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2006-eng.cfm
    export PGCLIENTENCODING=LATIN-1;
    # Lakes and rivers (polygons)
    import_to_postgis "${INPUT_FOLDER}/2006/ghy_000c06a_e.zip" ghy_000c06a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Rivers (lines)
    import_to_postgis "${INPUT_FOLDER}/2006/ghy_000d06a_e.zip" ghy_000d06a_e "-lco SCHEMA=bronze"
    # Coastal waters (polygons)
    import_to_postgis "${INPUT_FOLDER}/2006/ghy_000f06a_e.zip" ghy_000f06a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
}

# Execute all import functions
import_data_2016
import_data_2011
import_data_2006