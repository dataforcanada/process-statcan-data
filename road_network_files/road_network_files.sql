/*
Road Network Files
*/

/* 2021
Definition here: https://web.archive.org/web/20240215050313/https://www12.statcan.gc.ca/census-recensement/2021/ref/dict/az/definition-eng.cfm?ID=geo041
*/

DROP TABLE IF EXISTS silver.road_2021;
CREATE TABLE silver.road_2021 AS
SELECT
    left_side.country_dguid,
    left_side.country_en_name,
    left_side.country_fr_name,
    left_side.country_en_abbreviation,
    left_side.country_fr_abbreviation,
    left_side.grc_dguid AS grc_dguid_left,
    right_side.grc_dguid AS grc_dguid_right,
    left_side.grc_en_name AS grc_en_name_left,
    right_side.grc_en_name AS grc_en_name_right,
    left_side.grc_fr_name AS grc_fr_name_left,
    right_side.grc_fr_name AS grc_fr_name_right,
    left_side.pr_dguid AS pr_dguid_left,
    right_side.pr_dguid AS pr_dguid_right,
    left_side.pr_en_name AS pr_en_name_left,
    right_side.pr_en_name AS pr_en_name_right,
    left_side.pr_fr_name AS pr_fr_name_left,
    right_side.pr_fr_name AS pr_fr_name_right,
    left_side.pr_iso_code AS pr_iso_code_left,
    right_side.pr_iso_code AS pr_iso_code_right,
    left_side.car_dguid AS car_dguid_left,
    right_side.car_dguid AS car_dguid_right,
    left_side.car_en_name AS car_en_name_left,
    right_side.car_en_name AS car_en_name_right,
    left_side.car_fr_name AS car_fr_name_left,
    right_side.car_fr_name AS car_fr_name_right,
    left_side.er_dguid AS er_dguid_left,
    right_side.er_dguid AS er_dguid_right,
    left_side.er_name AS er_name_left,
    right_side.er_name AS er_name_right,
    left_side.cd_dguid AS cd_dguid_left,
    right_side.cd_dguid AS cd_dguid_right,
    left_side.cd_name AS cd_name_left,
    right_side.cd_name AS cd_name_right,
    left_side.cd_type AS cd_type_left,
    right_side.cd_type AS cd_type_right,
    left_side.ccs_dguid AS ccs_dguid_left,
    right_side.ccs_dguid AS ccs_dguid_right,
    left_side.ccs_name AS ccs_name_left,
    right_side.ccs_name AS ccs_name_right,
    left_side.cma_dguid AS cma_dguid_left,
    right_side.cma_dguid AS cma_dguid_right,
    left_side.cma_p_dguid AS cma_p_dguid_left,
    right_side.cma_p_dguid AS cma_p_dguid_right,
    left_side.cma_name AS cma_name_left,
    right_side.cma_name AS cma_name_right,
    left_side.cma_type AS cma_type_left,
    right_side.cma_type AS cma_type_right,
    left_side.csd_dguid AS csd_dguid_left,
    right_side.csd_dguid AS csd_dguid_right,
    left_side.csd_name AS csd_name_left,
    right_side.csd_name AS csd_name_right,
    left_side.csd_type AS csd_type_left,
    right_side.csd_type AS csd_type_right,
    left_side.sac_type AS sac_type_left,
    right_side.sac_type AS sac_type_right,
    left_side.sac_code AS sac_code_left,
    right_side.sac_code AS sac_code_right,
    road.ngd_uid AS road_ngd_uid,
    road.name AS road_name,
    road.type AS road_type,
    road.dir AS road_direction,
    road.afl_val AS road_address_from_left_value,
    road.atl_val AS road_address_to_left_value,
    road.afr_val AS road_address_from_right_value,
    road.atr_val AS road_address_to_right_value,
    road.rank AS road_rank,
    road.class AS road_class,
    road.geom
FROM bronze.lrnf000r21a_e AS road
LEFT JOIN silver.csd_2021 AS left_side
    ON road.csddguid_l = left_side.csd_dguid
LEFT JOIN silver.csd_2021 AS right_side
    ON road.csddguid_r = right_side.csd_dguid;

-- Create spatial index
CREATE INDEX road_2021_geom_idx ON
silver.road_2021
USING gist (geom) WITH (fillfactor = 100);
