{{ config(materialized='table') }}

-- Kisi + ingredient bazinda TOPLAM miktar (mcg, birim standardize edilmis)
-- ve bu toplamin UL'yi (mcg) asip asmadigi.
--
-- SADECE unit_convertible = true olan satirlar toplaniyor -- yani
-- donusumu yapilamayan (% DV, kcal, mL, DU/HUT/LU, tanimsiz IU) satirlar
-- bu hesaba KATILMIYOR ve ayri bir sayacla raporlaniyor (seffaflik icin).

select
    seqn,
    ingredient_name,
    category,
    ul_value_mcg,
    has_ul_defined,

    sum(case when unit_convertible then quantity_mcg else 0 end) as total_quantity_mcg,
    countif(not unit_convertible) as n_donusturulemeyen_satir,
    count(*) as n_toplam_satir,

    case
        when has_ul_defined and sum(case when unit_convertible then quantity_mcg else 0 end) > ul_value_mcg then true
        when has_ul_defined then false
        else null
    end as exceeds_ul

from {{ ref('int_ingredients_with_ul') }}
group by seqn, ingredient_name, category, ul_value_mcg, has_ul_defined
