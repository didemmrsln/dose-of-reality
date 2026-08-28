{{ config(materialized='view') }}

-- NOT: Bu cycle "pre-pandemic" ozel birlesik agirlik kullaniyor:
-- WTINTPRP / WTMECPRP (WTINT2YR / WTMEC2YR DEGIL)

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
    RIDRETH3 as ethnicity_code_v3,
    case RIDRETH3
        when 1 then 'Mexican American' when 2 then 'Other Hispanic'
        when 3 then 'Non-Hispanic White' when 4 then 'Non-Hispanic Black'
        when 6 then 'Non-Hispanic Asian' when 7 then 'Other/Multiracial'
    end as ethnicity_v3,
    WTINTPRP as interview_weight,
    WTMECPRP as exam_weight,
    SDMVSTRA as survey_stratum,
    SDMVPSU as survey_psu,
    INDFMPIR as income_poverty_ratio,
    '2017-2020' as cycle
from {{ source('nhanes_raw', 'demo_2017_2020') }}
