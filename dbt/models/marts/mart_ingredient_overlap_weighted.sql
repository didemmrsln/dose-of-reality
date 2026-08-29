{{ config(materialized='table') }}

-- Kisi-ingredient bazinda cakisma tespiti, AGIRLIKLI (interview_weight).
-- NHANES kurali: supplement anketi hane halki mulakatinin parcasi,
-- bu yuzden interview_weight (WTINT2YR) kullanilir.

with base as (
    select
        ing.seqn,
        ing.ingredient_name,
        ing.category,
        ing.product_id,
        demo.interview_weight
    from {{ ref('int_supplement_ingredients') }} ing
    left join {{ ref('stg_demo_l') }} demo on ing.seqn = demo.seqn
),

overlap_flag as (
    select
        seqn, ingredient_name, category, interview_weight,
        count(distinct product_id) > 1 as has_overlap
    from base
    group by seqn, ingredient_name, category, interview_weight
)

select
    ingredient_name,
    category,

    -- Ham (referans/karsilastirma icin)
    count(*) as toplam_kisi_ham,
    countif(has_overlap) as cakisma_sayisi_ham,

    -- Agirlikli
    sum(interview_weight) as toplam_agirlik,
    sum(case when has_overlap then interview_weight else 0 end) as cakisma_agirlik,
    round(
        sum(case when has_overlap then interview_weight else 0 end)
        / sum(interview_weight) * 100, 1
    ) as cakisma_yuzdesi_agirlikli

from overlap_flag
group by ingredient_name, category
