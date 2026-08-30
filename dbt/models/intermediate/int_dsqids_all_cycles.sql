{{ config(materialized='view') }}

-- TUM 10 cycle blogunun supplement kullanim verilerini birlestirir.
-- Tum eski cycle'lar (1999-2010) 'legacy' id_system (DSDSUPID) kullanir.

with unified as (

    select seqn, product_id, product_name, days_used_30d, cycle, 'legacy' as id_system
    from {{ ref('stg_dsqids_1999_2000') }}

    union all

    select seqn, product_id, product_name, days_used_30d, cycle, 'legacy' as id_system
    from {{ ref('stg_dsqids_2001_2002') }}

    union all

    select seqn, product_id, product_name, days_used_30d, cycle, 'legacy' as id_system
    from {{ ref('stg_dsqids_2003_2004') }}

    union all

    select seqn, product_id, product_name, days_used_30d, cycle, 'legacy' as id_system
    from {{ ref('stg_dsqids_2005_2006') }}

    union all

    select seqn, product_id, product_name, days_used_30d, cycle, 'legacy' as id_system
    from {{ ref('stg_dsqids_2007_2008') }}

    union all

    select seqn, product_id, product_name, days_used_30d, cycle, 'legacy' as id_system
    from {{ ref('stg_dsqids_2009_2010') }}

    union all

    select seqn, product_id, product_name, days_used_30d, cycle, 'legacy' as id_system
    from {{ ref('stg_dsqids_2011_2012') }}

    union all

    select seqn, product_id, product_name, days_used_30d, cycle, 'legacy' as id_system
    from {{ ref('stg_dsqids_2013_2014') }}

    union all

    select seqn, product_id, product_name, days_used_30d, cycle, 'legacy' as id_system
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
