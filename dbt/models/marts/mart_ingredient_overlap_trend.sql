{{ config(materialized='table') }}

select
    cycle,
    seqn,
    ingredient_name,
    category,
    count(distinct dspi_product_id) as n_farkli_urun,
    count(distinct dspi_product_id) > 1 as has_overlap

from {{ ref('int_supplement_ingredients_all_cycles') }}

group by cycle, seqn, ingredient_name, category
