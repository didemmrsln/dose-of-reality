{{ config(materialized='view') }}

select
    SEQN as seqn,
    DSDSUPID as product_id,
    DSDSUPP as product_name,
    DSD103 as days_used_30d,
    '2009-2010' as cycle
from {{ source('nhanes_raw', 'dsqids_2009_2010') }}
