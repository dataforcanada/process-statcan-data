/*
Dissemination Areas
*/

/* 2021
Definition here: https://web.archive.org/web/20240731061905/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/definition-eng.cfm?ID=geo021
*/

DROP TABLE IF EXISTS silver.da_2021;
CREATE TABLE silver.da_2021 AS
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
LEFT JOIN silver.csd_2021 AS csd
    ON dgr.csd_dguid = csd.csd_dguid
LEFT JOIN bronze.lda_000a21a_e AS da
    ON dgr.da_dguid = da.dguid;

-- Make geometries valid
UPDATE
    bronze.lda_000a21a_e
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX da_2021_geom_idx ON silver.da_2021 USING gist (geom) WITH (
    fillfactor = 100
);
