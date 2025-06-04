/*
Canada
*/

-- 2021 Canada digital boundary;
DROP TABLE IF EXISTS silver.country_2021_digital;
CREATE TABLE silver.country_2021_digital AS
SELECT DISTINCT
    '2021A000011124' AS country_dguid,
    'Canada' AS country_en_name,
    'Canada' AS country_fr_name,
    'CAN' AS country_en_abbreviation,
    'CAN' AS country_fr_abbreviation,
    ST_UNION(geom) AS geom
FROM
    bronze.lpr_000a21a_e;

-- Make geometries valid
UPDATE
    silver.country_2021_digital
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX country_2021_digital_geom_idx ON silver.country_2021_digital
USING gist (geom) WITH (fillfactor = 100);

-- 2021 Canada cartographic boundary;
DROP TABLE IF EXISTS silver.country_2021_cartographic;
CREATE TABLE silver.country_2021_cartographic AS
SELECT DISTINCT
    '2021A000011124' AS country_dguid,
    'Canada' AS country_en_name,
    'Canada' AS country_fr_name,
    'CAN' AS country_en_abbreviation,
    'CAN' AS country_fr_abbreviation,
    ST_UNION(geom) AS geom
FROM
    bronze.lpr_000b21a_e;

-- Make geometries valid
UPDATE
    silver.country_2021_cartographic
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX country_2021_cartographic_geom_idx ON silver.country_2021_cartographic
USING gist (geom) WITH (fillfactor = 100);

-- 2016 Canada digital boundary;
DROP TABLE IF EXISTS silver.country_2016_digital;
CREATE TABLE silver.country_2016_digital AS
SELECT DISTINCT
    '2016A000011124' AS country_dguid,
    'Canada' AS country_en_name,
    'Canada' AS country_fr_name,
    'CAN' AS country_en_abbreviation,
    'CAN' AS country_fr_abbreviation,
    ST_UNION(geom) AS geom
FROM
    bronze.lpr_000a16a_e;

-- Make geometries valid
UPDATE
    silver.country_2016_digital
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX country_2016_digital_geom_idx ON silver.country_2016_digital
USING gist (geom) WITH (fillfactor = 100);

-- 2016 Canada cartographic boundary;
DROP TABLE IF EXISTS silver.country_2016_cartographic;
CREATE TABLE silver.country_2016_cartographic AS
SELECT DISTINCT
    '2016A000011124' AS country_dguid,
    'Canada' AS country_en_name,
    'Canada' AS country_fr_name,
    'CAN' AS country_en_abbreviation,
    'CAN' AS country_fr_abbreviation,
    ST_UNION(geom) AS geom
FROM
    bronze.lpr_000b16a_e;

-- Make geometries valid
UPDATE
    silver.country_2016_cartographic
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX country_2016_cartographic_geom_idx ON silver.country_2016_cartographic
USING gist (geom) WITH (fillfactor = 100);

-- 2011 Canada digital boundary;
DROP TABLE IF EXISTS silver.country_2011_digital;
CREATE TABLE silver.country_2011_digital AS
SELECT DISTINCT
    '2011A000011124' AS country_dguid,
    'Canada' AS country_en_name,
    'Canada' AS country_fr_name,
    'CAN' AS country_en_abbreviation,
    'CAN' AS country_fr_abbreviation,
    ST_UNION(geom) AS geom
FROM
    bronze.gpr_000a11a_e;

-- Make geometries valid
UPDATE
    silver.country_2011_digital
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX country_2011_digital_geom_idx ON silver.country_2011_digital
USING gist (geom) WITH (fillfactor = 100);

-- 2011 Canada cartographic boundary;
DROP TABLE IF EXISTS silver.country_2011_cartographic;
CREATE TABLE silver.country_2011_cartographic AS
SELECT DISTINCT
    '2011A000011124' AS country_dguid,
    'Canada' AS country_en_name,
    'Canada' AS country_fr_name,
    'CAN' AS country_en_abbreviation,
    'CAN' AS country_fr_abbreviation,
    ST_UNION(geom) AS geom
FROM
    bronze.gpr_000b11a_e;

-- Make geometries valid
UPDATE
    silver.country_2011_cartographic
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX country_2011_cartographic_geom_idx ON silver.country_2011_cartographic
USING gist (geom) WITH (fillfactor = 100);

-- 2006 Canada digital boundary;
DROP TABLE IF EXISTS silver.country_2006_digital;
CREATE TABLE silver.country_2006_digital AS
SELECT DISTINCT
    '2006A000011124' AS country_dguid,
    'Canada' AS country_en_name,
    'Canada' AS country_fr_name,
    'CAN' AS country_en_abbreviation,
    'CAN' AS country_fr_abbreviation,
    ST_UNION(geom) AS geom
FROM
    bronze.gpr_000a06a_e;

-- Make geometries valid
UPDATE
    silver.country_2006_digital
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX country_2006_digital_geom_idx ON silver.country_2006_digital
USING gist (geom) WITH (fillfactor = 100);

-- 2006 Canada cartographic boundary;
DROP TABLE IF EXISTS silver.country_2006_cartographic;
CREATE TABLE silver.country_2006_cartographic AS
SELECT DISTINCT
    '2006A000011124' AS country_dguid,
    'Canada' AS country_en_name,
    'Canada' AS country_fr_name,
    'CAN' AS country_en_abbreviation,
    'CAN' AS country_fr_abbreviation,
    ST_UNION(geom) AS geom
FROM
    bronze.gpr_000b06a_e;

-- Make geometries valid
UPDATE
    silver.country_2006_cartographic
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX country_2006_cartographic_geom_idx ON silver.country_2006_cartographic
USING gist (geom) WITH (fillfactor = 100);