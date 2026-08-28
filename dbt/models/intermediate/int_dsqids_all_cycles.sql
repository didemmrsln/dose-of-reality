{{ config(materialized='view') }}

-- 5 cycle'in supplement kullanim verilerini birlestirir.
-- DSPI ile join edilebilecek ORTAK bir anahtar (dspi_product_id) turetiliyor:
--   - 2011-2012, 2013-2014, 2015-2016 (eski DSDSUPID sistemi):
--     product_id (=DSDSUPID), DSPI.DSDSUPID uzerinden eslesir
--   - 2017-2020, 2021-2023 (yeni DSDPID sistemi):
--     product_id (=DSDPID), DSPI.DSDPID uzerinden eslesir
--
-- DSPI tablosunun HEM DSDSUPID HEM DSDPID sutunlarini birlikte
-- tasidigi (CDC resmi doc, bkz. NHANES_ID_Sistemi_Kisiti.md) kullanilarak,
-- dspi_product_id her zaman DSPI.DSDPID degerine esitleniyor -
-- boylece bu modelden sonraki tum join'ler (DSII, DSBI) TEK bir
-- sutun (DSDPID) uzerinden yapilabiliyor.

with unified as (

    select seqn, product_id, product_name, days_used_30d, cycle,
           'legacy' as id_system
    from {{ ref('stg_dsqids_2011_2012') }}

    union all

    select seqn, product_id, product_name, days_used_30d, cycle,
           'legacy' as id_system
    from {{ ref('stg_dsqids_2013_2014') }}

    union all

    select seqn, product_id, product_name, days_used_30d, cycle,
           'legacy' as id_system
    from {{ ref('stg_dsqids_2015_2016') }}

    union all

    select seqn, cast(product_id as string) as product_id, product_name,
           days_used_30d, cycle, 'current' as id_system
    from {{ ref('stg_dsqids_2017_2020') }}

    union all

    select seqn, cast(product_id as string) as product_id, product_name,
           days_used_30d, '2021-2023' as cycle, 'current' as id_system
    from {{ ref('stg_dsqids_l') }}

),

with_dspi_key as (

    select
        u.seqn,
        u.product_id as raw_product_id,
        u.product_name,
        u.days_used_30d,
        u.cycle,
        u.id_system,

        -- id_system'e gore dogru DSPI sutunu ile eslestirilip
        -- her zaman guncel DSDPID degeri donduruluyor
        case
            when u.id_system = 'legacy' then legacy_map.DSDPID
            when u.id_system = 'current' then cast(u.product_id as int64)
        end as dspi_product_id

    from unified u
    left join (
        select cast(DSDSUPID as string) as legacy_id, DSDPID
        from {{ source('nhanes_raw', 'dspi') }}
        where DSDSUPID is not null
    ) as legacy_map
        on u.id_system = 'legacy' and u.product_id = legacy_map.legacy_id

)

select * from with_dspi_key
