/*
Census Metropolitan Areas
*/

/* 2021
Definition here: https://web.archive.org/web/20250518133322/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/Definition-eng.cfm?ID=geo009
*/

-- Digital boundary;
DROP TABLE IF EXISTS silver.cma_2021_digital;
CREATE TABLE silver.cma_2021_digital AS
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
    silver.pr_2021_digital AS pr,
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
    silver.cma_2021_digital
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX cma_2021_digital_geom_idx ON silver.cma_2021_digital USING gist (geom) WITH (
    fillfactor = 100
);

-- Cartographic boundary;
DROP TABLE IF EXISTS silver.cma_2021_cartographic;
CREATE TABLE silver.cma_2021_cartographic AS
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
    b.cma_dguid,
    b.cma_p_dguid,
    b.cma_name,
    b.cma_type,
    a.geom
FROM
    bronze.lcma000b21a_e AS a,
    silver.cma_2021_digital AS b
WHERE
    concat(
        a.dguid,
        a.dguidp) = concat(
        b.cma_dguid,
        b.cma_p_dguid
    );

-- Make geometries valid
UPDATE
    silver.cma_2021_cartographic
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX cma_2021_cartographic_geom_idx ON silver.cma_2021_cartographic USING gist (geom) WITH (
    fillfactor = 100
);