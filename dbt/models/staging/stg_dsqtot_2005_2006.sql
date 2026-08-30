{{ config(materialized='view') }}

select
    SEQN as seqn,
    DSDCOUNT as total_supplements_used,
    DSDANCNT as total_antacids_used,
    '2005-2006' as cycle
from {{ source('nhanes_raw', 'dsqtot_2005_2006') }}
