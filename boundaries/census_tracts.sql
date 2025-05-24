/*
Census Tracts
*/

/* 2021
Definition here: https://web.archive.org/web/20241013011815/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/Definition-eng.cfm?ID=geo013
*/

DROP TABLE IF EXISTS silver.ct_2021;
CREATE TABLE silver.ct_2021 AS
SELECT DISTINCT
    cma.country_dguid,
    cma.country_en_name,
    cma.country_fr_name,
    cma.country_en_abbreviation,
    cma.country_fr_abbreviation,
    cma.grc_dguid,
    cma.grc_en_name,
    cma.grc_fr_name,
    cma.pr_dguid,
    cma.pr_en_name,
    cma.pr_fr_name,
    cma.pr_en_abbreviation,
    cma.pr_fr_abbreviation,
    cma.pr_iso_code,
    cma.cma_dguid,
    cma.cma_p_dguid,
    cma.cma_name,
    cma.cma_type,
    ct.dguid AS ct_dguid,
    ct.geom
FROM silver.dissemination_geographies_relationship_2021 AS dgr
LEFT JOIN bronze.lct_000a21a_e AS ct
    ON dgr.ct_dguid = ct.dguid
LEFT JOIN silver.cma_2021 AS cma
    ON
        concat(dgr.cma_dguid, dgr.cma_p_dguid)
        = concat(cma.cma_dguid, cma.cma_p_dguid)
WHERE dgr.ct_dguid IS NOT null;

-- Make geometries valid
UPDATE
    silver.ct_2021
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX ct_2021_geom_idx ON silver.ct_2021 USING gist (geom) WITH (
    fillfactor = 100
);
