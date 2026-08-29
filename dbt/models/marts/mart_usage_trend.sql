{{ config(materialized='table') }}

-- Cycle bazinda genel supplement kullanim trendi.
-- DSII/DSPI join'i GEREKTIRMEZ - sadece DSQIDS + DEMO uzerinden.

with usage_per_person as (

    select
        d.seqn,
        d.cycle,
        d.gender,
        d.ethnicity_v1,
        d.combined_interview_weight,
        count(distinct i.raw_product_id) as n_products_used

    from {{ ref('int_demo_all_cycles') }} as d
    left join {{ ref('int_dsqids_all_cycles') }} as i
        on d.seqn = i.seqn and d.cycle = i.cycle

    group by d.seqn, d.cycle, d.gender, d.ethnicity_v1, d.combined_interview_weight

)

select
    cycle,
    count(*) as toplam_kisi,
    countif(n_products_used > 0) as supplement_kullanan_kisi,
    round(countif(n_products_used > 0) / count(*) * 100, 1) as kullanim_yuzdesi,
    round(avg(case when n_products_used > 0 then n_products_used end), 2) as ort_urun_sayisi_kullananlar,
    countif(n_products_used > 1) as coklu_urun_kullanan_kisi,
    round(countif(n_products_used > 1) / countif(n_products_used > 0) * 100, 1) as coklu_kullanim_yuzdesi

from usage_per_person
group by cycle
order by cycle
