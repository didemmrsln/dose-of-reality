{{ config(materialized='view') }}

select
    SEQN as seqn,
    RIDAGEYR as age_years,
    RIAGENDR as gender_code,
    case RIAGENDR when 1 then 'Male' when 2 then 'Female' end as gender,
    RIDRETH1 as ethnicity_code_v1,
    case RIDRETH1
        when 1 then 'Mexican American' when 2 then 'Other Hispanic'
        when 3 then 'Non-Hispanic White' when 4 then 'Non-Hispanic Black'
        when 5 then 'Other Race (incl. Multiracial)'
    end as ethnicity_v1,
    cast(null as int64) as ethnicity_code_v3,
    cast(null as string) as ethnicity_v3,
    WTINT4YR as interview_weight,
    WTMEC2YR as exam_weight,
    SDMVSTRA as survey_stratum,
    SDMVPSU as survey_psu,
    INDFMPIR as income_poverty_ratio,
    '1999-2002' as cycle
from {{ source('nhanes_raw', 'demo_1999_2000') }}
