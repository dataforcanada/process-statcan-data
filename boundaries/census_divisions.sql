/*
Census Divisions
*/

/* 2021
Definition here: https://web.archive.org/web/20250131082459/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/definition-eng.cfm?ID=geo008#moreinfo
*/

DROP TABLE IF EXISTS silver.cd_2021;
CREATE TABLE silver.cd_2021 AS
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
    cd.dguid AS cd_dguid,
    cd.cdname AS cd_name,
    cd.cdtype AS cd_type,
    cd.geom
FROM
    silver.pr_2021 AS pr,
    bronze.lcd_000a21a_e AS cd,
    silver.dissemination_geographies_relationship_2021 AS dgr,
    bronze.lcar000a21a_e AS car
WHERE
    pr.pr_dguid = dgr.pr_dguid
    AND cd.dguid = dgr.cd_dguid
    AND dgr.car_dguid = car.dguid;

-- Make geometries valid
UPDATE
    silver.cd_2021
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX cd_2021_geom_idx ON silver.cd_2021
USING gist (geom) WITH (fillfactor = 100);

/* 2016
Definition here: https://web.archive.org/web/20250304001456/https://www12.statcan.gc.ca/census-recensement/2016/ref/dict/geo008-eng.cfm
*/
