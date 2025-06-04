/*
Census Subdivisions
*/

/* 2021
Definition here: https://web.archive.org/web/20240526213705/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/Definition-eng.cfm?ID=geo012
*/

-- Digital boundary;
DROP TABLE IF EXISTS silver.csd_2021_digital;
CREATE TABLE silver.csd_2021_digital AS
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
LEFT JOIN silver.cma_2021_digital AS cma
    ON
        concat(gaf.cma_dguid, gaf.cma_p_dguid)
        = concat(cma.cma_dguid, cma.cma_p_dguid)
LEFT JOIN silver.cd_2021_digital AS cd
    ON gaf.cd_dguid = cd.cd_dguid
LEFT JOIN silver.er_2021_digital AS er
    ON gaf.er_dguid = er.er_dguid
LEFT JOIN silver.ccs_2021_digital AS ccs
    ON gaf.ccs_dguid = ccs.ccs_dguid
LEFT JOIN bronze.lcsd000a21a_e AS csd
    ON gaf.csd_dguid = csd.dguid;

-- Make geometries valid
UPDATE
    silver.csd_2021_digital
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX csd_2021_digital_geom_idx ON silver.csd_2021_digital USING gist (geom) WITH (
    fillfactor = 100
);

-- Cartographic boundary;
DROP TABLE IF EXISTS silver.csd_2021_cartographic;
CREATE TABLE silver.csd_2021_cartographic AS
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
    b.car_dguid,
    b.car_en_name,
    b.car_fr_name,
    b.er_dguid,
    b.er_name,
    b.cd_dguid,
    b.cd_name,
    b.cd_type,
    b.ccs_dguid,
    b.ccs_name,
    b.cma_dguid,
    b.cma_p_dguid,
    b.cma_name,
    b.cma_type,
    b.csd_dguid,
    b.csd_name,
    b.csd_type,
    b.sac_type,
    b.sac_code,
    a.geom
FROM
    bronze.lcsd000b21a_e AS a,
    silver.csd_2021_digital AS b
WHERE a.dguid = b.csd_dguid;

-- Make geometries valid
UPDATE
    silver.csd_2021_cartographic
SET
    geom = st_makevalid(geom)
WHERE
    st_isvalid(geom) = 'f';

-- Create spatial index
CREATE INDEX csd_2021_cartographic_geom_idx ON silver.csd_2021_cartographic USING gist (geom) WITH (
    fillfactor = 100
);