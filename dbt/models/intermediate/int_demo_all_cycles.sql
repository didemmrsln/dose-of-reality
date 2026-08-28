{{ config(materialized='view') }}

-- 5 cycle'in demografik verilerini birlestirir VE NHANES'in resmi
-- "combining cycles" kuralina gore duzeltilmis agirlik hesaplar.
--
-- Kural (CDC NHANES Tutorials + Analytic Guidelines):
--   combined_weight = (cycle_suresi / toplam_sure) * cycle_kendi_2yillik_agirligi
--
-- Cycle sureleri: 2011-2012=2, 2013-2014=2, 2015-2016=2,
--                 2017-2020=3.2 (pre-pandemic ozel cycle), 2021-2023=2
-- Toplam sure = 11.2 yil

select seqn, age_years, gender_code, gender, ethnicity_code_v1, ethnicity_v1,
       ethnicity_code_v3, ethnicity_v3, interview_weight, exam_weight,
       survey_stratum, survey_psu, income_poverty_ratio, cycle,
       2.0 as cycle_duration_years,
       interview_weight * (2.0 / 11.2) as combined_interview_weight,
       exam_weight * (2.0 / 11.2) as combined_exam_weight
from {{ ref('stg_demo_2011_2012') }}

union all

select seqn, age_years, gender_code, gender, ethnicity_code_v1, ethnicity_v1,
       ethnicity_code_v3, ethnicity_v3, interview_weight, exam_weight,
       survey_stratum, survey_psu, income_poverty_ratio, cycle,
       2.0 as cycle_duration_years,
       interview_weight * (2.0 / 11.2) as combined_interview_weight,
       exam_weight * (2.0 / 11.2) as combined_exam_weight
from {{ ref('stg_demo_2013_2014') }}

union all

select seqn, age_years, gender_code, gender, ethnicity_code_v1, ethnicity_v1,
       ethnicity_code_v3, ethnicity_v3, interview_weight, exam_weight,
       survey_stratum, survey_psu, income_poverty_ratio, cycle,
       2.0 as cycle_duration_years,
       interview_weight * (2.0 / 11.2) as combined_interview_weight,
       exam_weight * (2.0 / 11.2) as combined_exam_weight
from {{ ref('stg_demo_2015_2016') }}

union all

select seqn, age_years, gender_code, gender, ethnicity_code_v1, ethnicity_v1,
       ethnicity_code_v3, ethnicity_v3, interview_weight, exam_weight,
       survey_stratum, survey_psu, income_poverty_ratio, cycle,
       3.2 as cycle_duration_years,
       interview_weight * (3.2 / 11.2) as combined_interview_weight,
       exam_weight * (3.2 / 11.2) as combined_exam_weight
from {{ ref('stg_demo_2017_2020') }}

union all

select seqn, age_years, gender_code, gender, ethnicity_code_v1, ethnicity_v1,
       ethnicity_code_v3, ethnicity_v3, interview_weight, exam_weight,
       survey_stratum, survey_psu, income_poverty_ratio, '2021-2023' as cycle,
       2.0 as cycle_duration_years,
       interview_weight * (2.0 / 11.2) as combined_interview_weight,
       exam_weight * (2.0 / 11.2) as combined_exam_weight
from {{ ref('stg_demo_l') }}
