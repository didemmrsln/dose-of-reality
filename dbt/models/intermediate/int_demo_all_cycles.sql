{{ config(materialized='view') }}

-- TUM 10 cycle blogunun demografik verilerini birlestirir.
-- Toplam sure = 23.2 yil (1999-2002=4, 2003-2004=2, 2005-2006=2,
-- 2007-2008=2, 2009-2010=2, 2011-2012=2, 2013-2014=2, 2015-2016=2,
-- 2017-2020=3.2, 2021-2023=2)
--
-- NOT: 1999-2002 icin interview_weight zaten WTINT4YR (CDC'nin resmi
-- olarak bu iki 2-yillik cycle'i birlestirmek icin urettigi ozel agirlik)
-- - bu yuzden 1999-2000 ve 2001-2002 satirlarinin agirliklari dogrudan
-- toplanabilir, ekstra bir birlestirme islemi gerekmez.

select seqn, age_years, gender_code, gender, ethnicity_code_v1, ethnicity_v1,
       ethnicity_code_v3, ethnicity_v3, interview_weight, exam_weight,
       survey_stratum, survey_psu, income_poverty_ratio, cycle,
       4.0 as cycle_duration_years,
       interview_weight * (4.0 / 23.2) as combined_interview_weight,
       exam_weight * (4.0 / 23.2) as combined_exam_weight
from {{ ref('stg_demo_1999_2000') }}

union all

select seqn, age_years, gender_code, gender, ethnicity_code_v1, ethnicity_v1,
       ethnicity_code_v3, ethnicity_v3, interview_weight, exam_weight,
       survey_stratum, survey_psu, income_poverty_ratio, cycle,
       4.0 as cycle_duration_years,
       interview_weight * (4.0 / 23.2) as combined_interview_weight,
       exam_weight * (4.0 / 23.2) as combined_exam_weight
from {{ ref('stg_demo_2001_2002') }}

union all

select seqn, age_years, gender_code, gender, ethnicity_code_v1, ethnicity_v1,
       ethnicity_code_v3, ethnicity_v3, interview_weight, exam_weight,
       survey_stratum, survey_psu, income_poverty_ratio, cycle,
       2.0 as cycle_duration_years,
       interview_weight * (2.0 / 23.2) as combined_interview_weight,
       exam_weight * (2.0 / 23.2) as combined_exam_weight
from {{ ref('stg_demo_2003_2004') }}

union all

select seqn, age_years, gender_code, gender, ethnicity_code_v1, ethnicity_v1,
       ethnicity_code_v3, ethnicity_v3, interview_weight, exam_weight,
       survey_stratum, survey_psu, income_poverty_ratio, cycle,
       2.0 as cycle_duration_years,
       interview_weight * (2.0 / 23.2) as combined_interview_weight,
       exam_weight * (2.0 / 23.2) as combined_exam_weight
from {{ ref('stg_demo_2005_2006') }}

union all

select seqn, age_years, gender_code, gender, ethnicity_code_v1, ethnicity_v1,
       ethnicity_code_v3, ethnicity_v3, interview_weight, exam_weight,
       survey_stratum, survey_psu, income_poverty_ratio, cycle,
       2.0 as cycle_duration_years,
       interview_weight * (2.0 / 23.2) as combined_interview_weight,
       exam_weight * (2.0 / 23.2) as combined_exam_weight
from {{ ref('stg_demo_2007_2008') }}

union all

select seqn, age_years, gender_code, gender, ethnicity_code_v1, ethnicity_v1,
       ethnicity_code_v3, ethnicity_v3, interview_weight, exam_weight,
       survey_stratum, survey_psu, income_poverty_ratio, cycle,
       2.0 as cycle_duration_years,
       interview_weight * (2.0 / 23.2) as combined_interview_weight,
       exam_weight * (2.0 / 23.2) as combined_exam_weight
from {{ ref('stg_demo_2009_2010') }}

union all

select seqn, age_years, gender_code, gender, ethnicity_code_v1, ethnicity_v1,
       ethnicity_code_v3, ethnicity_v3, interview_weight, exam_weight,
       survey_stratum, survey_psu, income_poverty_ratio, cycle,
       2.0 as cycle_duration_years,
       interview_weight * (2.0 / 23.2) as combined_interview_weight,
       exam_weight * (2.0 / 23.2) as combined_exam_weight
from {{ ref('stg_demo_2011_2012') }}

union all

select seqn, age_years, gender_code, gender, ethnicity_code_v1, ethnicity_v1,
       ethnicity_code_v3, ethnicity_v3, interview_weight, exam_weight,
       survey_stratum, survey_psu, income_poverty_ratio, cycle,
       2.0 as cycle_duration_years,
       interview_weight * (2.0 / 23.2) as combined_interview_weight,
       exam_weight * (2.0 / 23.2) as combined_exam_weight
from {{ ref('stg_demo_2013_2014') }}

union all

select seqn, age_years, gender_code, gender, ethnicity_code_v1, ethnicity_v1,
       ethnicity_code_v3, ethnicity_v3, interview_weight, exam_weight,
       survey_stratum, survey_psu, income_poverty_ratio, cycle,
       2.0 as cycle_duration_years,
       interview_weight * (2.0 / 23.2) as combined_interview_weight,
       exam_weight * (2.0 / 23.2) as combined_exam_weight
from {{ ref('stg_demo_2015_2016') }}

union all

select seqn, age_years, gender_code, gender, ethnicity_code_v1, ethnicity_v1,
       ethnicity_code_v3, ethnicity_v3, interview_weight, exam_weight,
       survey_stratum, survey_psu, income_poverty_ratio, cycle,
       3.2 as cycle_duration_years,
       interview_weight * (3.2 / 23.2) as combined_interview_weight,
       exam_weight * (3.2 / 23.2) as combined_exam_weight
from {{ ref('stg_demo_2017_2020') }}

union all

select seqn, age_years, gender_code, gender, ethnicity_code_v1, ethnicity_v1,
       ethnicity_code_v3, ethnicity_v3, interview_weight, exam_weight,
       survey_stratum, survey_psu, income_poverty_ratio, '2021-2023' as cycle,
       2.0 as cycle_duration_years,
       interview_weight * (2.0 / 23.2) as combined_interview_weight,
       exam_weight * (2.0 / 23.2) as combined_exam_weight
from {{ ref('stg_demo_l') }}
