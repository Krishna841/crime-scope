CREATE TABLE crime_data (
    cmplnt_num TEXT PRIMARY KEY,
    cmplnt_fr_dt TIMESTAMP,
    cmplnt_fr_tm TEXT,
    cmplnt_to_dt TIMESTAMP,
    cmplnt_to_tm TEXT,
    addr_pct_cd INTEGER,
    rpt_dt TIMESTAMP,
    ky_cd INTEGER,
    ofns_desc TEXT,
    pd_cd INTEGER,
    pd_desc TEXT,
    crm_atpt_cptd_cd TEXT,
    law_cat_cd TEXT,
    boro_nm TEXT,
    loc_of_occur_desc TEXT,
    prem_typ_desc TEXT,
    juris_desc TEXT,
    jurisdiction_code INTEGER,
    parks_nm TEXT,
    hadevelopt TEXT,
    housing_psa TEXT,
    x_coord_cd INTEGER,
    y_coord_cd INTEGER,
    susp_age_group TEXT,
    susp_race TEXT,
    susp_sex TEXT,
    transit_district INTEGER,
    latitude FLOAT,
    longitude FLOAT,
    lat_lon TEXT,
    patrol_boro TEXT,
    station_name TEXT,
    vic_age_group TEXT,
    vic_race TEXT,
    vic_sex TEXT
);

--Copy the data from csv
\copy crime_data from 'C:/Users/goswa/Desktop/data analytics/nyc_crime/NYPD_Complaint_Data_Historic_20250423.csv' delimiter ',' csv header;

-- EDA:
-- Number of rows: 9491799
select count(*) from cleaned_crime_data;

-- Number of columns and their types
select column_name, data_type
from information_schema.columns
where table_name = 'crime_data';


-- Preview sample data
select * from crime_cleaned_view limit 10;

--  Missing or Null Values: Know which columns have the most nulls and whether they’re important
select 
  count(*) as total_rows,
  count(*) - count(cmplnt_num) as missing_cmplnt_num,
  count(*) - count(cmplnt_fr_dt) as missing_cmplnt_fr_dt,
  count(*) - count(cmplnt_to_dt) as missing_cmplnt_to_dt,
  count(*) - count(ofns_desc) as missing_ofns_desc,
  count(*) - count(boro_nm) as missing_boro_nm
from crime_data;

-- Fix some null values
Delete null records
delete from crime_data where cmplnt_to_dt is null or cmplnt_fr_dt is null;

-- Create cleaner view removing null date values
create view cleaned_crime_data as
select *, 
       coalesce(cmplnt_to_dt, cmplnt_fr_dt) as fixed_to_dt
from crime_data;


-- Time Based Analysis:
-- the crime had gone down significantly from 2017 to 2022 when the spike started again 2024 had highest crimes
with crime_by_year as (select extract(year from cmplnt_fr_dt) as crime_year from crime_data )
select crime_year, count(*) as total_crimes from crime_by_year group by crime_year;

select *
from crime_data
where extract(year from cmplnt_to_dt) between 1000 and 1099
   and extract(year from cmplnt_fr_dt) between 1000 and 1099;

update crime_data
set cmplnt_to_dt = 
  case 
    when extract(year from cmplnt_to_dt) between 1010 and 1099 
    then cmplnt_to_dt + 
         (make_interval;(years => 2020 - extract(year from cmplnt_to_dt)::int))
    else cmplnt_to_dt
  end;

update crime_data
set cmplnt_to_dt = 
  case 
    when extract(year from cmplnt_to_dt) between 1010 and 1099 
    then cmplnt_to_dt + 
         (make_interval;(years => 2020 - extract(year from cmplnt_to_dt)::int))
    else cmplnt_to_dt
  end;

-- Count crimes by month name
with crime_by_month as (select to_char(cmplnt_fr_dt, 'Month') as crime_month from crime_data )
select crime_month, count(*) as total_crimes from crime_by_month group by crime_month order by total_crimes desc;

-- What time of day do most crimes happen?
check if time is in 24 hours format
with crime_by_hour as
(select
 case 
 	 when cmplnt_fr_tm is not null and cmplnt_fr_tm ~'\d{1,2}:\d{2}'
	  then cast(split_part(cmplnt_fr_tm, ':', 1) as integer) 
	  else null
	  end as crime_hour
	  from crime_data
)
select crime_hour, count(*) as crime_rate from crime_by_hour group by crime_hour order by crime_rate desc;


-- Geographical or Location-Based Analysis: Spot boroughs and premises with most incidents.
select boro_nm, count(*) as crimes from cleaned_crime_data group by boro_nm order by crimes desc;
select prem_typ_desc, count(*) as crimes from cleaned_crime_data group by prem_typ_desc order by crimes desc;

-- For each borough, what are the top 3 most common types of crime?
with crime_rank as (select boro_nm, ofns_desc, count(*) as crime_count,

-- row_number() over(partition by boro_nm order by count(*) desc) as rn from crime_data group by boro_nm, ofns_desc)
select boro_nm, ofns_desc, crime_count from crime_rank where rn<=3;


-- Crime Type Analysis: What kinds of crimes are most frequent?
select ofns_desc, count(*) as crime_count from cleaned_crime_data group by ofns_desc order by crime_count desc;

-- What percentage of crimes are completed vs attempted?
select crm_atpt_cptd_cd, round(count(*)/sum(count(*)) over(), 2) as crimes_completed from crime_data group by crm_atpt_cptd_cd order by crimes_completed desc;

