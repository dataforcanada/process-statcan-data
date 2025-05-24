/* Open Databases */

/* Open Database of Greenhouses */
drop table if exists statcan_odg_2023;
create table statcan_odg_2023 as
select b.dguid as prdguid, b.prename as provincenameenglish, a.imagedate, a.datasource as provider, wkb_geometry as geom
from statcan_odg_tmp as a,
  	 statcan_pr_2021 as b
  	 where st_intersects(a.wkb_geometry, b.geom);
  	 
create index statcan_odg_2023_geom_idx on statcan_odg_2023 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_odg_tmp;

/* Open Database of Buildings */
create table statcan_odb_2019 as
select b.dguid as csddguid, b.csdname, a.data_prov as data_provider, a.build_id, a.wkb_geometry as geom
from statcan_odb_tmp as a,
	 statcan_csd_2021 as b
	 where st_intersects(a.wkb_geometry, b.geom);

create index statcan_odb_2019_geom_idx on statcan_odb_2019 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_odb_tmp;

/* Open Database of Educational Facilities */
drop table if exists statcan_odef_2022;
create table statcan_odef_2022 as
select index, source_id, facility_name, facility_type, authority_name, isced010, isced020, isced1, isced2, isced3, isced4plus, olms_status, unit, street_no, street_name, city, prov_terr,
	postal_code, a.pruid, csdname, csduid, geo_source, provider, cmaname, cmauid, wkb_geometry as geom
from statcan_odef_tmp as a,
  	 statcan_pr_2021 as b
  	 where st_intersects(a.wkb_geometry, b.geom);
  	 
create index statcan_odef_2022_geom_idx on statcan_odef_2022 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_odef_tmp;

/* Open Database of Healthcare Facilities */
drop table if exists statcan_odhf_2020;
create table statcan_odhf_2020 as
select index, facility_name, source_facility_type, odhf_facility_type, provider, unit, street_no, street_name, postal_code,
	b.dguid as csddguid, b.csdname, c.dguid as prdguid, c.prename, a.wkb_geometry as geom
from statcan_odhf_tmp as a,
	 statcan_csd_2021 as b,
	 statcan_pr_2021 as c
where a.wkb_geometry is not null
	and st_intersects(a.wkb_geometry, b.geom)
	and st_intersects(a.wkb_geometry, c.geom);
	
create index statcan_odhf_2020_geom_idx on statcan_odhf_2020 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_odhf_tmp;

/* Open Database of Cultural and Art Facilities */
drop table if exists statcan_odcaf_2020;
create table statcan_odcaf_2020 as
select index, facility_name, source_facility_type, odcaf_facility_type, provider, unit, street_no,
	street_name, postal_code, city, prov_terr, csd_name, csduid, pruid, wkb_geometry as geom
	from statcan_odcaf_tmp;

create index statcan_odcaf_2020_geom_idx on statcan_odcaf_2020 using GIST(geom) with (FILLFACTOR=100);

update statcan_odcaf_2020
	set facility_name = ''
		where facility_name = '..';
update statcan_odcaf_2020
	set source_facility_type  = ''
		where source_facility_type = '..';
update statcan_odcaf_2020
	set unit  = ''
		where unit = '..';
update statcan_odcaf_2020
	set street_no  = ''
		where street_no = '..';
update statcan_odcaf_2020
	set street_name  = ''
		where street_name = '..';
update statcan_odcaf_2020
	set postal_code  = ''
		where postal_code  = '..';
update statcan_odcaf_2020
	set city  = ''
		where city  = '..';
update statcan_odcaf_2020
	set city  = ''
		where city  = '..';
update statcan_odcaf_2020
	set prov_terr  = ''
		where prov_terr  = '..';
update statcan_odcaf_2020
	set csd_name  = ''
		where csd_name  = '..';
update statcan_odcaf_2020
	set csduid  = ''
		where csduid  = '..';
update statcan_odcaf_2020
	set pruid  = ''
		where pruid  = '..';

drop table if exists statcan_odcaf_tmp;

/* Open Database of Addresses */
create table statcan_oda_2021 as
select a.id, a.street_no, a.street, a.unit, a.postal_code, b.dguid as csddguid, b.csdname, c.dguid as prdguid, a.provider, wkb_geometry as geom
from statcan_oda_tmp as a,
	 statcan_csd_2021 as b,
	 statcan_pr_2021 as c
	 where st_intersects(a.wkb_geometry, b.geom)
	 and b.pruid = c.pruid;

create index statcan_oda_2021_geom_idx on statcan_oda_2021 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_oda_tmp;

/* Open Database of Recreational and Sport Facilities */
-- TODO;