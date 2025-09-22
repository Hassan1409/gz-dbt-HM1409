with source as (
    select *
    from {{ source('raw', 'ship') }}
)

select
    orders_id,
    shipping_fee,
    shipping_fee_1,
    logCost,
    ship_cost
from source