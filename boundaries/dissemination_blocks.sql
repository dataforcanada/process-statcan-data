/*
Dissemination Blocks
*/

/* 2021
Definition here: https://web.archive.org/web/20250212081621/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/definition-eng.cfm?ID=geo014
*/

DROP TABLE IF EXISTS silver.db_2021;
CREATE TABLE silver.db_2021 AS
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
    dgr.fed_dguid,
    fed.fed_name,
    fed.fed_en_name,
    fed.fed_fr_name,
    dgr.ct_dguid,
    dgr.ada_dguid,
    dgr.da_dguid,
    dgr.db_dguid,
    db.geom
FROM silver.dissemination_geographies_relationship_2021 AS dgr
LEFT JOIN silver.csd_2021 AS csd
    ON dgr.csd_dguid = csd.csd_dguid
LEFT JOIN silver.fed_2021 AS fed
    ON dgr.fed_dguid = fed.fed_dguid
LEFT JOIN bronze.ldb_000a21a_e AS db
    ON dgr.db_dguid = db.dguid;

-- Make geometries valid
UPDATE
    silver.db_2021
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX db_2021_geom_idx ON silver.db_2021 USING gist (geom) WITH (
    fillfactor = 100
);
