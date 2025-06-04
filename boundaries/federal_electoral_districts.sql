/*
Federal Electoral Districts
*/

/* 2021
Definition here: https://web.archive.org/web/20240731061905/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/Definition-eng.cfm?ID=geo025
*/

-- 2021 vintage, 2013 representation order. Digital boundary;
DROP TABLE IF EXISTS silver.fed_2021_2013_digital;
CREATE TABLE silver.fed_2021_2013_digital AS
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
    dgr.fed_dguid,
    fed.fedname AS fed_name,
    fed.fedename AS fed_en_name,
    fed.fedfname AS fed_fr_name,
    fed.geom
FROM silver.dissemination_geographies_relationship_2021 AS dgr
LEFT JOIN silver.pr_2021_digital AS pr
    ON dgr.pr_dguid = pr.pr_dguid
LEFT JOIN bronze.lfed000a21a_e AS fed
    ON dgr.fed_dguid = fed.dguid
WHERE dgr.fed_dguid IS NOT null;

-- Make geometries valid
UPDATE
    silver.fed_2021_2013_digital
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX fed_2021_2013_digital_geom_idx ON silver.fed_2021_2013_digital USING gist (geom) WITH (
    fillfactor = 100
);

-- 2021 vintage, 2013 representation order. Cartographic boundary;
DROP TABLE IF EXISTS silver.fed_2021_2013_cartographic;
CREATE TABLE silver.fed_2021_2013_cartographic AS
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
    b.fed_dguid,
    b.fed_name,
    b.fed_en_name,
    b.fed_fr_name,
    a.geom
FROM
    bronze.lfed000b21a_e AS a,
    silver.fed_2021_2013_digital AS b
WHERE a.dguid = b.fed_dguid;

-- Make geometries valid
UPDATE
    silver.fed_2021_2013_cartographic
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX fed_2021_2013_cartographic_geom_idx ON silver.fed_2021_2013_cartographic USING gist (geom) WITH (
    fillfactor = 100
);