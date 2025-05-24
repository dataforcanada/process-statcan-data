/*
Census Agricultural Regions
*/

/* 2021
Definition here: https://web.archive.org/web/20250401192328/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/definition-eng.cfm?ID=geo006
*/

DROP TABLE IF EXISTS silver.car_2021;
CREATE TABLE silver.car_2021 AS
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
    silver.pr_2021 AS pr,
    silver.dissemination_geographies_relationship_2021 AS dgr,
    bronze.lcar000a21a_e AS car
WHERE
    pr.pr_dguid = dgr.pr_dguid
    AND car.dguid = dgr.car_dguid;

-- Make geometries valid
UPDATE
    silver.car_2021
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX car_2021_geom_idx ON silver.car_2021 USING gist (geom) WITH (
    fillfactor = 100
);
