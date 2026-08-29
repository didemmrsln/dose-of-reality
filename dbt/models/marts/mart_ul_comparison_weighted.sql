{{ config(materialized='table') }}

-- Kisi + ingredient bazinda UL asimi, hem HAM hem AGIRLIKLI (interview_weight)

with base as (
    select
        seqn,
        ingredient_name,
        category,
        ul_value_mcg,
        has_ul_defined,
        unit_convertible,
        quantity_mcg
    from {{ ref('int_ingredients_with_ul') }}
),

aggregated as (
    select
        seqn,
        ingredient_name,
        category,
        ul_value_mcg,
        has_ul_defined,
        sum(case when unit_convertible then quantity_mcg else 0 end) as total_quantity_mcg
    from base
    group by seqn, ingredient_name, category, ul_value_mcg, has_ul_defined
),

with_exceeds as (
    select
        a.*,
        demo.interview_weight,
        case
            when has_ul_defined and total_quantity_mcg > ul_value_mcg then true
            when has_ul_defined then false
            else null
        end as exceeds_ul
    from aggregated a
    left join {{ ref('stg_demo_l') }} demo on a.seqn = demo.seqn
)

select
    ingredient_name,
    category,

    count(*) as toplam_kisi_ham,
    countif(exceeds_ul) as asim_sayisi_ham,
    round(countif(exceeds_ul) / count(*) * 100, 1) as asim_yuzdesi_ham,

    sum(interview_weight) as toplam_agirlik,
    sum(case when exceeds_ul then interview_weight else 0 end) as asim_agirlik,
    round(
        sum(case when exceeds_ul then interview_weight else 0 end)
        / sum(interview_weight) * 100, 1
    ) as asim_yuzdesi_agirlikli

from with_exceeds
where has_ul_defined
group by ingredient_name, category
