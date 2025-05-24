/*
Canada
*/

-- 2021 Canada;
DROP TABLE IF EXISTS silver.country_2021;
CREATE TABLE silver.country_2021 AS
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
    silver.country_2021
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX country_2021_geom_idx ON silver.country_2021
USING gist (geom) WITH (fillfactor = 100);

-- 2016 Canada;
DROP TABLE IF EXISTS silver.country_2016;
CREATE TABLE silver.country_2016 AS
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
    silver.country_2016
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX country_2016_geom_idx ON silver.country_2016
USING gist (geom) WITH (fillfactor = 100);

-- 2011 Canada;
DROP TABLE IF EXISTS silver.country_2011;
CREATE TABLE silver.country_2011 AS
SELECT DISTINCT
    '2011A000011124' AS country_dguid,
    'Canada' AS country_en_name,
    'Canada' AS country_fr_name,
    'CAN' AS country_en_abbreviation,
    'CAN' AS country_fr_abbreviation,
    st_union(geom) AS geom
FROM
    bronze.gpr_000a11a_e;

-- Make geometries valid
UPDATE
    silver.country_2011
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX country_2011_geom_idx ON silver.country_2011
USING gist (geom) WITH (fillfactor = 100);

-- 2006 Canada;
DROP TABLE IF EXISTS silver.country_2006;
CREATE TABLE silver.country_2006 AS
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
    silver.country_2006
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX country_2006_geom_idx ON silver.country_2006
USING gist (geom) WITH (fillfactor = 100);

-- 2001 Canada;
-- TODO
/*
-- Clean Provinces and Territories layer;
UPDATE
	bronze.gpr_000a06a_e
SET
	geom = st_makevalid(geom)
WHERE
	st_isvalid(geom) = 'f';
DROP TABLE IF EXISTS country_2001;

CREATE TABLE country_2001 AS
	SELECT
	DISTINCT '2001A000011124' AS country_dguid,
	'Canada' AS country_en_name,
	'Canada' AS country_fr_name,
	'CAN' AS country_en_abbreviation,
	'CAN' AS country_fr_abbreviation,
	st_union(geom) AS geom
FROM
	lpr_000a21a_e;

CREATE INDEX country_2001_geom_idx ON
country_2001
	USING GIST(geom) WITH (FILLFACTOR = 100);
*/
