/*
Designated Places
*/

/* 2021
Definition here: https://web.archive.org/web/20240731061904/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/Definition-eng.cfm?ID=geo018
*/

DROP TABLE IF EXISTS silver.dpl_2021;
CREATE TABLE silver.dpl_2021 AS
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
    dgr.dpl_dguid,
    dpl.dplname AS dpl_name,
    dpl.dpltype AS dpl_type,
    dpl.geom
FROM silver.dissemination_geographies_relationship_2021 AS dgr
LEFT JOIN silver.pr_2021 AS pr
    ON dgr.pr_dguid = pr.pr_dguid
LEFT JOIN bronze.ldpl000a21a_e AS dpl
    ON dgr.dpl_dguid = dpl.dguid
WHERE dgr.dpl_dguid IS NOT null;

-- Make geometries valid
UPDATE
    silver.dpl_2021
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX dpl_2021_geom_idx ON silver.dpl_2021 USING gist (geom) WITH (
    fillfactor = 100
);
