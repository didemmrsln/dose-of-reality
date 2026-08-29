{{ config(materialized='view') }}

-- Cok-cycle versiyonu: int_ingredients_normalized ile ayni mantik,
-- int_supplement_ingredients_all_cycles uzerinden calisir.
-- DSII (birim kodlari dahil) tum cycle'larda ORTAK oldugu icin
-- DSDUNIT esleme mantigi degismeden kullanilabilir.

select
    seqn, cycle, dspi_product_id as product_id, product_name,
    age_years, gender, ethnicity_v1, ethnicity_v3,
    ingredient_name, quantity, unit_code, category,

    case unit_code
        when 1 then 'mg' when 2 then 'IU' when 3 then '% DV'
        when 4 then 'mcg' when 5 then 'gm' when 6 then 'mL'
        when 7 then 'kcal' when 8 then 'DU' when 9 then 'HUT' when 10 then 'LU'
    end as unit_label,

    case
        when unit_code = 1 then quantity * 1000
        when unit_code = 4 then quantity
        when unit_code = 5 then quantity * 1000000
        when unit_code = 2 and ingredient_name = 'VITAMIN A' then quantity * 0.3
        when unit_code = 2 and ingredient_name = 'VITAMIN D' then quantity * 0.025
        when unit_code = 2 and ingredient_name = 'VITAMIN E' then quantity * 670
        else null
    end as quantity_mcg,

    case
        when unit_code in (1, 4, 5) then true
        when unit_code = 2 and ingredient_name in ('VITAMIN A', 'VITAMIN D', 'VITAMIN E') then true
        else false
    end as unit_convertible

from {{ ref('int_supplement_ingredients_all_cycles') }}
