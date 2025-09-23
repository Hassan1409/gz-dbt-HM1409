-- models/intermediate/int_orders_operational.sql
-- Intermediate model: calculate operational margin per order

with orders as (

    select *
    from {{ ref('int_orders_margin') }}

),

ship as (

    select
        orders_id,
        shipping_fee,
        safe_cast(log_cost as float64) as log_cost,
        safe_cast(ship_cost as float64) as ship_cost
    from {{ ref('stg_raw__ship') }}

)

select
    o.orders_id,
    o.date_date,

    -- operational margin calculation
    (o.margin + s.shipping_fee - s.log_cost - s.ship_cost) as operational_margin

from orders o
left join ship s
    on o.orders_id = s.orders_id
