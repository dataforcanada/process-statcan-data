-- TODO
-- 2022 Health Regions;
drop table if exists statcan_hr_2022;
create table statcan_hr_2022 as
	select hr_uid, engname, frename, dguid, wkb_geometry as geom
		from statcan_hr2023001_tmp;

create index statcan_hr_2022_geom_idx on statcan_hr_2022 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_hr2023001_tmp;

-- 2018 Health Regions;
drop table if exists statcan_hr_2018;
create table statcan_hr_2018 as
	select hr_uid, engname, frename, concat('2018A007', hr_uid) as dguid, wkb_geometry as geom
		from statcan_hr2018001_tmp;

create index statcan_hr_2018_geom_idx on statcan_hr_2018 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_hr2018001_tmp;

-- 2017 Health Regions;
drop table if exists statcan_hr_2017;
create table statcan_hr_2017 as
	select hr_uid, eng_label as engname, fre_label as frename, concat('2017A007', hr_uid) as dguid, wkb_geometry as geom
		from statcan_hr2017001_tmp;

create index statcan_hr_2017_geom_idx on statcan_hr_2017 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_hr2017001_tmp;

-- 2015 Health Regions;
drop table if exists statcan_hr_2015;
create table statcan_hr_2015 as
	select hr_uid, eng_label as engname, fre_label as frename, concat('2015A007', hr_uid) as dguid, wkb_geometry as geom
		from statcan_hr2015002_tmp;

create index statcan_hr_2015_geom_idx on statcan_hr_2015 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_hr2015002_tmp;

-- 2013 Health Regions;
drop table if exists statcan_hr_2013;
create table statcan_hr_2013 as
	select hr_uid, eng_label as engname, fre_label as frename, concat('2013A007', hr_uid) as dguid, wkb_geometry as geom
		from statcan_hr2013003_tmp;

create index statcan_hr_2013_geom_idx on statcan_hr_2013 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_hr2013003_tmp;
drop table if exists statcan_hr2013002_tmp;
drop table if exists statcan_hr2013001_tmp;

-- 2011 Health Regions;
drop table if exists statcan_hr_2011;
create table statcan_hr_2011 as
	select pr_hruid as hr_uid, eng_label as engname, fre_label as frename, concat('2011A007', pr_hruid) as dguid, wkb_geometry as geom
		from statcan_hr2011001_tmp;

create index statcan_hr_2011_geom_idx on statcan_hr_2011 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_hr2011001_tmp;

-- 2009 Health Regions;
drop table if exists statcan_hr_2009;
create table statcan_hr_2009 as
	select hruid2007 as hr_uid, eng_label as engname, fre_label as frename, concat('2009A007', hruid2007) as dguid, wkb_geometry as geom
		from statcan_hr2009001_tmp;

create index statcan_hr_2009_geom_idx on statcan_hr_2009 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_hr2009001_tmp;

-- 2007 Health Regions;
drop table if exists statcan_hr_2007;
create table statcan_hr_2007 as
	select distinct pr_hruid as hr_uid, hrname as engname, frname as frename, concat('2007A007', pr_hruid) as dguid, wkb_geometry as geom
		from statcan_hr2007001_tmp;

update statcan_hr_2007
	set frename = engname
		where frename is null;

create index statcan_hr_2007_geom_idx on statcan_hr_2007 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_hr2007001_tmp;

-- 2006 Health Regions;
drop table if exists statcan_hr_2006;
create table statcan_hr_2006 as
	select distinct pr_hruid as hr_uid, hrname as engname, frname as frename, concat('2006A007', pr_hruid) as dguid, st_union(wkb_geometry) as geom
		from statcan_hr2006001_tmp
		group by pr_hruid, hrname, frname;

update statcan_hr_2006
	set frename = engname
		where frename is null;

create index statcan_hr_2006_geom_idx on statcan_hr_2006 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_hr2006001_tmp;

-- 2005 Health Regions;
drop table if exists statcan_hr_2005;
create table statcan_hr_2005 as
	select distinct pr_hruid as hr_uid, hrname as engname, frname as frename, concat('2005A007', pr_hruid) as dguid, st_union(wkb_geometry) as geom
		from statcan_hr2005001_tmp
		group by pr_hruid, hrname, frname;

update statcan_hr_2005
	set frename = engname
		where frename is null;

create index statcan_hr_2005_geom_idx on statcan_hr_2005 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_hr2005001_tmp;

-- 2004 Health Regions;
drop table if exists statcan_hr_2004;
create table statcan_hr_2004 as
	select distinct pr_hruid as hr_uid, hrname as engname, concat('2004A007', pr_hruid) as dguid, st_union(wkb_geometry) as geom
		from statcan_hr2004001_tmp
		group by pr_hruid, hrname;

create index statcan_hr_2004_geom_idx on statcan_hr_2004 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_hr2004001_tmp;

-- 2003 Health Regions;
drop table if exists statcan_hr_2003;
create table statcan_hr_2003 as
	select distinct pr_hruid as hr_uid, hrname as engname, concat('2003A007', pr_hruid) as dguid, st_union(wkb_geometry) as geom
		from statcan_hr2003001_tmp
		group by pr_hruid, hrname;

create index statcan_hr_2003_geom_idx on statcan_hr_2003 using GIST(geom) with (FILLFACTOR=100);
drop table if exists statcan_hr2003001_tmp;