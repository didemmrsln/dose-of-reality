{{ config(materialized='view') }}

select
    upper(ingredient) as ingredient_name,
    ul_value,
    unit,
    age_group,
    scope_note,
    source
from {{ source('nhanes_raw', 'ul_reference') }}
