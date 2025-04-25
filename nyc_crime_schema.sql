-- CREATE TABLE crime_data (
--     cmplnt_num TEXT PRIMARY KEY,
--     cmplnt_fr_dt TIMESTAMP,
--     cmplnt_fr_tm TEXT,
--     cmplnt_to_dt TIMESTAMP,
--     cmplnt_to_tm TEXT,
--     addr_pct_cd INTEGER,
--     rpt_dt TIMESTAMP,
--     ky_cd INTEGER,
--     ofns_desc TEXT,
--     pd_cd INTEGER,
--     pd_desc TEXT,
--     crm_atpt_cptd_cd TEXT,
--     law_cat_cd TEXT,
--     boro_nm TEXT,
--     loc_of_occur_desc TEXT,
--     prem_typ_desc TEXT,
--     juris_desc TEXT,
--     jurisdiction_code INTEGER,
--     parks_nm TEXT,
--     hadevelopt TEXT,
--     housing_psa TEXT,
--     x_coord_cd INTEGER,
--     y_coord_cd INTEGER,
--     susp_age_group TEXT,
--     susp_race TEXT,
--     susp_sex TEXT,
--     transit_district INTEGER,
--     latitude FLOAT,
--     longitude FLOAT,
--     lat_lon TEXT,
--     patrol_boro TEXT,
--     station_name TEXT,
--     vic_age_group TEXT,
--     vic_race TEXT,
--     vic_sex TEXT
-- );

-- with crime_by_year as (select extract(year from cmplnt_fr_dt) as crime_year from crime_data )
-- select crime_year, count(*) as total_crimes from crime_by_year group by crime_year;

-- SELECT *
-- FROM crime_data
-- WHERE EXTRACT(YEAR FROM cmplnt_to_dt) BETWEEN 1000 AND 1099
--    AND EXTRACT(YEAR FROM cmplnt_fr_dt) BETWEEN 1000 AND 1099;

-- the crime had gone down significantly from 2017 to 2022 when the spike started again 2024 had highest crimes

-- UPDATE crime_data
-- SET cmplnt_to_dt = 
--   CASE 
--     WHEN EXTRACT(YEAR FROM cmplnt_to_dt) BETWEEN 1010 AND 1099 
--     THEN cmplnt_to_dt + 
--          (MAKE_INTERVAL(years => 2020 - EXTRACT(YEAR FROM cmplnt_to_dt)::INT))
--     ELSE cmplnt_to_dt
--   END;

-- UPDATE crime_data
-- SET cmplnt_fr_dt = 
--   CASE 
--     WHEN EXTRACT(YEAR FROM cmplnt_fr_dt) BETWEEN 1010 AND 1099 
--     THEN cmplnt_fr_dt + 
--          (MAKE_INTERVAL(years => 2020 - EXTRACT(YEAR FROM cmplnt_fr_dt)::INT))
--     ELSE cmplnt_fr_dt
--   END;

-- Count crimes by month name
-- with crime_by_month as (select to_char(cmplnt_fr_dt, 'Month') as crime_month from crime_data )
-- select crime_month, count(*) as total_crimes from crime_by_month group by crime_month order by total_crimes desc;

-- What time of day do most crimes happen?
-- check if time is in 24 hours format
-- with crime_by_hour as
-- (select
--  case 
--  	 when cmplnt_fr_tm is not null and cmplnt_fr_tm ~'\d{1,2}:\d{2}'
-- 	  then cast(split_part(cmplnt_fr_tm, ':', 1) as integer) 
-- 	  else null
-- 	  end as crime_hour
-- 	  from crime_data
-- )
-- select crime_hour, count(*) as crime_rate from crime_by_hour group by crime_hour order by crime_rate desc;


-- What percentage of crimes are completed vs attempted?
-- select crm_atpt_cptd_cd, round(count(*)/sum(count(*)) over(), 2) as crimes_completed from crime_data group by crm_atpt_cptd_cd order by crimes_completed desc;

-- For each borough, what are the top 3 most common types of crime?
-- with crime_rank as (select boro_nm, ofns_desc, count(*) as crime_count,
-- row_number() over(partition by boro_nm order by count(*) desc) as rn from crime_data group by boro_nm, ofns_desc)
-- select boro_nm, ofns_desc, crime_count from crime_rank where rn<=3;
