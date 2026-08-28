{{ config(materialized='view') }}

-- NOT: Bu cycle DSDPID kullaniyor (2021-2023 ile ayni),
-- DSDSUPID DEGIL (o eski cycle'larda - 2011-2016 - kullanilan isimdi)

select
    SEQN as seqn,
    DSDPID as product_id,
    DSDSUPP as product_name,
    DSD103 as days_used_30d,
    '2017-2020' as cycle
from {{ source('nhanes_raw', 'dsqids_2017_2020') }}
