-- models/mart/finance_days.sql
-- Mart: daily finance KPIs at day granularity

with orders as (
    -- order-level totals (revenue, quantity, purchase_cost, margin)
    select *
    from {{ ref('int_orders_margin') }}
),

ops as (
    -- order-level operational margin
    select *
    from {{ ref('int_orders_operational') }}
),

ship as (
    -- one row per order with numeric shipping fields
    select
        orders_id,
        -- be defensive: cast to numeric to avoid type errors
        safe_cast(shipping_fee as float64)  as shipping_fee,
        safe_cast(logCost      as float64)  as log_cost,
        safe_cast(ship_cost    as float64)  as ship_cost
    from {{ ref('stg_raw__ship') }}
)

select
    -- daily grain
    o.date_date as date,

    -- # of orders
    count(distinct o.orders_id)                                    as total_transactions,

    -- revenue & basket
    sum(o.revenue)                                                 as total_revenue,
    safe_divide(sum(o.revenue), count(distinct o.orders_id))       as average_basket,

    -- operational margin (already calculated per order)
    sum(coalesce(op.operational_margin, 0))                        as operational_margin,

    -- costs & qty
    sum(o.purchase_cost)                                           as total_purchase_cost,
    sum(coalesce(s.shipping_fee, 0))                               as total_shipping_fees,
    sum(coalesce(s.log_cost, 0))                                   as total_log_costs,
    sum(o.quantity)                                                as total_quantity

from orders o
left join ops  op using (orders_id, date_date)
left join ship s  using (orders_id)
group by 1
order by 1
