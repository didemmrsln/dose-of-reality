{{ config(materialized='view') }}

select
    SEQN as seqn,
    DSDSUPID as product_id,
    DSDSUPP as product_name,
    DSD103 as days_used_30d,
    '1999-2002' as cycle
from {{ source('nhanes_raw', 'dsqids_2001_2002') }}
