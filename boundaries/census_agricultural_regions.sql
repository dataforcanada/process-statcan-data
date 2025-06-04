/*
Census Agricultural Regions
*/

/* 2021
Definition here: https://web.archive.org/web/20250401192328/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/definition-eng.cfm?ID=geo006
*/

-- Digital boundary;
DROP TABLE IF EXISTS silver.car_2021_digital;
CREATE TABLE silver.car_2021_digital AS
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
    dgr.car_dguid,
    car.carename AS car_en_name,
    car.carfname AS car_fr_name,
    car.geom
FROM
    silver.pr_2021_digital AS pr,
    silver.dissemination_geographies_relationship_2021 AS dgr,
    bronze.lcar000a21a_e AS car
WHERE
    pr.pr_dguid = dgr.pr_dguid
    AND car.dguid = dgr.car_dguid;

-- Make geometries valid
UPDATE
    silver.car_2021_digital
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX car_2021_digital_geom_idx ON silver.car_2021_digital USING gist (geom) WITH (
    fillfactor = 100
);

-- Cartographic boundary;
DROP TABLE IF EXISTS silver.car_2021_cartographic;
CREATE TABLE silver.car_2021_cartographic AS
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
    a.geom
FROM
    bronze.lcar000b21a_e AS a,
    silver.car_2021_digital AS b
WHERE
    a.dguid = b.car_dguid;

-- Make geometries valid
UPDATE
    silver.car_2021_cartographic
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX car_2021_cartographic_geom_idx ON silver.car_2021_cartographic USING gist (geom) WITH (
    fillfactor = 100
);