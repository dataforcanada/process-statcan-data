/*
Geographic Regions of Canada
*/

/* 2021
Definition here: https://web.archive.org/web/20240624230708/https://www150.statcan.gc.ca/n1/pub/92-195-x/2021001/geo/region/region-eng.htm
*/

-- With geometries;
DROP TABLE IF EXISTS silver.grc_2021;
CREATE TABLE silver.grc_2021 AS
WITH territories AS (
    SELECT
        '2021A00016' AS grc_dguid,
        'Territories' AS grc_en_name,
        'Territoires' AS grc_fr_name,
        ST_UNION(geom) AS geom
    FROM
        bronze.lpr_000a21a_e
    WHERE
        pruid IN ('60', '61', '62')
),

atlantic AS (
    SELECT
        '2021A00011' AS grc_dguid,
        'Atlantic' AS grc_en_name,
        'Atlantique' AS grc_fr_name,
        ST_UNION(geom) AS geom
    FROM
        bronze.lpr_000a21a_e
    WHERE
        pruid IN ('10', '11', '12', '13')
),

prairies AS (
    SELECT
        '2021A00014' AS grc_dguid,
        'Prairies' AS grc_en_name,
        'Prairies' AS grc_fr_name,
        ST_UNION(geom) AS geom
    FROM
        bronze.lpr_000a21a_e
    WHERE
        pruid IN ('48', '47', '46')
),

the_rest AS (
    SELECT
        CASE
            WHEN pruid = '59' THEN '2021A00015'
            WHEN pruid = '35' THEN '2021A00013'
            WHEN pruid = '24' THEN '2021A00012'
        END AS grc_dguid,
        prename AS grc_en_name,
        prfname AS grc_fr_name,
        geom
    FROM
        bronze.lpr_000a21a_e
    WHERE
        pruid IN ('59', '35', '24')
),

final AS (
    SELECT
        country.country_dguid,
        country.country_en_name,
        country.country_fr_name,
        country.country_en_abbreviation,
        country.country_fr_abbreviation,
        territories.*
    FROM
        territories,
        silver.country_2021 AS country
    UNION
    SELECT
        country.country_dguid,
        country.country_en_name,
        country.country_fr_name,
        country.country_en_abbreviation,
        country.country_fr_abbreviation,
        prairies.*
    FROM
        prairies,
        silver.country_2021 AS country
    UNION
    SELECT
        country.country_dguid,
        country.country_en_name,
        country.country_fr_name,
        country.country_en_abbreviation,
        country.country_fr_abbreviation,
        atlantic.*
    FROM
        atlantic,
        silver.country_2021 AS country
    UNION
    SELECT
        country.country_dguid,
        country.country_en_name,
        country.country_fr_name,
        country.country_en_abbreviation,
        country.country_fr_abbreviation,
        the_rest.*
    FROM
        the_rest,
        silver.country_2021 AS country
)

SELECT *
FROM
    final;

-- Make geometries valid
UPDATE
    silver.grc_2021
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX grc_2021_geom_idx ON silver.grc_2021
USING gist (geom) WITH (fillfactor = 100);

-- 2021 without geometries, and with pr_dguid;
DROP TABLE IF EXISTS silver.grc_pr_2021;
CREATE TABLE silver.grc_pr_2021 AS
WITH territories AS (
    SELECT
        '2021A00016' AS grc_dguid,
        'Territories' AS grc_en_name,
        'Territoires' AS grc_fr_name,
        dguid AS pr_dguid
    FROM
        bronze.lpr_000a21a_e
    WHERE
        pruid IN ('60', '61', '62')
),

atlantic AS (
    SELECT
        '2021A00011' AS grc_dguid,
        'Atlantic' AS grc_en_name,
        'Atlantique' AS grc_fr_name,
        dguid AS pr_dguid
    FROM
        bronze.lpr_000a21a_e
    WHERE
        pruid IN ('10', '11', '12', '13')
),

prairies AS (
    SELECT
        '2021A00014' AS grc_dguid,
        'Prairies' AS grc_en_name,
        'Prairies' AS grc_fr_name,
        dguid AS pr_dguid
    FROM
        bronze.lpr_000a21a_e
    WHERE
        pruid IN ('48', '47', '46')
),

the_rest AS (
    SELECT
        CASE
            WHEN pruid = '59' THEN '2021A00015'
            WHEN pruid = '35' THEN '2021A00013'
            WHEN pruid = '24' THEN '2021A00012'
        END AS grc_dguid,
        prename AS grc_en_name,
        prfname AS grc_fr_name,
        dguid AS pr_dguid
    FROM
        bronze.lpr_000a21a_e
    WHERE
        pruid IN ('59', '35', '24')
),

final AS (
    SELECT
        country.country_dguid,
        country.country_en_name,
        country.country_fr_name,
        country.country_en_abbreviation,
        country.country_fr_abbreviation,
        territories.*
    FROM
        territories,
        silver.country_2021 AS country
    UNION
    SELECT
        country.country_dguid,
        country.country_en_name,
        country.country_fr_name,
        country.country_en_abbreviation,
        country.country_fr_abbreviation,
        prairies.*
    FROM
        prairies,
        silver.country_2021 AS country
    UNION
    SELECT
        country.country_dguid,
        country.country_en_name,
        country.country_fr_name,
        country.country_en_abbreviation,
        country.country_fr_abbreviation,
        atlantic.*
    FROM
        atlantic,
        silver.country_2021 AS country
    UNION
    SELECT
        country.country_dguid,
        country.country_en_name,
        country.country_fr_name,
        country.country_en_abbreviation,
        country.country_fr_abbreviation,
        the_rest.*
    FROM
        the_rest,
        silver.country_2021 AS country
)

SELECT *
FROM
    final;

/* 2016
Definition here: https://web.archive.org/web/20240224030001/https://www12.statcan.gc.ca/census-recensement/2016/ref/dict/geo027a-eng.cfm
*/

-- With geometries;
DROP TABLE IF EXISTS silver.grc_2016;
CREATE TABLE silver.grc_2016 AS
WITH territories AS (
    SELECT
        '2016A00016' AS grc_dguid,
        'Territories' AS grc_en_name,
        'Territoires' AS grc_fr_name,
        ST_UNION(geom) AS geom
    FROM
        bronze.lpr_000a16a_e
    WHERE
        pruid IN ('60', '61', '62')
),

atlantic AS (
    SELECT
        '2016A00011' AS grc_dguid,
        'Atlantic' AS grc_en_name,
        'Atlantique' AS grc_fr_name,
        ST_UNION(geom) AS geom
    FROM
        bronze.lpr_000a16a_e
    WHERE
        pruid IN ('10', '11', '12', '13')
),

prairies AS (
    SELECT
        '2016A00014' AS grc_dguid,
        'Prairies' AS grc_en_name,
        'Prairies' AS grc_fr_name,
        ST_UNION(geom) AS geom
    FROM
        bronze.lpr_000a16a_e
    WHERE
        pruid IN ('48', '47', '46')
),

the_rest AS (
    SELECT
        CASE
            WHEN pruid = '59' THEN '2016A00015'
            WHEN pruid = '35' THEN '2016A00013'
            WHEN pruid = '24' THEN '2016A00012'
        END AS grc_dguid,
        prename AS grc_en_name,
        prfname AS grc_fr_name,
        geom
    FROM
        bronze.lpr_000a16a_e
    WHERE
        pruid IN ('59', '35', '24')
),

final AS (
    SELECT
        country.country_dguid,
        country.country_en_name,
        country.country_fr_name,
        country.country_en_abbreviation,
        country.country_fr_abbreviation,
        territories.*
    FROM
        territories,
        silver.country_2016 AS country
    UNION
    SELECT
        country.country_dguid,
        country.country_en_name,
        country.country_fr_name,
        country.country_en_abbreviation,
        country.country_fr_abbreviation,
        prairies.*
    FROM
        prairies,
        silver.country_2016 AS country
    UNION
    SELECT
        country.country_dguid,
        country.country_en_name,
        country.country_fr_name,
        country.country_en_abbreviation,
        country.country_fr_abbreviation,
        atlantic.*
    FROM
        atlantic,
        silver.country_2016 AS country
    UNION
    SELECT
        country.country_dguid,
        country.country_en_name,
        country.country_fr_name,
        country.country_en_abbreviation,
        country.country_fr_abbreviation,
        the_rest.*
    FROM
        the_rest,
        silver.country_2016 AS country
)

SELECT *
FROM
    final;

-- Make geometries valid
UPDATE
    silver.grc_2016
SET
    geom = ST_MAKEVALID(geom)
WHERE
    ST_ISVALID(geom) = 'f';

-- Create spatial index
CREATE INDEX grc_2016_geom_idx ON silver.grc_2016
USING gist (geom) WITH (fillfactor = 100);

-- 2016 without geometries, and with pr_dguid;
DROP TABLE IF EXISTS silver.grc_pr_2016;

CREATE TABLE silver.grc_pr_2016 AS
WITH territories AS (
    SELECT
        '2016A00016' AS grc_dguid,
        'Territories' AS grc_en_name,
        'Territoires' AS grc_fr_name,
        CONCAT('2016A0002', pruid) AS pr_dguid
    FROM
        bronze.lpr_000a16a_e
    WHERE
        pruid IN ('60', '61', '62')
),

atlantic AS (
    SELECT
        '2016A00011' AS grc_dguid,
        'Atlantic' AS grc_en_name,
        'Atlantique' AS grc_fr_name,
        CONCAT('2016A0002', pruid) AS pr_dguid
    FROM
        bronze.lpr_000a16a_e
    WHERE
        pruid IN ('10', '11', '12', '13')
),

prairies AS (
    SELECT
        '2016A00014' AS grc_dguid,
        'Prairies' AS grc_en_name,
        'Prairies' AS grc_fr_name,
        CONCAT('2016A0002', pruid) AS pr_dguid
    FROM
        bronze.lpr_000a16a_e
    WHERE
        pruid IN ('48', '47', '46')
),

the_rest AS (
    SELECT
        CASE
            WHEN pruid = '59' THEN '2016A00015'
            WHEN pruid = '35' THEN '2016A00013'
            WHEN pruid = '24' THEN '2016A00012'
        END AS grc_dguid,
        prename AS grc_en_name,
        prfname AS grc_fr_name,
        CONCAT('2016A0002', pruid) AS pr_dguid
    FROM
        bronze.lpr_000a16a_e
    WHERE
        pruid IN ('59', '35', '24')
),

final AS (
    SELECT
        country.country_dguid,
        country.country_en_name,
        country.country_fr_name,
        country.country_en_abbreviation,
        country.country_fr_abbreviation,
        territories.*
    FROM
        territories,
        silver.country_2016 AS country
    UNION
    SELECT
        country.country_dguid,
        country.country_en_name,
        country.country_fr_name,
        country.country_en_abbreviation,
        country.country_fr_abbreviation,
        prairies.*
    FROM
        prairies,
        silver.country_2016 AS country
    UNION
    SELECT
        country.country_dguid,
        country.country_en_name,
        country.country_fr_name,
        country.country_en_abbreviation,
        country.country_fr_abbreviation,
        atlantic.*
    FROM
        atlantic,
        silver.country_2016 AS country
    UNION
    SELECT
        country.country_dguid,
        country.country_en_name,
        country.country_fr_name,
        country.country_en_abbreviation,
        country.country_fr_abbreviation,
        the_rest.*
    FROM
        the_rest,
        silver.country_2016 AS country
)

SELECT *
FROM
    final;

/* 2011
Definition here: https://web.archive.org/web/20240214024306/https://www12.statcan.gc.ca/census-recensement/2011/ref/dict/geo027a-eng.cfm
*/

/*
2006
No definition in 2006 dictionary https://www12.statcan.gc.ca/census-recensement/2006/ref/dict/azindex-eng.cfm
*/

/*
2001

Census Dictionary is available here https://www12.statcan.gc.ca/access_acces/archive.action-eng.cfm?/english/census01/products/reference/dict/appendices/92-378-XIE02002.pdf
*/
