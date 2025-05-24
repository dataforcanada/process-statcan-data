/*
Census Metropolitan Areas
*/

/* 2021
Definition here: https://web.archive.org/web/20250518133322/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/Definition-eng.cfm?ID=geo009
*/

DROP TABLE IF EXISTS silver.cma_2021;
CREATE TABLE silver.cma_2021 AS
SELECT DISTINCT
    pr.country_dguid,
    pr.country_en_name,
    pr.country_fr_name,
    pr.country_en_abbreviation,
    pr.country_fr_abbreviation,
    pr.grc_dguid,
    pr.grc_en_name,
    pr.grc_fr_name,
    pr.pr_dguid,
    pr.pr_en_name,
    pr.pr_fr_name,
    pr.pr_en_abbreviation,
    pr.pr_fr_abbreviation,
    pr.pr_iso_code,
    cma.dguid AS cma_dguid,
    cma.dguidp AS cma_p_dguid,
    cma.cmaname AS cma_name,
    cma.cmatype AS cma_type,
    cma.geom
FROM
    silver.pr_2021 AS pr,
    bronze.lcma000a21a_e AS cma,
    silver.dissemination_geographies_relationship_2021 AS dgr
WHERE
    pr.pr_dguid = dgr.pr_dguid
    AND
    concat(
        cma.dguid,
        cma.dguidp) = concat(
        dgr.cma_dguid,
        dgr.cma_p_dguid
    );

-- Make geometries valid
UPDATE
    silver.cma_2021
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX cma_2021_geom_idx ON silver.cma_2021 USING gist (geom) WITH (
    fillfactor = 100
);
