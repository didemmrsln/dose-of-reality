{{ config(materialized='view') }}

-- Butun miktarlari MCG (mikrogram) cinsine standardize ediyoruz.
-- Kaynak: DSII.htm resmi codebook (DSDUNIT kod tablosu)
--   1=mg, 2=IU, 3=% (DV), 4=mcg, 5=gm, 6=mL, 7=kcal, 8=DU, 9=HUT, 10=LU
--
-- IU -> mcg donusumu INGREDIENT'A OZGU (Appendix 2, DSPI.htm):
--   Vitamin A: 1 IU = 0.3 mcg (RAE)
--   Vitamin D: 1 IU = 0.025 mcg
--   Vitamin E: 1 IU = 0.67 mg = 670 mcg
--
-- % (DV) ve kcal/mL/DU/HUT/LU gibi mutlak agirlik olmayan birimler
-- standardize EDILEMEZ - bu satirlar ayri bir bayrakla isaretlenip
-- UL karsilastirmasindan haric tutulacak.

select
    seqn,
    product_id,
    product_name,
    age_years,
    gender,
    ethnicity_v1,
    ethnicity_v3,
    ingredient_name,
    quantity,
    unit_code,
    category,

    case unit_code
        when 1 then 'mg'
        when 2 then 'IU'
        when 3 then '% DV'
        when 4 then 'mcg'
        when 5 then 'gm'
        when 6 then 'mL'
        when 7 then 'kcal'
        when 8 then 'DU'
        when 9 then 'HUT'
        when 10 then 'LU'
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

from {{ ref('int_supplement_ingredients') }}
