{{ config(materialized='view') }}

with person_products as (

    select
        dsqids.seqn,
        dsqids.product_id,
        dsqids.product_name,
        dsqids.days_used_30d,
        demo.age_years,
        demo.gender,
        demo.ethnicity_v1,
        demo.ethnicity_v3

    from {{ ref('stg_dsqids_l') }} as dsqids
    left join {{ ref('stg_demo_l') }} as demo
        on dsqids.seqn = demo.seqn

),

product_ingredients as (

    select
        pp.seqn,
        pp.product_id,
        pp.product_name,
        pp.days_used_30d,
        pp.age_years,
        pp.gender,
        pp.ethnicity_v1,
        pp.ethnicity_v3,

        dsii.ingredient_name,
        dsii.ingredient_std_id,
        dsii.quantity,
        dsii.unit_code,
        dsii.category,
        dsii.is_blend

    from person_products as pp
    left join {{ ref('stg_dsii') }} as dsii
        on pp.product_id = dsii.product_id

)

select * from product_ingredients
where ingredient_name is not null
