{{ config(materialized='table') }}

-- Dashboard: cakisma / asim / asim kaynagi
-- cycle x ingredient x cinsiyet x yas x etnik koken kirilimli

with overlap_flag as (
    select
        cycle, seqn, ingredient_name,
        count(distinct dspi_product_id) > 1 as has_overlap
    from {{ ref('int_supplement_ingredients_all_cycles') }}
    where ingredient_name in ('VITAMIN D', 'IRON', 'MAGNESIUM', 'NIACIN', 'ZINC', 'VITAMIN A')
    group by cycle, seqn, ingredient_name
),

exceeds_flag as (
    select
        seqn, cycle, ingredient_name, has_ul_defined,
        sum(case when unit_convertible then quantity_mcg else 0 end) as total_quantity_mcg,
        any_value(ul_value_mcg) as ul_value_mcg
    from {{ ref('int_ingredients_with_ul_all_cycles') }}
    where ingredient_name in ('VITAMIN D', 'IRON', 'MAGNESIUM', 'NIACIN', 'ZINC', 'VITAMIN A')
    group by seqn, cycle, ingredient_name, has_ul_defined
),

combined as (
    select
        o.cycle, o.seqn, o.ingredient_name, o.has_overlap,
        case
            when e.has_ul_defined and e.total_quantity_mcg > e.ul_value_mcg then true
            when e.has_ul_defined then false
            else null
        end as exceeds_ul,
        d.gender,
        case
            when d.age_years < 18 then '0-17'
            when d.age_years < 35 then '18-34'
            when d.age_years < 50 then '35-49'
            when d.age_years < 65 then '50-64'
            else '65+'
        end as age_group,
        d.ethnicity_v1,
        d.interview_weight
    from overlap_flag o
    left join exceeds_flag e
        on o.cycle = e.cycle and o.seqn = e.seqn and o.ingredient_name = e.ingredient_name
    left join {{ ref('int_demo_all_cycles') }} d
        on o.cycle = d.cycle and o.seqn = d.seqn
    where e.has_ul_defined
)

select
    cycle,
    ingredient_name,
    gender,
    age_group,
    ethnicity_v1,

    count(*) as n_kisi,
    countif(has_overlap) as n_cakisma,
    countif(exceeds_ul) as n_asim,
    countif(has_overlap and exceeds_ul) as n_cakismali_asim,
    countif(not has_overlap and exceeds_ul) as n_tek_urun_asim,

    round(sum(case when has_overlap then interview_weight else 0 end) / sum(interview_weight) * 100, 1) as cakisma_yuzdesi,
    round(sum(case when exceeds_ul then interview_weight else 0 end) / sum(interview_weight) * 100, 1) as asim_yuzdesi,
    round(sum(case when has_overlap and exceeds_ul then interview_weight else 0 end) / sum(interview_weight) * 100, 1) as cakismali_asim_yuzdesi,
    round(sum(case when not has_overlap and exceeds_ul then interview_weight else 0 end) / sum(interview_weight) * 100, 1) as tek_urun_asim_yuzdesi

from combined
group by cycle, ingredient_name, gender, age_group, ethnicity_v1
