{{ config(materialized="table") }}

with sales as (
    select *
    from {{ ref('int_orders_margin') }}
),
ops as (
    select *
    from {{ ref('int_orders_operational') }}
),
ship as (
    select *
    from {{ ref('stg_raw__ship') }}
)

select
    s.date_date as date,
    count(distinct s.orders_id) as total_transactions,
    coalesce(sum(s.revenue), 0) as total_revenue,
    coalesce(avg(s.revenue), 0) as average_basket,
    coalesce(sum(o.operational_margin), 0) as operational_margin,
    coalesce(sum(s.purchase_cost), 0) as total_purchase_cost,
    coalesce(sum(sh.shipping_fee), 0) + coalesce(sum(sh.shipping_fee_extra), 0) as total_shipping_fees,
    coalesce(sum(sh.log_cost), 0) as total_log_costs,
    coalesce(sum(s.quantity), 0) as total_quantity
from sales s
left join ops o
    on s.orders_id = o.orders_id
left join ship sh
    on s.orders_id = sh.orders_id
group by s.date_date
order by s.date_date desc

