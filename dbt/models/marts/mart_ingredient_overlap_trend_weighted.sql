{{ config(materialized='table') }}

-- Cycle + ingredient bazinda AGIRLIKLI cakisma orani

with base as (
    select
        i.cycle,
        i.seqn,
        i.ingredient_name,
        i.category,
        i.dspi_product_id,
        d.interview_weight
    from {{ ref('int_supplement_ingredients_all_cycles') }} i
    left join {{ ref('int_demo_all_cycles') }} d
        on i.seqn = d.seqn and i.cycle = d.cycle
),

overlap_flag as (
    select
        cycle, seqn, ingredient_name, category, interview_weight,
        count(distinct dspi_product_id) > 1 as has_overlap
    from base
    group by cycle, seqn, ingredient_name, category, interview_weight
)

select
    cycle,
    ingredient_name,
    category,
    round(
        sum(case when has_overlap then interview_weight else 0 end)
        / sum(interview_weight) * 100, 1
    ) as cakisma_yuzdesi_agirlikli

from overlap_flag
group by cycle, ingredient_name, category
