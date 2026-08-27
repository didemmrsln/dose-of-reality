{{ config(materialized='view') }}

select
    DSDIID as ingredient_row_id,
    DSDINGR as ingredient_name,
    DSDBID as blend_id,
    DSDBCNAM as blend_component_name,
    DSDBCCAT as blend_component_category,
    DSDBCID as blend_component_id
from {{ source('nhanes_raw', 'dsbi') }}
