{{ config(materialized='table') }}

-- Kisi-ingredient bazinda cakisma tespiti
-- Bir kisi ayni ingredient'i kac FARKLI urunden aliyor?
-- NOT: Bu model sadece CAKISMA tespiti yapiyor, UL karsilastirmasi icermiyor.
--      UL karsilastirmasi ayri bir model olarak eklenmistir (mart_ul_comparison).

select
    seqn,
    ingredient_name,
    category,
    count(distinct product_id) as n_farkli_urun,
    count(distinct product_id) > 1 as has_overlap

from {{ ref('int_supplement_ingredients') }}

group by seqn, ingredient_name, category
