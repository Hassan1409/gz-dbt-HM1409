{{ config(materialized='view') }}

with f as (
    select *
    from {{ ref('finance_days') }}
),

c as (
    select *
    from {{ ref('int_campaigns_day') }}
)

select
    f.date as date,
    (f.operational_margin - c.ads_cost) as ads_margin,
    f.average_basket,
    f.operational_margin,
    c.ads_cost,
    c.ads_impression,       -- ✅ was impression
    c.ads_clicks,           -- ✅ was click
    f.total_quantity as quantity,
    f.total_revenue as revenue,
    f.total_purchase_cost as purchase_cost,
    (f.total_revenue - f.total_purchase_cost) as margin,
    f.total_shipping_fees as shipping_fee,
    f.total_log_costs as log_cost,
    f.total_log_costs as ship_cost   -- double-check if you want this to differ
from f
left join c
  on f.date = c.date_date


