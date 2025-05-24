#!/bin/bash

DATA_FOLDER=/home/ripledi/Documents/projects/process-statcan-spatial-data/data

source credentials.sh

export_postgis_single() {
    local filepath=$1
    local table_name=$2
    local extra_parameters=${@:3}

    # Virtual file system
    if [[ ${filepath: -4} = '.zip' ]]; then
        local filepath="/vsizip/${filepath}"
    fi

    echo "Importing ${filepath}"
    ogr2ogr \
        --config PG_USE_COPY YES \
        -overwrite \
        -f "PostgreSQL" \
        "PG:host=db dbname=${POSTGRES_DB} user=${POSTGRES_USER} password=${POSTGRES_PASSWORD} port=5432" \
        -progress \
        -gt 500000 \
        -t_srs EPSG:4326 \
        -nln ${table_name} \
        ${extra_parameters} \
        ${filepath}
}

export_open_database_of_greenhouses() {
    export PGCLIENTENCODING=UTF-8;
    export_postgis_single ${DATA_FOLDER}/ODG_V1/odg_v1.shp statcan_odg_tmp
}

export_open_database_of_buildings() {
    # Open Database of Buildings
    export PGCLIENTENCODING=UTF-8;
    export_postgis_single ${DATA_FOLDER}/ODB_Alberta/odb_alberta.shp statcan_odb_tmp "-nlt PROMOTE_TO_MULTI"
    export_postgis_single ${DATA_FOLDER}/ODB_BritishColumbia/odb_britishcolumbia.shp statcan_odb_tmp "-append -nlt PROMOTE_TO_MULTI"
    export_postgis_single ${DATA_FOLDER}/ODB_NewBrunswick/odb_newbrunswick.shp statcan_odb_tmp "-append -nlt PROMOTE_TO_MULTI"
    export_postgis_single ${DATA_FOLDER}/ODB_NorthwestTerritories/odb_northwestterritories.shp statcan_odb_tmp "-append -nlt PROMOTE_TO_MULTI"
    export_postgis_single ${DATA_FOLDER}/ODB_NovaScotia/odb_novascotia.shp statcan_odb_tmp "-append -nlt PROMOTE_TO_MULTI"
    export_postgis_single ${DATA_FOLDER}/ODB_Ontario/odb_ontario.shp statcan_odb_tmp "-append -nlt PROMOTE_TO_MULTI"
    export_postgis_single ${DATA_FOLDER}/ODB_Quebec/odb_quebec.shp statcan_odb_tmp "-append -nlt PROMOTE_TO_MULTI"
    export_postgis_single ${DATA_FOLDER}/ODB_Saskatchewan/odb_saskatchewan.shp statcan_odb_tmp "-append -nlt PROMOTE_TO_MULTI"
}

export_open_database_of_educational_facilities() {
    export PGCLIENTENCODING=LATIN-1;
    export_postgis_single ${DATA_FOLDER}/ODEF_v2.1_EN/ODEF_v2_1.csv statcan_odef_tmp "-oo X_POSSIBLE_NAMES=Longitude, -oo Y_POSSIBLE_NAMES=Latitude -s_srs EPSG:4326"
}

export_open_database_of_healthcare_facilities() {
    export PGCLIENTENCODING=LATIN-1;
    # TODO: process further
    # There are issues with the characters in this file, example <97>
    export_postgis_single ${DATA_FOLDER}/ODHF_v1.1/odhf_v1.1.csv statcan_odhf_tmp "-oo X_POSSIBLE_NAMES=longitude, -oo Y_POSSIBLE_NAMES=latitude -s_srs EPSG:4326"
}

export_open_database_of_cultural_and_art_facilities() {
    export PGCLIENTENCODING=LATIN-1;
    # TODO: process further
    export_postgis_single ${DATA_FOLDER}/ODCAF_V1.0/ODCAF_v1.0.csv statcan_odcaf_tmp "-oo X_POSSIBLE_NAMES=Longitude, -oo Y_POSSIBLE_NAMES=Latitude -s_srs EPSG:4326"
}

export_open_database_of_addresses() {
    # PGCLIENTENCODING=UTF-8 seems to have fixed all of the issues
    export PGCLIENTENCODING=UTF-8;
    export_postgis_single ${DATA_FOLDER}/ODA_AB_v1.csv statcan_oda_tmp "-oo X_POSSIBLE_NAMES=longitude, -oo Y_POSSIBLE_NAMES=latitude -s_srs EPSG:4326"
    export_postgis_single ${DATA_FOLDER}/ODA_BC_v1.csv statcan_oda_tmp "-oo X_POSSIBLE_NAMES=longitude, -oo Y_POSSIBLE_NAMES=latitude -s_srs EPSG:4326 -append"
    export_postgis_single ${DATA_FOLDER}/ODA_MB_v1.csv statcan_oda_tmp "-oo X_POSSIBLE_NAMES=longitude, -oo Y_POSSIBLE_NAMES=latitude -s_srs EPSG:4326 -append"
    export_postgis_single ${DATA_FOLDER}/ODA_NB_v1.csv statcan_oda_tmp "-oo X_POSSIBLE_NAMES=longitude, -oo Y_POSSIBLE_NAMES=latitude -s_srs EPSG:4326 -append"
    export_postgis_single ${DATA_FOLDER}/ODA_NS_v1.csv statcan_oda_tmp "-oo X_POSSIBLE_NAMES=longitude, -oo Y_POSSIBLE_NAMES=latitude -s_srs EPSG:4326 -append"
    export_postgis_single ${DATA_FOLDER}/ODA_NT_v1.csv statcan_oda_tmp "-oo X_POSSIBLE_NAMES=longitude, -oo Y_POSSIBLE_NAMES=latitude -s_srs EPSG:4326 -append"
    export_postgis_single ${DATA_FOLDER}/ODA_ON_v1.csv statcan_oda_tmp "-oo X_POSSIBLE_NAMES=longitude, -oo Y_POSSIBLE_NAMES=latitude -s_srs EPSG:4326 -append"
    export_postgis_single ${DATA_FOLDER}/ODA_PE_v1.csv statcan_oda_tmp "-oo X_POSSIBLE_NAMES=longitude, -oo Y_POSSIBLE_NAMES=latitude -s_srs EPSG:4326 -append"
    export_postgis_single ${DATA_FOLDER}/ODA_QC_v1.csv statcan_oda_tmp "-oo X_POSSIBLE_NAMES=longitude, -oo Y_POSSIBLE_NAMES=latitude -s_srs EPSG:4326 -append"
    export_postgis_single ${DATA_FOLDER}/ODA_SK_v1.csv statcan_oda_tmp "-oo X_POSSIBLE_NAMES=longitude, -oo Y_POSSIBLE_NAMES=latitude -s_srs EPSG:4326 -append"
}

export_open_database_of_recreational_and_sport_facilities() {
    export PGCLIENTENCODING=LATIN-1;
    # TODO: process further
    export_postgis_single ${DATA_FOLDER}/ODRSF_V1.0/ODRSF_v1.0.csv statcan_odrsf_tmp "-oo X_POSSIBLE_NAMES=Longitude, -oo Y_POSSIBLE_NAMES=Latitude -s_srs EPSG:4326"
}



#export_open_database_of_greenhouses
#export_open_database_of_buildings
#export_open_database_of_educational_facilities
#export_open_database_of_healthcare_facilities
#export_open_database_of_cultural_and_art_facilities
#export_open_database_of_addresses
export_open_database_of_recreational_and_sport_facilities
