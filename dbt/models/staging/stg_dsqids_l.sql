{{ config(materialized='view') }}

select
    SEQN as seqn,
    DSDPID as product_id,
    DSDSUPP as product_name,
    DSDACTSS as days_used_30d,
    WTDRD1 as dietary_weight
from {{ source('nhanes_raw', 'dsqids_l') }}
