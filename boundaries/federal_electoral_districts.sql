/*
Federal Electoral Districts
*/

/* 2021
Definition here: https://web.archive.org/web/20240731061905/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/Definition-eng.cfm?ID=geo025
*/

-- 2021 vintage, 2013 representation order;
DROP TABLE IF EXISTS silver.fed_2021_2013;
CREATE TABLE silver.fed_2021_2013 AS
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
    dgr.fed_dguid,
    fed.fedname AS fed_name,
    fed.fedename AS fed_en_name,
    fed.fedfname AS fed_fr_name,
    fed.geom
FROM silver.dissemination_geographies_relationship_2021 AS dgr
LEFT JOIN silver.pr_2021 AS pr
    ON dgr.pr_dguid = pr.pr_dguid
LEFT JOIN bronze.lfed000a21a_e AS fed
    ON dgr.fed_dguid = fed.dguid
WHERE dgr.fed_dguid IS NOT null;

-- Make geometries valid
UPDATE
    silver.fed_2021_2013
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX fed_2021_2013_geom_idx ON silver.fed_2021_2013 USING gist (geom) WITH (
    fillfactor = 100
);
