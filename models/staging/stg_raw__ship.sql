{{ config(materialized="view") }}

select
    orders_id,
    cast(shipping_fee as float64) as shipping_fee,
    cast(shipping_fee_1 as float64) as shipping_fee_extra,  -- renamed for clarity
    cast(logCost as float64) as log_cost,                  -- renamed to snake_case
    cast(ship_cost as float64) as ship_cost
from {{ source('raw', 'ship') }}
