{{ config(materialized='view') }}

select
    SEQN as seqn,
    DSDCOUNT as total_supplements_used,
    DSDANCNT as total_antacids_used,
    WTDRD1 as dietary_weight
from {{ source('nhanes_raw', 'dsqtot_l') }}
