-- models/intermediate/int_orders_margin.sql
-- Intermediate model: aggregate sales to order-level margins

with sales_margin as (

    select *
    from {{ ref('int_sales_margin') }}

)

select
    orders_id,

    -- if multiple rows have same order, pick one date (all should match)
    min(date_date) as date_date,

    -- aggregate metrics
    sum(revenue) as revenue,
    sum(quantity) as quantity,
    sum(purchase_cost) as purchase_cost,
    sum(margin) as margin

from sales_margin
group by orders_id