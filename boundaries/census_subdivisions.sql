/*
Census Subdivisions
*/

/* 2021
Definition here: https://web.archive.org/web/20240526213705/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/Definition-eng.cfm?ID=geo012
*/

DROP TABLE IF EXISTS silver.csd_2021;
CREATE TABLE silver.csd_2021 AS
SELECT DISTINCT
    cd.country_dguid,
    cd.country_en_name,
    cd.country_fr_name,
    cd.country_en_abbreviation,
    cd.country_fr_abbreviation,
    cd.grc_dguid,
    cd.grc_en_name,
    cd.grc_fr_name,
    cd.pr_dguid,
    cd.pr_en_name,
    cd.pr_fr_name,
    cd.pr_en_abbreviation,
    cd.pr_fr_abbreviation,
    cd.pr_iso_code,
    cd.car_dguid,
    cd.car_en_name,
    cd.car_fr_name,
    er.er_dguid,
    er.er_name,
    cd.cd_dguid,
    cd.cd_name,
    cd.cd_type,
    ccs.ccs_dguid,
    ccs.ccs_name,
    gaf.cma_dguid,
    gaf.cma_p_dguid,
    cma.cma_name,
    cma.cma_type,
    gaf.csd_dguid,
    csd.csdname AS csd_name,
    csd.csdtype AS csd_type,
    gaf.sac_type,
    gaf.sac_code,
    csd.geom
FROM silver.gaf_2021 AS gaf
LEFT JOIN silver.cma_2021 AS cma
    ON
        concat(gaf.cma_dguid, gaf.cma_p_dguid)
        = concat(cma.cma_dguid, cma.cma_p_dguid)
LEFT JOIN silver.cd_2021 AS cd
    ON gaf.cd_dguid = cd.cd_dguid
LEFT JOIN silver.er_2021 AS er
    ON gaf.er_dguid = er.er_dguid
LEFT JOIN silver.ccs_2021 AS ccs
    ON gaf.ccs_dguid = ccs.ccs_dguid
LEFT JOIN bronze.lcsd000a21a_e AS csd
    ON gaf.csd_dguid = csd.dguid;

-- Make geometries valid
UPDATE
    silver.csd_2021
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX csd_2021_geom_idx ON silver.csd_2021 USING gist (geom) WITH (
    fillfactor = 100
);
