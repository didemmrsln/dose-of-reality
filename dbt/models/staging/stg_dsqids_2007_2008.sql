{{ config(materialized='view') }}

-- NOT: Bu cycle'da DSDSUPP (urun adi) sutunu bulunmuyor, sadece DSDSUPID (ID) var.

select
    SEQN as seqn,
    DSDSUPID as product_id,
    cast(null as string) as product_name,
    DSD103 as days_used_30d,
    '2007-2008' as cycle
from {{ source('nhanes_raw', 'dsqids_2007_2008') }}
