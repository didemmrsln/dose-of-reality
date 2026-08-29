{{ config(materialized='table') }}

-- Cycle bazinda AGIRLIKLI genel kullanim trendi.
-- Her cycle kendi orijinal interview_weight'i ile hesaplanir
-- (combining-cycles formulu burada KULLANILMAZ - cycle'lar ayri ayri karsilastiriliyor)

with usage_per_person as (

    select
        d.seqn,
        d.cycle,
        d.interview_weight,
        count(distinct i.raw_product_id) as n_products_used

    from {{ ref('int_demo_all_cycles') }} as d
    left join {{ ref('int_dsqids_all_cycles') }} as i
        on d.seqn = i.seqn and d.cycle = i.cycle

    group by d.seqn, d.cycle, d.interview_weight

)

select
    cycle,

    round(
        sum(case when n_products_used > 0 then interview_weight else 0 end)
        / sum(interview_weight) * 100, 1
    ) as kullanim_yuzdesi_agirlikli,

    round(
        sum(case when n_products_used > 1 then interview_weight else 0 end)
        / sum(case when n_products_used > 0 then interview_weight else 0 end) * 100, 1
    ) as coklu_kullanim_yuzdesi_agirlikli

from usage_per_person
group by cycle
order by cycle
