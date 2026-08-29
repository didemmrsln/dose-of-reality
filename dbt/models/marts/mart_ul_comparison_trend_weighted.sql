{{ config(materialized='table') }}

-- Cycle + ingredient bazinda AGIRLIKLI UL asim orani

with aggregated as (
    select
        seqn, cycle, ingredient_name, category, ul_value_mcg, has_ul_defined,
        sum(case when unit_convertible then quantity_mcg else 0 end) as total_quantity_mcg
    from {{ ref('int_ingredients_with_ul_all_cycles') }}
    group by seqn, cycle, ingredient_name, category, ul_value_mcg, has_ul_defined
),

with_exceeds as (
    select
        a.*,
        d.interview_weight,
        case
            when has_ul_defined and total_quantity_mcg > ul_value_mcg then true
            when has_ul_defined then false
            else null
        end as exceeds_ul
    from aggregated a
    left join {{ ref('int_demo_all_cycles') }} d
        on a.seqn = d.seqn and a.cycle = d.cycle
)

select
    cycle,
    ingredient_name,
    category,
    round(
        sum(case when exceeds_ul then interview_weight else 0 end)
        / sum(interview_weight) * 100, 1
    ) as asim_yuzdesi_agirlikli

from with_exceeds
where has_ul_defined
group by cycle, ingredient_name, category
