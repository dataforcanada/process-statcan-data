/*
Designated Places
*/

/* 2021
Definition here: https://web.archive.org/web/20240731061904/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/Definition-eng.cfm?ID=geo018
*/

-- Digital boundary;
DROP TABLE IF EXISTS silver.dpl_2021_digital;
CREATE TABLE silver.dpl_2021_digital AS
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
LEFT JOIN silver.pr_2021_digital AS pr
    ON dgr.pr_dguid = pr.pr_dguid
LEFT JOIN bronze.ldpl000a21a_e AS dpl
    ON dgr.dpl_dguid = dpl.dguid
WHERE dgr.dpl_dguid IS NOT null;

-- Make geometries valid
UPDATE
    silver.dpl_2021_digital
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX dpl_2021_digital_geom_idx ON silver.dpl_2021_digital USING gist (geom) WITH (
    fillfactor = 100
);

-- Cartographic boundary;
DROP TABLE IF EXISTS silver.dpl_2021_cartographic;
CREATE TABLE silver.dpl_2021_cartographic AS
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
    b.dpl_dguid,
    b.dpl_name,
    b.dpl_type,
    a.geom
FROM
    bronze.ldpl000b21a_e AS a,
    silver.dpl_2021_digital AS b
WHERE b.dpl_dguid = a.dguid;

-- Make geometries valid
UPDATE
    silver.dpl_2021_cartographic
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX dpl_2021_cartographic_geom_idx ON silver.dpl_2021_cartographic USING gist (geom) WITH (
    fillfactor = 100
);