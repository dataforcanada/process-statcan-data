/*
Census Consolidated Subdivisions
*/

/* 2021
Definition here: https://web.archive.org/web/20250401192303/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/Definition-eng.cfm?ID=geo007
*/

DROP TABLE IF EXISTS silver.ccs_2021;
CREATE TABLE silver.ccs_2021 AS
SELECT DISTINCT
    cd.country_dguid,
    cd.country_en_name,
    cd.country_fr_name,
    cd.country_en_abbreviation,
    cd.country_fr_abbreviation,
    cd.grc_dguid,
    cd.grc_en_name,
    cd.grc_fr_name,
    cd.pr_dguid,
    cd.pr_en_name,
    cd.pr_fr_name,
    cd.pr_en_abbreviation,
    cd.pr_fr_abbreviation,
    cd.pr_iso_code,
    cd.car_dguid,
    cd.car_en_name,
    cd.car_fr_name,
    cd.cd_dguid,
    cd.cd_name,
    cd.cd_type,
    ccs.dguid AS ccs_dguid,
    ccs.ccsname AS ccs_name,
    ccs.geom
FROM
    silver.cd_2021 AS cd,
    silver.dissemination_geographies_relationship_2021 AS dgr,
    bronze.lccs000a21a_e AS ccs
WHERE
    cd.cd_dguid = dgr.cd_dguid
    AND
    ccs.dguid = dgr.ccs_dguid;

-- Make geometries valid
UPDATE
    silver.ccs_2021
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX ccs_2021_geom_idx ON silver.ccs_2021 USING gist (geom) WITH (
    fillfactor = 100
);
