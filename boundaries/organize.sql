/*
PR
*/

/* 2001 Provinces and Territories */
drop table if exists statcan_pr_2001;
create table statcan_pr_2001 as
	select distinct pruid, prename, prfname, preabbr, prfabbr, 
		concat('2001A0002', pruid) as dguid,
		st_union(geom) as geom
			from statcan_gpr_000b02m_e_tmp
				group by pruid, prename, prfname, preabbr, prfabbr;

create index statcan_pr_2001_geom_idx on statcan_pr_2001 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gpr_000b02m_e_tmp;

/* 2006 Provinces and Territories */
drop table if exists statcan_pr_2006;
create table statcan_pr_2006 as
	select pruid, prename, prfname, preabbr, prfabbr, 
		concat('2006A0002', pruid) as dguid,
		geom
			from statcan_gpr_000a06a_e;
				
create index statcan_pr_2006_geom_idx on statcan_pr_2006 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gpr_000b02m_e_tmp;

/* 2011 Provinces and Territories */
drop table if exists statcan_pr_2011;
create table statcan_pr_2011 as
	select pruid, prename, prfname, preabbr, prfabbr, 
		concat('2011A0002', pruid) as dguid,
		geom
			from statcan_gpr_000a11a_e;
				
create index statcan_pr_2011_geom_idx on statcan_pr_2011 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gpr_000a11a_e;

/* 2016 Provinces and Territories */
drop table if exists statcan_pr_2016;
create table statcan_pr_2016 as
	select pruid, prename, prfname, preabbr, prfabbr, 
		concat('2016A0002', pruid) as dguid,
		geom
			from statcan_lpr_000a16a_e;
				
create index statcan_pr_2016_geom_idx on statcan_pr_2016 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_lpr_000a16a_e;

/* 
CD
*/
--- 2001 Census Divisions;
drop table if exists statcan_cd_2001;
create table statcan_cd_2001 as
	select distinct pruid, cduid, cdname, cdtype,
		concat('2001A0003', cduid) as dguid,
		st_union(geom) as geom
			from statcan_gcd_000b02m_e_tmp
				group by pruid, cduid, cdname, cdtype;

create index statcan_cd_2001_geom_idx on statcan_cd_2001 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gcd_000b02m_e_tmp;

--- 2006 Census Divisions;
drop table if exists statcan_cd_2006;
create table statcan_cd_2006 as
	select pruid, cduid, cdname, cdtype,
		concat('2006A0003', cduid) as dguid,
		geom
			from statcan_gcd_000a06a_e;
				
create index statcan_cd_2006_geom_idx on statcan_cd_2006 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gcd_000a06a_e;

--- 2011 Census Divisions;
drop table if exists statcan_cd_2011;
create table statcan_cd_2011 as
	select pruid, cduid, cdname, cdtype, concat('2011A0003', cduid) as dguid,
		geom
			from statcan_gcd_000a11a_e;
				
create index statcan_cd_2011_geom_idx on statcan_cd_2011 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gcd_000a11a_e;

--- 2016 Census Divisions;
drop table if exists statcan_cd_2016;
create table statcan_cd_2016 as
	select pruid, cduid, cdname, cdtype, 
		concat('2016A0003', cduid) as dguid,
		geom
			from statcan_lcd_000a16a_e;
				
create index statcan_cd_2016_geom_idx on statcan_cd_2016 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_lcd_000a16a_e;

/*
ER
*/
--- 2001 Economic Regions;
drop table if exists statcan_er_2001;
create table statcan_er_2001 as
	select distinct pruid, eruid, ername, 
		concat('2001S0500', eruid) as dguid,
		st_union(geom) as geom
			from statcan_ger_000b02m_e_tmp
				group by pruid, eruid, ername;

create index statcan_er_2001_geom_idx on statcan_er_2001 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_ger_000b02m_e_tmp;

--- 2006 Economic Regions;
drop table if exists statcan_er_2006;
create table statcan_er_2006 as
	select distinct pruid, eruid, ername, 
		concat('2006S0500', eruid) as dguid, geom
			from statcan_ger_000a06a_e;

create index statcan_er_2006_geom_idx on statcan_er_2006 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_ger_000a06a_e;

--- 2011 Economic Regions;
drop table if exists statcan_er_2011;
create table statcan_er_2011 as
	select distinct pruid, eruid, ername, 
		concat('2011S0500', eruid) as dguid, geom
			from statcan_ger_000a11a_e;

create index statcan_er_2011_geom_idx on statcan_er_2011 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_ger_000a11a_e;

--- 2016 Economic Regions;
drop table if exists statcan_er_2016;
create table statcan_er_2016 as
	select distinct pruid, eruid, ername, 
		concat('2016S0500', eruid) as dguid, geom
			from statcan_ler_000a16a_e;

create index statcan_er_2016_geom_idx on statcan_er_2016 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_ler_000a16a_e;

/*
CCS
*/

--- 2001 Census Consolidated Subdivision;
drop table if exists statcan_ccs_2001;
create table statcan_ccs_2001 as
	select distinct pruid, ccsuid, ccsname, 
		concat('2001S0502', ccsuid) as dguid,
		st_union(geom) as geom
			from statcan_gccs000b02m_e_tmp
				group by pruid, ccsuid, ccsname;

create index statcan_ccs_2001_geom_idx on statcan_ccs_2001 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gccs000b02m_e_tmp;

--- 2006 Census Consolidated Subdivision;
drop table if exists statcan_ccs_2006;
create table statcan_ccs_2006 as
	select distinct pruid, ccsuid, ccsname, 
		concat('2006S0502', ccsuid) as dguid, geom
			from statcan_gccs000a06a_e;

create index statcan_ccs_2006_geom_idx on statcan_ccs_2006 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gccs000a06a_e;

--- 2011 Census Consolidated Subdivision;
drop table if exists statcan_ccs_2011;
create table statcan_ccs_2011 as
	select distinct pruid, cduid, ccsuid, ccsname, 
		concat('2011S0502', ccsuid) as dguid, geom
			from statcan_gccs000a11a_e;

create index statcan_ccs_2011_geom_idx on statcan_ccs_2011 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gccs000a11a_e;

--- 2016 Census Consolidated Subdivision;
drop table if exists statcan_ccs_2016;
create table statcan_ccs_2016 as
	select distinct pruid, cduid, ccsuid, ccsname, 
		concat('2016S0502', ccsuid) as dguid, geom
			from statcan_lcsd000a16a_e;

create index statcan_ccs_2016_geom_idx on statcan_ccs_2016 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_lcsd000a16a_e;

/* 
CSD
*/

/* 2001 Census Subdivisions */
drop table if exists statcan_csd_2001;
create table statcan_csd_2001 as
	select distinct pruid, csduid, csdname, csdtype, eruid, 
		concat('2001A0005', csduid) as dguid,
		st_union(geom) as geom
			from statcan_gcsd000b02m_e_tmp
				group by pruid, csduid, csdname, csdtype, eruid;

create index statcan_csd_2001_geom_idx on statcan_csd_2001 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gcsd000b02m_e_tmp;

/* 2006 Census Subdivisions */
drop table if exists statcan_csd_2006;
create table statcan_csd_2006 as
	select pruid, csduid, csdname, csdtype, concat(pruid, cmauid) as cmapuid,
		concat('2006A0005', csduid) as dguid,
		geom
			from statcan_gcsd000a06a_e;
				
create index statcan_csd_2006_geom_idx on statcan_csd_2006 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gcsd000a06a_e;

/* 2011 Census Subdivisions */
drop table if exists statcan_csd_2011;
create table statcan_csd_2011 as
	select pruid, cduid, ccsuid, csduid, csdname, csdtype, eruid, cmapuid,
		concat('2011A0005', csduid) as dguid,
		geom
			from statcan_gcsd000a11a_e;
				
create index statcan_csd_2011_geom_idx on statcan_csd_2011 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gcsd000a11a_e;

/* 2016 Census Subdivisions */
drop table if exists statcan_csd_2016;
create table statcan_csd_2016 as
	select pruid, cduid, ccsuid, csduid, csdname, csdtype, eruid, cmapuid,
		concat('2016A0005', csduid) as dguid,
		geom
			from statcan_lcsd000a16a_e;
				
create index statcan_csd_2016_geom_idx on statcan_csd_2016 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_lcsd000a16a_e;

/*
FED
*/

--- 2003 Federal Electoral Districts;
drop table if exists statcan_fed_2003;
create table statcan_fed_2003 as
	select distinct pruid, feduid, fedname, fedename, fedfname, 
		concat('2003A0004', feduid) as dguid, geom
			from statcan_gfed000a11a_e;
				
create index statcan_fed_2003_geom_idx on statcan_fed_2003 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gfed000a11a_e;

--- 2013 Federal Electoral Districts;
drop table if exists statcan_fed_2013;
create table statcan_fed_2013 as
	select distinct pruid, feduid, fedname, fedename, fedfname, 
		concat('2013A0004', feduid) as dguid, geom
			from statcan_lfed000a21a_e;
				
create index statcan_fed_2013_geom_idx on statcan_fed_2013 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_lfed000a21a_e;
drop table if exists statcan_lfed000a16a_e;

/*
Census Agricultural Regions
*/

--- 2001 Census Agricultural Regions;
drop table if exists statcan_car_2001;
create table statcan_car_2001 as
	select distinct pruid, caruid, carname, aguid, water,
		concat('2001S0501', caruid) as dguid, geom
			from statcan_gcar000b03m_e_tmp;
				
create index statcan_car_2001_geom_idx on statcan_car_2001 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gcar000b03m_e_tmp;

--- 2006 Census Agricultural Regions;
drop table if exists statcan_car_2006;
create table statcan_car_2006 as
	select distinct pruid, caruid, carname, aguid,
		concat('2006S0501', caruid) as dguid, geom
			from statcan_gcar000a06a_e;
				
create index statcan_car_2006_geom_idx on statcan_car_2006 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gcar000a06a_e;

--- 2011 Census Agricultural Regions;
drop table if exists statcan_car_2011;
create table statcan_car_2011 as
	select distinct pruid, caruid, carname, aguid,
		concat('2011S0501', caruid) as dguid, geom
			from statcan_gcar000a11a_e;
				
create index statcan_car_2011_geom_idx on statcan_car_2011 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gcar000a11a_e;

--- 2016 Census Agricultural Regions;
drop table if exists statcan_car_2016;
create table statcan_car_2016 as
	select distinct pruid, caruid, carename, carfname,
		concat('2016S0501', caruid) as dguid, geom
			from statcan_lcar000a16a_e;
				
create index statcan_car_2016_geom_idx on statcan_car_2016 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_lcar000a16a_e;

/*
Designated Places
*/

--- 2001 Designated Places;
drop table if exists statcan_dpl_2001;
create table statcan_dpl_2001 as
	select distinct pruid, dpluid, dplname, dpltype, 
		concat('2001A0006', dpluid) as dguid,
		st_union(st_makevalid(geom)) as geom
			from statcan_gdpl000b02m_e_tmp
				group by pruid, dpluid, dplname, dpltype;

create index statcan_dpl_2001_geom_idx on statcan_dpl_2001 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gdpl000b02m_e_tmp;

--- 2006 Designated Places;
drop table if exists statcan_dpl_2006;
create table statcan_dpl_2006 as
	select distinct pruid, csduid, dpluid, dplname, dpltype,
		concat('2006A0006', dpluid) as dguid, geom 
			from statcan_gdpl000a06a_e;
				
create index statcan_dpl_2006_geom_idx on statcan_dpl_2006 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gdpl000a06a_e;

--- 2011 Designated Places;
drop table if exists statcan_dpl_2011;
create table statcan_dpl_2011 as
	select distinct pruid, dpluid, dplname, dpltype,
		concat('2011A0006', dpluid) as dguid, geom 
			from statcan_gdpl000a11a_e;
				
create index statcan_dpl_2011_geom_idx on statcan_dpl_2011 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gdpl000a11a_e;

--- 2016 Designated Places;
drop table if exists statcan_dpl_2016;
create table statcan_dpl_2016 as
	select distinct pruid, dpluid, dplname, dpltype,
		concat('2016A0006', dpluid) as dguid, geom 
			from statcan_ldpl000a16a_e;
				
create index statcan_dpl_2016_geom_idx on statcan_dpl_2016 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_ldpl000a16a_e;

/*
FSA
*/

--- 2011 FSA;
drop table if exists statcan_fsa_2011;
create table statcan_fsa_2011 as
	select distinct pruid, cfsauid, concat('2011A0011', cfsauid) as dguid, geom 
			from statcan_gfsa000a11a_e;
				
create index statcan_fsa_2011_geom_idx on statcan_fsa_2011 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gfsa000a11a_e;

--- 2016 FSA;
drop table if exists statcan_fsa_2016;
create table statcan_fsa_2016 as
	select distinct pruid, cfsauid, concat('2016A0011', cfsauid) as dguid, geom 
			from statcan_lfsa000a16a_e;
				
create index statcan_fsa_2016_geom_idx on statcan_fsa_2016 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_lfsa000a16a_e;

/*
CMA
*/

--- 2001 CMA;
drop table if exists statcan_cma_2001;
create table statcan_cma_2001 as
	select distinct cmauid, concat(pruid, cmauid) as cmapuid, cmaname, cmatype, pruid,
		st_union(geom) as geom
			from statcan_gcma000b02m_e_tmp
				group by cmaname, cmauid, cmatype, pruid;

create index statcan_cma_2001_geom_idx on statcan_cma_2001 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gcma000b02m_e_tmp;

--- 2006 CMA;
drop table if exists statcan_cma_2006;
create table statcan_cma_2006 as
	select cmauid as cmapuid, cmaname, cmatype, pruid, geom
		from statcan_gcma000a06a_e;

create index statcan_cma_2006_geom_idx on statcan_cma_2006 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gcma000a06a_e;

--- 2011 CMA;
drop table if exists statcan_cma_2011;
create table statcan_cma_2011 as
	select cmauid, cmapuid, cmaname, cmatype, pruid, geom
		from statcan_gcma000a11a_e;

create index statcan_cma_2011_geom_idx on statcan_cma_2011 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gcma000a11a_e;

--- 2016 CMA;
drop table if exists statcan_cma_2016;
create table statcan_cma_2016 as
	select cmauid, cmapuid, cmaname, cmatype, pruid, geom
		from statcan_lcma000a16a_e;

create index statcan_cma_2016_geom_idx on statcan_cma_2016 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_lcma000a16a_e;

/*
Population Centres
*/

--- 2011 Population Centres;
drop table if exists statcan_pc_2011;
create table statcan_pc_2011 as
	select distinct pruid, cmapuid, pcuid, pcpuid, pcname, pctype, 
		concat('2011S0510', pcuid) as dguid, geom 
			from statcan_gpc_000a11a_e;
				
create index statcan_pc_2011_geom_idx on statcan_pc_2011 using GIST(geom) with (FILLFACTOR=100);

--- 2016 Population Centres;
drop table if exists statcan_pc_2016;
create table statcan_pc_2016 as
	select distinct pruid, cmapuid, pcuid, pcpuid, pcname, pctype, 
		concat('2016S0510', pcuid) as dguid, geom 
			from statcan_lpc_000a16a_e;
				
create index statcan_pc_2016_geom_idx on statcan_pc_2016 using GIST(geom) with (FILLFACTOR=100);

/*
Population Centres Part
*/

--- 2011 Population Centres Part;
drop table if exists statcan_pc_part_2011;
create table statcan_pc_part_2011 as
	select distinct pruid, cmapuid, pcuid, pcpuid, pcname, pctype, 
		concat('2011S0511', pcpuid) as dguid, geom 
			from statcan_gpc_000a11a_e;
				
create index statcan_pc_part_2011_geom_idx on statcan_pc_part_2011 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gpc_000a11a_e;

--- 2016 Population Centres Part;
drop table if exists statcan_pc_part_2016;
create table statcan_pc_part_2016 as
	select distinct pruid, cmapuid, pcuid, pcpuid, pcname, pctype, 
		concat('2016S0511', pcpuid) as dguid, geom 
			from statcan_lpc_000a16a_e;
				
create index statcan_pc_part_2016_geom_idx on statcan_pc_part_2016 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_lpc_000a16a_e;

/*
Census Tracts
*/
--- 2001 Census Tracts;
drop table if exists statcan_ct_2001;
create table statcan_ct_2001 as
	select distinct pruid, ctuid, ctname, concat(pruid, cmauid) as cmapuid, 
		concat('2001S0507', ctuid) as dguid, st_union(geom) as geom
			from statcan_gct_000b02m_e_tmp
			group by pruid, ctuid, ctname, cmauid;

create index statcan_ct_2001_geom_idx on statcan_ct_2001 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gct_000b02m_e_tmp;

--- 2006 Census Tracts;
drop table if exists statcan_ct_2006;
create table statcan_ct_2006 as
	select distinct pruid, ctuid, concat(pruid, cmauid) as cmapuid,
		concat('2006S0507', ctuid) as dguid, geom 
			from statcan_gct_000a06a_e;
				
create index statcan_ct_2006_geom_idx on statcan_ct_2006 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gct_000a06a_e;

--- 2011 Census Tracts;
drop table if exists statcan_ct_2011;
create table statcan_ct_2011 as
	select distinct pruid, ctuid, ctname, cmapuid,
		concat('2011S0507', ctuid) as dguid, geom 
			from statcan_gct_000a11a_e;
				
create index statcan_ct_2011_geom_idx on statcan_ct_2011 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gct_000a11a_e;

--- 2016 Census Tracts;
drop table if exists statcan_ct_2016;
create table statcan_ct_2016 as
	select distinct pruid, ctuid, ctname, cmapuid,
		concat('2016S0507', ctuid) as dguid, geom 
			from statcan_lct_000a16a_e;
				
create index statcan_ct_2016_geom_idx on statcan_ct_2016 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_lct_000a16a_e;

/*
DA
*/
--- 2001 Dissemination Areas;
drop table if exists statcan_da_2001;
create table statcan_da_2001 as
	select distinct pruid, csduid, concat(pruid, cmauid) as cmapuid, dauid,
		concat('2001S0512', dauid) as dguid,
		st_union(geom) as geom
			from statcan_gda_000b02m_e_tmp
				group by pruid, csduid, cmauid, dauid;

create index statcan_da_2001_geom_idx on statcan_da_2001 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gda_000b02m_e_tmp;

--- 2006 Dissemination Area;
drop table if exists statcan_da_2006;
create table statcan_da_2006 as
	select distinct pruid, cduid, ccsuid, csduid, eruid, concat(pruid, cmauid) as cmapuid, ctuid, dauid,  
		concat('2006S0512', dauid) as dguid, geom 
			from statcan_gda_000a06a_e;
				
create index statcan_da_2006_geom_idx on statcan_da_2006 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gda_000a06a_e;

--- 2011 Dissemination Area;
drop table if exists statcan_da_2011;
create table statcan_da_2011 as
	select distinct pruid, cduid, ccsuid, csduid, eruid, cmapuid, ctuid, dauid,  
		concat('2011S0512', dauid) as dguid, geom 
			from statcan_gda_000a11a_e;
				
create index statcan_da_2011_geom_idx on statcan_da_2011 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gda_000a11a_e;

--- 2016 Dissemination Area;
drop table if exists statcan_da_2016;
create table statcan_da_2016 as
	select distinct pruid, cduid, ccsuid, csduid, eruid, cmapuid, ctuid, adauid, dauid,  
		concat('2016S0512', dauid) as dguid, geom 
			from statcan_lda_000a16a_e;
				
create index statcan_da_2016_geom_idx on statcan_da_2016 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_lda_000a16a_e;

/*
DB
*/

--- 2001 Dissemination Blocks;
drop table if exists statcan_db_2001;
create table statcan_db_2001 as
	select distinct pruid, csduid, concat(pruid, cmauid) as cmapuid, ctname, dauid, blockuid as dbuid,  
		concat('2001S0513', blockuid) as dguid, geom 
			from statcan_gbl_000d02m_e_tmp;
				
create index statcan_db_2001_geom_idx on statcan_db_2001 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gbl_000d02m_e_tmp;

--- 2006 Dissemination Blocks;
drop table if exists statcan_db_2006;
create table statcan_db_2006 as
	select distinct pruid, cduid, ccsuid, csduid, eruid, concat(pruid, cmauid) as cmapuid, ctuid, dauid, dbuid,  
		concat('2006S0513', dbuid) as dguid, geom 
			from statcan_gdb_000a06a_e;
				
create index statcan_db_2006_geom_idx on statcan_db_2006 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gdb_000a06a_e;

--- 2011 Dissemination Blocks;
drop table if exists statcan_db_2011;
create table statcan_db_2011 as
	select distinct pruid, cduid, ccsuid, csduid, eruid, feduid, 
		concat(pruid, cmauid) as cmapuid, ctuid, dauid, dbuid,  
		concat('2011S0513', dbuid) as dguid, geom 
			from statcan_gdb_000a11a_e;
				
create index statcan_db_2011_geom_idx on statcan_db_2011 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_gdb_000a11a_e;

--- 2016 Dissemination Blocks;
drop table if exists statcan_db_2016;
create table statcan_db_2016 as
	select distinct pruid, cduid, ccsuid, csduid, eruid, feduid, cmapuid, ctuid, adauid, dauid, dbuid,   
		concat('2016S0513', dbuid) as dguid, geom 
			from statcan_ldb_000a16a_e;
				
create index statcan_db_2016_geom_idx on statcan_db_2016 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_ldb_000a16a_e;

/*
ADA
*/

-- 2016 Aggregate Dissemination Areas;
drop table if exists statcan_ada_2016;
create table statcan_ada_2016 as
	select distinct pruid, cduid, adauid, 
		concat('2016S0516', adauid) as dguid, geom 
			from statcan_lada000a16a_e;
				
create index statcan_ada_2016_geom_idx on statcan_ada_2016 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_lada000a16a_e;