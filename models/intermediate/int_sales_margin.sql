-- models/intermediate/int_sales_margin.sql
-- Intermediate model: calculate product-level margin and margin percent

with sales as (
    select
        orders_id,
        products_id,              
        date_date,
        quantity,
        cast(revenue as float64) as revenue
    from {{ ref("stg_raw__sales") }}
),

products as (
    select
        products_id,
        cast(purchase_price as float64) as purchase_price
    from {{ ref("stg_raw__product") }}
)

select
    s.orders_id,
    s.products_id,
    s.date_date,
    s.quantity,
    s.revenue,
    p.purchase_price,

    -- purchase cost per product
    s.quantity * p.purchase_price as purchase_cost,

    -- margin (revenue - purchase_cost)
    s.revenue - (s.quantity * p.purchase_price) as margin,

    -- margin percent using macro (wrap in string so dbt treats as SQL col)
    {{ margin_percent("s.revenue", "s.quantity * p.purchase_price") }} as margin_percent

from sales s
left join products p
    on s.products_id = p.products_id
