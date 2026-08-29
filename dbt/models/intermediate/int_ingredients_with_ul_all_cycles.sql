{{ config(materialized='view') }}

select
    norm.seqn, norm.cycle, norm.product_id, norm.product_name,
    norm.age_years, norm.gender, norm.ethnicity_v1, norm.ethnicity_v3,
    norm.ingredient_name, norm.quantity, norm.unit_label,
    norm.quantity_mcg, norm.unit_convertible, norm.category,

    ul.ul_value, ul.unit as ul_unit_raw,
    case
        when ul.unit = 'mg' then ul.ul_value * 1000
        when ul.unit = 'mcg' then ul.ul_value
        when ul.unit = 'g' then ul.ul_value * 1000000
        else null
    end as ul_value_mcg,

    case when ul.ul_value is not null then true else false end as has_ul_defined

from {{ ref('int_ingredients_normalized_all_cycles') }} as norm
left join {{ ref('stg_ul_reference') }} as ul
    on norm.ingredient_name = ul.ingredient_name
