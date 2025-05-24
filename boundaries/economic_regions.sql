/*
Economic Regions
*/

/* 2021
Definition here: https://web.archive.org/web/20250518132130/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/Definition-eng.cfm?ID=geo022
*/

DROP TABLE IF EXISTS silver.er_2021;
CREATE TABLE silver.er_2021 AS
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
    er.dguid AS er_dguid,
    er.ername AS er_name,
    er.geom
FROM
    silver.pr_2021 AS pr,
    silver.dissemination_geographies_relationship_2021 AS dgr,
    bronze.ler_000a21a_e AS er
WHERE
    pr.pr_dguid = dgr.pr_dguid
    AND
    er.dguid = dgr.er_dguid;

-- Make geometries valid
UPDATE
    silver.er_2021
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX er_2021_geom_idx ON silver.er_2021 USING gist (geom) WITH (
    fillfactor = 100
);
