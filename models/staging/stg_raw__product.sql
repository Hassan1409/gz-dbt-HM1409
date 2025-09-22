with source as (
    select *
    from {{ source('raw', 'product') }}
)

select
    products_id,
    purchSE_PRICE as purchase_price   -- don’t cast yet
from source