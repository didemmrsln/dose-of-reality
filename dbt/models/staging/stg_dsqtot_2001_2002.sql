{{ config(materialized='view') }}

select
    SEQN as seqn,
    DSDCOUNT as total_supplements_used,
    cast(null as float64) as total_antacids_used,
    '1999-2002' as cycle
from {{ source('nhanes_raw', 'dsqtot_2001_2002') }}
