{{ config(materialized='view') }}

select
    DSDPID as product_id,
    DSDSUPP as product_name,

    DSDPRDT as product_type_code,
    case DSDPRDT
        when 1 then 'Regular'
        when 2 then 'Generic'
        when 3 then 'Default'
    end as product_type,

    DSDTYPE as supplement_type_code,
    case DSDTYPE
        when 1 then 'Infant/Pediatric'
        when 2 then 'Prenatal'
        when 3 then 'Mature'
        when 4 then 'Standard'
    end as supplement_type,

    DSDSRCE as source_code,
    DSDSERVQ as serving_quantity,
    DSDSERVU as serving_unit

from {{ source('nhanes_raw', 'dspi') }}
