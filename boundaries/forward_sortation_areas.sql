/*
Forward Sortation Areas
*/

/* 2021
Definition here: https://web.archive.org/web/20241102112247/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/Definition-eng.cfm?ID=geo036
*/

DROP TABLE IF EXISTS silver.fsa_2021;
CREATE TABLE silver.fsa_2021 AS
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
    fsa.dguid AS fsa_dguid,
    fsa.geom
FROM bronze.lfsa000a21a_e AS fsa,
    silver.pr_2021 AS pr
WHERE concat('2021A0002', fsa.pruid) = pr.pr_dguid;

-- Make geometries valid
UPDATE
    silver.fsa_2021
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX fsa_2021_geom_idx ON silver.fsa_2021 USING gist (geom) WITH (
    fillfactor = 100
);
