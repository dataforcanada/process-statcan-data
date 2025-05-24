/*
Population Centres
*/

/* 2021
Definition here: https://web.archive.org/web/20250324222733/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/definition-eng.cfm?ID=geo049a
*/

DROP TABLE IF EXISTS silver.pop_ctr_2021;
CREATE TABLE silver.pop_ctr_2021 AS
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
LEFT JOIN silver.pr_2021 AS pr
    ON gaf.pr_dguid = pr.pr_dguid
WHERE gaf.pop_ctr_dguid IS NOT null OR gaf.pop_ctr_p_dguid IS NOT null;

-- Make geometries valid
UPDATE
    silver.pop_ctr_2021
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX pop_ctr_2021_geom_idx ON silver.pop_ctr_2021 USING gist (
    geom
) WITH (fillfactor = 100);
