/*
Aggregate Dissemination Areas
*/

/* 2021
Definition here: https://web.archive.org/web/20240731061904/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/Definition-eng.cfm?ID=geo053
*/

DROP TABLE IF EXISTS silver.ada_2021;
CREATE TABLE silver.ada_2021 AS
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
LEFT JOIN silver.cd_2021 AS cd
    ON dgr.cd_dguid = cd.cd_dguid
LEFT JOIN silver.cma_2021 AS cma
    ON
        concat(dgr.cma_dguid, dgr.cma_p_dguid)
        = concat(cma.cma_dguid, cma.cma_p_dguid)
LEFT JOIN bronze.lada000a21a_e AS ada
    ON dgr.ada_dguid = ada.dguid;

-- Make geometries valid
UPDATE
    silver.ada_2021
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX ada_2021_geom_idx ON silver.ada_2021 USING gist (geom) WITH (
    fillfactor = 100
);
