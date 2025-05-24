/* Road Network */

--- 2016 Road Network;
drop table if exists statcan_rn_2016;
create table statcan_rn_2016 as
	select ngduid as ngd_uid, "name", type, dir, afl_val, atl_val, afr_val, atr_val,
	csduid_l, csduid_r, concat(pruid_l, cmauid_l) as cmapuid_l, concat(pruid_r, cmauid_r) as cmapuid_r, pruid_l, pruid_r, rank, class, geom
		from statcan_lrnf000r16a_e;
		
create index statcan_rn_2016_geom_idx on statcan_rn_2016 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_lrnf000r16a_e;

--- 2011 Road Network;
drop table if exists statcan_rn_2011;
create table statcan_rn_2011 as
	select ngd_uid, "name", type, dir, afl_val, atl_val, afr_val, atr_val,
	csduid_l, csduid_r, concat(pruid_l, cmauid_l) as cmapuid_l, concat(pruid_r, cmauid_r) as cmapuid_r, pruid_l, pruid_r, rank, class, geom
		from statcan_grnf000r11a_e;
		
create index statcan_rn_2011_geom_idx on statcan_rn_2011 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_grnf000r11a_e;

--- 2006 Road Network;
drop table if exists statcan_rn_2006;
create table statcan_rn_2006 as
	select rb_uid, "name", type, direction as dir, addr_fm_le as afl_val, addr_to_le as atl_val, addr_fm_rg as afr_val, addr_to_rg as atr_val,
		geom
		from statcan_grnf000r06a_e;
		
create index statcan_rn_2006_geom_idx on statcan_rn_2006 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_grnf000r06a_e;

--- TODO;
--- 2001 Road Network;
create table statcan_rn_2001_tmp as
select arc_id, "name", type, direction as dir, addr_fm_left as afl_val,
	addr_to_left as atl_val, addr_fm_rght as afr_val, addr_to_rght as atr_val,
	geom
from statcan_grnf000r02ml_e_tmp
where class = 'U'








