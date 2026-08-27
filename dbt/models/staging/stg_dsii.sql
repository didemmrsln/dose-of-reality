{{ config(materialized='view') }}

select
    DSDPID as product_id,
    DSDIID as ingredient_row_id,
    DSDINGR as ingredient_name,
    DSDINGID as ingredient_std_id,
    DSDQTY as quantity,
    DSDUNIT as unit_code,

    DSDCAT as category_code,
    case DSDCAT
        when 1 then 'Vitamin'
        when 2 then 'Mineral'
        when 3 then 'Botanical'
        when 4 then 'Other'
        when 5 then 'Amino Acid'
    end as category,

    DSDBLFLG as is_blend

from {{ source('nhanes_raw', 'dsii') }}
where DSDCAT in (1, 2)
