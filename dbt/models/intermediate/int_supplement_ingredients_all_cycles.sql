{{ config(materialized='view') }}

-- 5 cycle'in supplement kullanimini, ortak dspi_product_id uzerinden
-- DSII'ye (Vitamin+Mineral filtreli) baglar. Bu, tek-cycle icin daha once
-- kurulan int_supplement_ingredients modelinin COK-CYCLE versiyonudur.

select
    i.seqn,
    i.cycle,
    i.raw_product_id,
    i.product_name,
    i.days_used_30d,
    i.dspi_product_id,

    d.age_years,
    d.gender,
    d.ethnicity_v1,
    d.ethnicity_v3,
    d.combined_interview_weight,

    dsii.ingredient_name,
    dsii.ingredient_std_id,
    dsii.quantity,
    dsii.unit_code,
    dsii.category,
    dsii.is_blend

from {{ ref('int_dsqids_all_cycles') }} as i

left join {{ ref('int_demo_all_cycles') }} as d
    on i.seqn = d.seqn and i.cycle = d.cycle

left join {{ ref('stg_dsii') }} as dsii
    on i.dspi_product_id = dsii.product_id

where dsii.ingredient_name is not null
