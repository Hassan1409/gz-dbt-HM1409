-- models/staging/stg_raw__sales.sql
-- Minimal staging for raw_gz_sales

with source as (

    select *
    from {{ source('raw', 'sales') }}

)

select
    date_date,
    orders_id,
    pdt_id as products_id,
    revenue,
    quantity
from source