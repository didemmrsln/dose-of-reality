{{ config(materialized='table') }}

-- Dashboard: genel kullanim, cycle x cinsiyet x yas x etnik koken kirilimli

with usage_per_person as (

    select
        d.seqn,
        d.cycle,
        d.gender,
        case
            when d.age_years < 18 then '0-17'
            when d.age_years < 35 then '18-34'
            when d.age_years < 50 then '35-49'
            when d.age_years < 65 then '50-64'
            else '65+'
        end as age_group,
        d.ethnicity_v1,
        d.interview_weight,
        count(distinct i.raw_product_id) as n_products_used

    from {{ ref('int_demo_all_cycles') }} as d
    left join {{ ref('int_dsqids_all_cycles') }} as i
        on d.seqn = i.seqn and d.cycle = i.cycle

    group by d.seqn, d.cycle, d.gender, age_group, d.ethnicity_v1, d.interview_weight

)

select
    cycle,
    gender,
    age_group,
    ethnicity_v1,

    count(*) as n_kisi,
    countif(n_products_used > 0) as n_kullanan,

    round(
        sum(case when n_products_used > 0 then interview_weight else 0 end)
        / sum(interview_weight) * 100, 1
    ) as kullanim_yuzdesi,

    round(
        sum(case when n_products_used > 1 then interview_weight else 0 end)
        / nullif(sum(case when n_products_used > 0 then interview_weight else 0 end), 0) * 100, 1
    ) as coklu_kullanim_yuzdesi

from usage_per_person
group by cycle, gender, age_group, ethnicity_v1
