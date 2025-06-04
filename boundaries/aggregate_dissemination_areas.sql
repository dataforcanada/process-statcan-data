/*
Aggregate Dissemination Areas
*/

/* 2021
Definition here: https://web.archive.org/web/20240731061904/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/Definition-eng.cfm?ID=geo053
*/

-- Digital boundary;
DROP TABLE IF EXISTS silver.ada_2021_digital;
CREATE TABLE silver.ada_2021_digital AS
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
    cma.cma_dguid,
    cma.cma_p_dguid,
    cma.cma_name,
    cma.cma_type,
    dgr.ada_dguid,
    ada.geom
FROM silver.dissemination_geographies_relationship_2021 AS dgr
LEFT JOIN silver.cd_2021_digital AS cd
    ON dgr.cd_dguid = cd.cd_dguid
LEFT JOIN silver.cma_2021_digital AS cma
    ON
        concat(dgr.cma_dguid, dgr.cma_p_dguid)
        = concat(cma.cma_dguid, cma.cma_p_dguid)
LEFT JOIN bronze.lada000a21a_e AS ada
    ON dgr.ada_dguid = ada.dguid;

-- Make geometries valid
UPDATE
    silver.ada_2021_digital
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX ada_2021_digital_geom_idx ON silver.ada_2021_digital USING gist (geom) WITH (
    fillfactor = 100
);

-- Cartographic boundary;
DROP TABLE IF EXISTS silver.ada_2021_cartographic;
CREATE TABLE silver.ada_2021_cartographic AS
SELECT DISTINCT
    b.country_dguid,
    b.country_en_name,
    b.country_fr_name,
    b.country_en_abbreviation,
    b.country_fr_abbreviation,
    b.grc_dguid,
    b.grc_en_name,
    b.grc_fr_name,
    b.pr_dguid,
    b.pr_en_name,
    b.pr_fr_name,
    b.pr_en_abbreviation,
    b.pr_fr_abbreviation,
    b.pr_iso_code,
    b.car_dguid,
    b.car_en_name,
    b.car_fr_name,
    b.cd_dguid,
    b.cd_name,
    b.cd_type,
    b.cma_dguid,
    b.cma_p_dguid,
    b.cma_name,
    b.cma_type,
    b.ada_dguid,
    a.geom
FROM
    bronze.lada000b21a_e AS a,
    silver.ada_2021_digital AS b
WHERE a.dguid = b.ada_dguid;

-- Make geometries valid
UPDATE
    silver.ada_2021_cartographic
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX ada_2021_cartographic_geom_idx ON silver.ada_2021_cartographic USING gist (geom) WITH (
    fillfactor = 100
);