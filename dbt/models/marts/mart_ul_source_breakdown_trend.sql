{{ config(materialized='table') }}

with overlap_flag as (
    select
        cycle, seqn, ingredient_name, category,
        count(distinct dspi_product_id) > 1 as has_overlap
    from {{ ref('int_supplement_ingredients_all_cycles') }}
    group by cycle, seqn, ingredient_name, category
),

exceeds_flag as (
    select
        cycle, seqn, ingredient_name, category, has_ul_defined,
        sum(case when unit_convertible then quantity_mcg else 0 end) as total_quantity_mcg,
        any_value(ul_value_mcg) as ul_value_mcg
    from {{ ref('int_ingredients_with_ul_all_cycles') }}
    group by cycle, seqn, ingredient_name, category, has_ul_defined
),

combined as (
    select
        o.cycle,
        o.seqn,
        o.ingredient_name,
        o.category,
        o.has_overlap,
        e.has_ul_defined,
        case
            when e.has_ul_defined and e.total_quantity_mcg > e.ul_value_mcg then true
            when e.has_ul_defined then false
            else null
        end as exceeds_ul,
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

    count(*) as toplam_kisi,

    countif(has_overlap and exceeds_ul) as hem_cakisma_hem_asim_kisi,
    countif(not has_overlap and exceeds_ul) as sadece_asim_kisi,

    round(
        sum(case when has_overlap and exceeds_ul then interview_weight else 0 end)
        / sum(interview_weight) * 100, 1
    ) as cakismali_asim_yuzdesi_agirlikli,

    round(
        sum(case when not has_overlap and exceeds_ul then interview_weight else 0 end)
        / sum(interview_weight) * 100, 1
    ) as tek_urun_asim_yuzdesi_agirlikli

from combined
group by cycle, ingredient_name
