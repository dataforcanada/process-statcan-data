/*
Population Centres
*/

/* 2021
Definition here: https://web.archive.org/web/20250324222733/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/definition-eng.cfm?ID=geo049a
*/

-- Digital boundary;
DROP TABLE IF EXISTS silver.pop_ctr_2021_digital;
CREATE TABLE silver.pop_ctr_2021_digital AS
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
    gaf.pop_ctr_dguid,
    gaf.pop_ctr_p_dguid,
    pop_ctr.pcname AS pop_ctr_name,
    pop_ctr.pctype AS pop_ctr_type,
    pop_ctr.pcclass AS pop_ctr_class,
    pop_ctr.geom
FROM silver.gaf_2021 AS gaf
LEFT JOIN bronze.lpc_000a21a_e AS pop_ctr
    ON
        concat(gaf.pop_ctr_dguid, gaf.pop_ctr_p_dguid)
        = concat(pop_ctr.dguid, pop_ctr.dguidp)
LEFT JOIN silver.pr_2021_digital AS pr
    ON gaf.pr_dguid = pr.pr_dguid
WHERE gaf.pop_ctr_dguid IS NOT null OR gaf.pop_ctr_p_dguid IS NOT null;

-- Make geometries valid
UPDATE
    silver.pop_ctr_2021_digital
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX pop_ctr_2021_digital_geom_idx ON silver.pop_ctr_2021_digital USING gist (
    geom
) WITH (fillfactor = 100);

-- Cartographic boundary;
DROP TABLE IF EXISTS silver.pop_ctr_2021_cartographic;
CREATE TABLE silver.pop_ctr_2021_cartographic AS
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
    b.pop_ctr_dguid,
    b.pop_ctr_p_dguid,
    b.pop_ctr_name,
    b.pop_ctr_type,
    b.pop_ctr_class,
    a.geom
FROM
    bronze.lpc_000b21a_e AS a,
    silver.pop_ctr_2021_digital AS b
WHERE concat(b.pop_ctr_dguid, b.pop_ctr_p_dguid) = concat(a.dguid, a.dguidp);

-- Make geometries valid
UPDATE
    silver.pop_ctr_2021_cartographic
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX pop_ctr_2021_cartographic_geom_idx ON silver.pop_ctr_2021_cartographic USING gist (
    geom
) WITH (fillfactor = 100);