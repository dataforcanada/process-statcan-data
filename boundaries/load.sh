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
INPUT_FOLDER="${DATA_FOLDER}/boundaries/input"
EXTRACTED_FOLDER="${DATA_FOLDER}/boundaries/extracted"

import_data_2021() {
    # Source: https://web.archive.org/web/20230307163203/https://www12.statcan.gc.ca/census-recensement/2021/geo/sip-pis/boundary-limites/index2021-eng.cfm?year=21
    # Provinces/territories
    import_to_postgis "${INPUT_FOLDER}/2021/lpr_000a21a_e.zip" lpr_000a21a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census divisions
    import_to_postgis "${INPUT_FOLDER}/2021/lcd_000a21a_e.zip" lcd_000a21a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Federal electoral districts (2013 Representation Order)
    import_to_postgis "${INPUT_FOLDER}/2021/lfed000a21a_e.zip" lfed000a21a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census subdivisions
    import_to_postgis "${INPUT_FOLDER}/2021/lcsd000a21a_e.zip" lcsd000a21a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Designated places
    import_to_postgis "${INPUT_FOLDER}/2021/ldpl000a21a_e.zip" ldpl000a21a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Forward sortation areas
    unzip -n "${INPUT_FOLDER}/2021/lfsa000a21a_e.zip" -d "${EXTRACTED_FOLDER}/2021"
    import_to_postgis "${EXTRACTED_FOLDER}/2021/lfsa000a21a_e/lfsa000a21a_e.shp" lfsa000a21a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Economic regions
    import_to_postgis "${INPUT_FOLDER}/2021/ler_000a21a_e.zip" ler_000a21a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # There's issues with the Census agricultural regions encoding, statcan did not export the shapefile properly
    # Census agricultural regions
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2021/lcar000a21a_e.zip" lcar000a21a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Census consolidated subdivisions
    import_to_postgis "${INPUT_FOLDER}/2021/lccs000a21a_e.zip" lccs000a21a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census metropolitan areas and census agglomerations
    import_to_postgis "${INPUT_FOLDER}/2021/lcma000a21a_e.zip" lcma000a21a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census tracts
    import_to_postgis "${INPUT_FOLDER}/2021/lct_000a21a_e.zip" lct_000a21a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Population centres
    import_to_postgis "${INPUT_FOLDER}/2021/lpc_000a21a_e.zip" lpc_000a21a_e "-lco SCHEMA=bronze"
    # Dissemination areas
    import_to_postgis "${INPUT_FOLDER}/2021/lda_000a21a_e.zip" lda_000a21a_e "-lco SCHEMA=bronze"
    # Dissemination blocks
    import_to_postgis "${INPUT_FOLDER}/2021/ldb_000a21a_e.zip" ldb_000a21a_e "-lco SCHEMA=bronze"
    # Aggregate dissemination areas
    import_to_postgis "${INPUT_FOLDER}/2021/lada000a21a_e.zip" lada000a21a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Population ecumene
    unzip -n "${INPUT_FOLDER}/2021/lecu000e21a_e.zip" -d "${EXTRACTED_FOLDER}/2021"
    import_to_postgis "${EXTRACTED_FOLDER}/2021/lecu000e21a_e.shp" lecu000a21a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Agricultural ecumene
    unzip -n "${INPUT_FOLDER}/2021/leca000e21a_e.zip" -d "${EXTRACTED_FOLDER}/2021"
    import_to_postgis "${EXTRACTED_FOLDER}/2021/leca000e21a_e.shp" leca000e21a_e "-lco SCHEMA=bronze"
}

import_data_2016() {
    # Source: https://web.archive.org/web/20230120140926/https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2016-eng.cfm
    # Provinces/territories
    import_to_postgis "${INPUT_FOLDER}/2016/lpr_000a16a_e.zip" lpr_000a16a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Federal electoral districts (2013 Representation Order)
    import_to_postgis "${INPUT_FOLDER}/2016/lfed000a16a_e.zip" lfed000a16a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Economic regions
    import_to_postgis "${INPUT_FOLDER}/2016/ler_000a16a_e.zip" ler_000a16a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census divisions
    import_to_postgis "${INPUT_FOLDER}/2016/lcd_000a16a_e.zip" lcd_000a16a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Aggregate dissemination areas
    import_to_postgis "${INPUT_FOLDER}/2016/lada000a16a_e.zip" lada000a16a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census agricultural regions
    import_to_postgis "${INPUT_FOLDER}/2016/lcar000a16a_e.zip" lcar000a16a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census consolidated subdivisions
    import_to_postgis "${INPUT_FOLDER}/2016/lccs000a16a_e.zip" lccs000a16a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census subdivisions
    import_to_postgis "${INPUT_FOLDER}/2016/lcsd000a16a_e.zip" lcsd000a16a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census metropolitan areas and census agglomerations
    import_to_postgis "${INPUT_FOLDER}/2016/lcma000a16a_e.zip" lcma000a16a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census tracts
    import_to_postgis "${INPUT_FOLDER}/2016/lct_000a16a_e.zip" lct_000a16a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Dissemination areas
    import_to_postgis "${INPUT_FOLDER}/2016/lda_000a16a_e.zip" lda_000a16a_e "-lco SCHEMA=bronze"
    # Dissemination blocks
    import_to_postgis "${INPUT_FOLDER}/2016/ldb_000a16a_e.zip" ldb_000a16a_e "-lco SCHEMA=bronze"
    # Designated places
    import_to_postgis "${INPUT_FOLDER}/2016/ldpl000a16a_e.zip" ldpl000a16a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Population centres
    import_to_postgis "${INPUT_FOLDER}/2016/lpc_000a16a_e.zip" lpc_000a16a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Population ecumene
    unzip -n "${INPUT_FOLDER}/2016/lecu000e16a_e.zip" -d "${EXTRACTED_FOLDER}/2016"
    import_to_postgis "${EXTRACTED_FOLDER}/2016/lecu000e16a_e.shp" lecu000e16a_e  "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Agricultural ecumene
    unzip -n "${INPUT_FOLDER}/2016/geca000e16a_e.zip" -d ${EXTRACTED_FOLDER}/2016
    import_to_postgis "${EXTRACTED_FOLDER}/2016/lagecu000e16a_e.shp" lagecu000e16a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Forward sortation areas
    import_to_postgis "${INPUT_FOLDER}/2016/lfsa000a16a_e.zip" lfsa000a16a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
}

import_data_2011() {
    # Source: https://web.archive.org/web/20230110163150/https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2011-eng.cfm
    # Provinces/territories
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2011/gpr_000a11a_e.zip" gpr_000a11a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Federal electoral districts (2003 Representation Order)
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2011/gfed000a11a_e.zip" gfed000a11a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Economic regions
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2011/ger_000a11a_e.zip" ger_000a11a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Census divisions
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2011/gcd_000a11a_e.zip" gcd_000a11a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Census agricultural regions
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2011/gcar000a11a_e.zip" gcar000a11a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Census consolidated subdivisions
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2011/gccs000a11a_e.zip" gccs000a11a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Census subdivisions
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2011/gcsd000a11a_e.zip" gcsd000a11a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Census metropolitan areas and census agglomerations
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2011/gcma000a11a_e.zip" gcma000a11a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Census tracts
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2011/gct_000a11a_e.zip" gct_000a11a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Dissemination areas
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2011/gda_000a11a_e.zip" gda_000a11a_e "-lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Dissemination blocks
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2011/gdb_000a11a_e.zip" gdb_000a11a_e "-lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Designated places
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2011/gdpl000a11a_e.zip" gdpl000a11a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Population centres
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2011/gpc_000a11a_e.zip" gpc_000a11a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Population ecumene
    unzip -n "${INPUT_FOLDER}/2011/gecu000e11a_e.zip" -d "${EXTRACTED_FOLDER}/2011"
    import_to_postgis "${EXTRACTED_FOLDER}/2011/gecu000e11a_e.shp" gecu000e11a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Agricultural ecumene
    unzip -n "${INPUT_FOLDER}/2011/geca000e11a_e.zip" -d "${EXTRACTED_FOLDER}/2011"
    import_to_postgis "${EXTRACTED_FOLDER}/2011/geca000e11a_e.shp" geca000e11a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Forward sortation areas
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2011/gfsa000a11a_e.zip" gfsa000a11a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
}

import_data_2006() {
    # Source: https://web.archive.org/web/20221218043125/https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2006-eng.cfm
    # Provinces/territories
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2006/gpr_000a06a_e.zip" gpr_000a06a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Federal electoral districts (2003 Representation Order)
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2006/gfed000a06a_e.zip" gfed000a06a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Economic regions
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2006/ger_000a06a_e.zip" ger_000a06a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Census divisions
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2006/gcd_000a06a_e.zip" gcd_000a06a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Census agricultural regions
    #import_to_postgis "${INPUT_FOLDER}/2006/gcar000a06a_e.zip" gcar000a06a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census consolidated subdivisions
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2006/gccs000a06a_e.zip" gccs000a06a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Census subdivisions
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2006/gcsd000a06a_e.zip" gcsd000a06a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Census metropolitan areas and census agglomerations
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2006/gcma000a06a_e.zip" gcma000a06a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Census tracts
    import_to_postgis "${INPUT_FOLDER}/2006/gct_000a06a_e.zip" gct_000a06a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Dissemination areas
    import_to_postgis "${INPUT_FOLDER}/2006/gda_000a06a_e.zip" gda_000a06a_e "-lco SCHEMA=bronze"
    # Dissemination blocks
    import_to_postgis "${INPUT_FOLDER}/2006/gdb_000a06a_e.zip" gdb_000a06a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Designated places
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2006/gdpl000a06a_e.zip" gdpl000a06a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Urban areas
    export PGCLIENTENCODING=LATIN-1;
    import_to_postgis "${INPUT_FOLDER}/2006/gua_000a06a_e.zip" gua_000a06a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    unset PGCLIENTENCODING
    # Population ecumene
    unzip -n "${INPUT_FOLDER}/2006/gecu000e06a_e.zip" -d "${EXTRACTED_FOLDER}/2006"
    import_to_postgis "${EXTRACTED_FOLDER}/2006/gecu000e06a_e.shp" gecu000e06a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Agricultural ecumene
    unzip -o "${INPUT_FOLDER}/2006/geca000e06a_e.zip" -d ${EXTRACTED_FOLDER}/2006
    import_to_postgis "${EXTRACTED_FOLDER}/2006/geca000e06a_e.shp" geca000e06a_e "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
}

import_data_2001() {
    # Source: https://web.archive.org/web/20221218043135/https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2001-eng.cfm
    # TODO: merge geometries by unique identifier for all but the block
    # Provinces/Territories	
    unzip -n "${INPUT_FOLDER}/2001/gpr_000b01m_e.zip" -d ${EXTRACTED_FOLDER}/2001
    import_to_postgis "${EXTRACTED_FOLDER}/2001/gpr_000b02m_e/gpr_000b02m_e.MID" gpr_000b02m_e_tmp "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Federal Electoral Districts (1996 and 2003 Representation Orders)	
    unzip -n "${INPUT_FOLDER}/2001/gfed000b01m_e.zip" -d "${EXTRACTED_FOLDER}/2001"
    import_to_postgis "${EXTRACTED_FOLDER}/2001/gfed000b02m_e/gfed000b02m_e.MID" gfed000b02m_e_tmp "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Economic Regions	
    unzip -n "${INPUT_FOLDER}/2001/ger_000b01m_e.zip" -d "${EXTRACTED_FOLDER}/2001"
    import_to_postgis "${EXTRACTED_FOLDER}/2001/ger_000b02m_e/ger_000b02m_e.MID" ger_000b02m_e_tmp "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census Divisions	
    unzip -n "${INPUT_FOLDER}/2001/gcd_000b01m_e.zip" -d "${EXTRACTED_FOLDER}/2001"
    import_to_postgis "${EXTRACTED_FOLDER}/2001/gcd_000b02m_e/gcd_000b02m_e.MID" gcd_000b02m_e_tmp "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census Agricultural Regions	
    unzip -n "${INPUT_FOLDER}/2001/gcar000b01m_e.zip" -d "${EXTRACTED_FOLDER}/2001"
    import_to_postgis "${EXTRACTED_FOLDER}/2001/gcar000b03m_e/gcar000b03m_e.mid" gcar000b03m_e_tmp "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census Consolidated Subdivisions	
    unzip -n "${INPUT_FOLDER}/2001/gccs000b01m_e.zip" -d "${EXTRACTED_FOLDER}/2001"
    import_to_postgis "${EXTRACTED_FOLDER}/2001/gccs000b02m_e/gccs000b02m_e.MID" gccs000b02m_e_tmp "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census Subdivisions
    unzip -n "${INPUT_FOLDER}/2001/gcsd000b01m_e.zip" -d "${EXTRACTED_FOLDER}/2001"
    import_to_postgis "${EXTRACTED_FOLDER}/2001/gcsd000b02m_e/gcsd000b02m_e.MID" gcsd000b02m_e_tmp "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census Metropolitan Areas and Census Agglomerations
    unzip -n "${INPUT_FOLDER}/2001/gcma000b01m_e.zip" -d "${EXTRACTED_FOLDER}/2001"
    import_to_postgis "${EXTRACTED_FOLDER}/2001/gcma000b02m_e/gcma000b02m_e.MID" gcma000b02m_e_tmp "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Census Tracts
    unzip -n "${INPUT_FOLDER}/2001/gct_000b01m_e.zip" -d "${EXTRACTED_FOLDER}/2001"
    import_to_postgis "${EXTRACTED_FOLDER}/2001/gct_000b02m_e/gct_000b02m_e.MID" gct_000b02m_e_tmp "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Dissemination Areas
    unzip -n "${INPUT_FOLDER}/2001/gda_000b01m_e.zip" -d "${EXTRACTED_FOLDER}/2001"
    import_to_postgis "${EXTRACTED_FOLDER}/2001/gda_000b02m_e/gda_000b02m_e.MID" gda_000b02m_e_tmp "-lco SCHEMA=bronze"
    # Blocks (no need to merge geometries)
    unzip -n "${INPUT_FOLDER}/2001/gdb_000a01m_e.zip" -d "${EXTRACTED_FOLDER}/2001"
    import_to_postgis "${EXTRACTED_FOLDER}/2001/gbl_000d02m_e/gbl_000d02m_e.TAB" gbl_000d02m_e_tmp "-lco SCHEMA=bronze"
    # Designated Places
    unzip -n "${INPUT_FOLDER}/2001/gdpl000b01m_e.zip" -d "${EXTRACTED_FOLDER}/2001"
    import_to_postgis "${EXTRACTED_FOLDER}/2001/gdpl000b02m_e/gdpl000b02m_e.MID" gdpl000b02m_e_tmp "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # Urban Areas
    unzip -n "${INPUT_FOLDER}/2001/gua_000b01m_e.zip" -d "${EXTRACTED_FOLDER}/2001"
    import_to_postgis "${EXTRACTED_FOLDER}/2001/gua_000b02m_e/gua_000b02m_e.MID" gua000b02m_e_tmp "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"
    # TODO
    # Population Ecumene 
    # Agricultural Ecumene
    unzip -n "${INPUT_FOLDER}/2001/geca000e01m_e.zip" -d "${EXTRACTED_FOLDER}/2001"
    import_to_postgis "${EXTRACTED_FOLDER}/2001/geca000e03m_e/geca000e03m_e.mid" geca000e03m_e_tmp "-nlt PROMOTE_TO_MULTI -lco SCHEMA=bronze"   
}

# Execute all import functions
import_data_2021
import_data_2016
import_data_2011
import_data_2006
#import_data_2001
