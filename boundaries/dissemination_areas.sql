/*
Dissemination Areas
*/

/* 2021
Definition here: https://web.archive.org/web/20240731061905/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/definition-eng.cfm?ID=geo021
*/

-- Digital boundary;
DROP TABLE IF EXISTS silver.da_2021_digital;
CREATE TABLE silver.da_2021_digital AS
SELECT DISTINCT
    csd.country_dguid,
    csd.country_en_name,
    csd.country_fr_name,
    csd.country_en_abbreviation,
    csd.country_fr_abbreviation,
    csd.grc_dguid,
    csd.grc_en_name,
    csd.grc_fr_name,
    csd.pr_dguid,
    csd.pr_en_name,
    csd.pr_fr_name,
    csd.pr_en_abbreviation,
    csd.pr_fr_abbreviation,
    csd.pr_iso_code,
    csd.car_dguid,
    csd.car_en_name,
    csd.car_fr_name,
    csd.er_dguid,
    csd.er_name,
    csd.cd_dguid,
    csd.cd_name,
    csd.cd_type,
    csd.ccs_dguid,
    csd.ccs_name,
    csd.cma_dguid,
    csd.cma_p_dguid,
    csd.cma_name,
    csd.cma_type,
    csd.csd_dguid,
    csd.csd_name,
    csd.csd_type,
    csd.sac_type,
    csd.sac_code,
    dgr.ct_dguid,
    dgr.ada_dguid,
    dgr.da_dguid,
    da.geom
FROM silver.dissemination_geographies_relationship_2021 AS dgr
LEFT JOIN silver.csd_2021_digital AS csd
    ON dgr.csd_dguid = csd.csd_dguid
LEFT JOIN bronze.lda_000a21a_e AS da
    ON dgr.da_dguid = da.dguid;

-- Make geometries valid
UPDATE
    silver.da_2021_digital
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX da_2021_digital_geom_idx ON silver.da_2021_digital USING gist (geom) WITH (
    fillfactor = 100
);

-- Cartographic boundary;
DROP TABLE IF EXISTS silver.da_2021_cartographic;
CREATE TABLE silver.da_2021_cartographic AS
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
    b.er_dguid,
    b.er_name,
    b.cd_dguid,
    b.cd_name,
    b.cd_type,
    b.ccs_dguid,
    b.ccs_name,
    b.cma_dguid,
    b.cma_p_dguid,
    b.cma_name,
    b.cma_type,
    b.csd_dguid,
    b.csd_name,
    b.csd_type,
    b.sac_type,
    b.sac_code,
    b.ct_dguid,
    b.ada_dguid,
    b.da_dguid,
    a.geom
FROM
    bronze.lda_000b21a_e AS a,
    silver.da_2021_digital AS b
WHERE a.dguid = b.da_dguid;

-- Make geometries valid
UPDATE
    silver.da_2021_cartographic
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX da_2021_cartographic_geom_idx ON silver.da_2021_cartographic USING gist (geom) WITH (
    fillfactor = 100
);