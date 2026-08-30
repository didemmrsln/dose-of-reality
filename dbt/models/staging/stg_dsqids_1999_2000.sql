{{ config(materialized='view') }}

-- NOT: Bu cycle'da DSD103 (gunluk kullanim) yok, DSD100Q/DSD100U (sikligi)
-- kullaniliyor ama dogrudan karsilastirilabilir degil, bu yuzden NULL birakildi.

select
    SEQN as seqn,
    DSDSUPID as product_id,
    DSDSUPP as product_name,
    cast(null as float64) as days_used_30d,
    '1999-2002' as cycle
from {{ source('nhanes_raw', 'dsqids_1999_2000') }}
