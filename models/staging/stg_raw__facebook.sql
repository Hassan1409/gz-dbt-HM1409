-- models/staging/stg_raw__facebook.sql
-- Staging model for Facebook ads

select
    date_date,
    paid_source,
    campaign_key,
    camPGN_name as campaign_name,
    cast(ads_cost as float64) as ads_cost,
    impression as ads_impression,
    click as ads_clicks
from {{ source('raw', 'facebook') }}
