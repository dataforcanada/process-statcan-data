/*
Provinces and territories
*/

/* 2021
Definition here: https://web.archive.org/web/20240402175445/https://www150.statcan.gc.ca/n1/pub/92-195-x/2021001/geo/prov/prov-eng.htm
*/

-- Digital boundary;
DROP TABLE IF EXISTS silver.pr_2021_digital;
CREATE TABLE silver.pr_2021_digital AS
SELECT DISTINCT
    grc.country_dguid,
    grc.country_en_name,
    grc.country_fr_name,
    grc.country_en_abbreviation,
    grc.country_fr_abbreviation,
    grc.grc_dguid,
    grc.grc_en_name,
    grc.grc_fr_name,
    pr.dguid AS pr_dguid,
    pr.prename AS pr_en_name,
    pr.prfname AS pr_fr_name,
    pr.preabbr AS pr_en_abbreviation,
    pr.prfabbr AS pr_fr_abbreviation,
    CASE
        WHEN pr.pruid = '10' THEN 'NL'
        WHEN pr.pruid = '11' THEN 'PE'
        WHEN pr.pruid = '12' THEN 'NS'
        WHEN pr.pruid = '13' THEN 'NB'
        WHEN pr.pruid = '24' THEN 'QC'
        WHEN pr.pruid = '35' THEN 'ON'
        WHEN pr.pruid = '46' THEN 'MB'
        WHEN pr.pruid = '47' THEN 'SK'
        WHEN pr.pruid = '48' THEN 'AB'
        WHEN pr.pruid = '59' THEN 'BC'
        WHEN pr.pruid = '60' THEN 'YT'
        WHEN pr.pruid = '61' THEN 'NT'
        WHEN pr.pruid = '62' THEN 'NU'
    END AS pr_iso_code,
    pr.geom
FROM
    bronze.lpr_000a21a_e AS pr,
    silver.grc_pr_2021 AS grc
WHERE
    grc.pr_dguid = pr.dguid;

-- Make geometries valid
UPDATE
    silver.pr_2021_digital
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX pr_2021_digital_geom_idx ON pr_2021_digital USING gist (geom) WITH (
    fillfactor = 100
);

-- Cartographic boundary;
DROP TABLE IF EXISTS silver.pr_2021_cartographic;
CREATE TABLE silver.pr_2021_cartographic AS
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
    a.geom
FROM
    bronze.lpr_000b21a_e AS a,
    silver.pr_2021_digital AS b
WHERE
    b.pr_dguid = a.dguid;

-- Make geometries valid
UPDATE
    silver.pr_2021_cartographic
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX pr_2021_cartographic_geom_idx ON pr_2021_cartographic USING gist (geom) WITH (
    fillfactor = 100
);

/* 2016
Definition here: https://web.archive.org/web/20241104061057/https://www12.statcan.gc.ca/census-recensement/2016/ref/dict/geo038-eng.cfm
*/

-- Digital boundary;
DROP TABLE IF EXISTS silver.pr_2016_digital;
CREATE TABLE silver.pr_2016_digital AS
SELECT DISTINCT
    grc.country_dguid,
    grc.country_en_name,
    grc.country_fr_name,
    grc.country_en_abbreviation,
    grc.country_fr_abbreviation,
    grc.grc_dguid,
    grc.grc_en_name,
    grc.grc_fr_name,
    CONCAT('2016A0002', pr.pruid) AS pr_dguid,
    pr.prename AS pr_en_name,
    pr.prfname AS pr_fr_name,
    pr.preabbr AS pr_en_abbreviation,
    pr.prfabbr AS pr_fr_abbreviation,
    CASE
        WHEN pr.pruid = '10' THEN 'NL'
        WHEN pr.pruid = '11' THEN 'PE'
        WHEN pr.pruid = '12' THEN 'NS'
        WHEN pr.pruid = '13' THEN 'NB'
        WHEN pr.pruid = '24' THEN 'QC'
        WHEN pr.pruid = '35' THEN 'ON'
        WHEN pr.pruid = '46' THEN 'MB'
        WHEN pr.pruid = '47' THEN 'SK'
        WHEN pr.pruid = '48' THEN 'AB'
        WHEN pr.pruid = '59' THEN 'BC'
        WHEN pr.pruid = '60' THEN 'YT'
        WHEN pr.pruid = '61' THEN 'NT'
        WHEN pr.pruid = '62' THEN 'NU'
    END AS pr_iso_code,
    pr.geom
FROM
    bronze.lpr_000a16a_e AS pr,
    silver.grc_pr_2016 AS grc
WHERE
    grc.pr_dguid = CONCAT('2016A0002', pr.pruid);

-- Make geometries valid
UPDATE
    silver.pr_2016_digital
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX pr_2016_digital_geom_idx ON pr_2016_digital USING gist (geom) WITH (
    fillfactor = 100
);

-- Cartographic boundary;
DROP TABLE IF EXISTS silver.pr_2016_cartographic;
CREATE TABLE silver.pr_2016_cartographic AS
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
    a.geom
FROM
    bronze.lpr_000b16a_e AS a,
    silver.pr_2016_digital AS b
WHERE
    b.pr_dguid = CONCAT('2016A0002', a.pruid);

-- Make geometries valid
UPDATE
    silver.pr_2016_cartographic
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX pr_2016_cartographic_geom_idx ON pr_2016_cartographic USING gist (geom) WITH (
    fillfactor = 100
);