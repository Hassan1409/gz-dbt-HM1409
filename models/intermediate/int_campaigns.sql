with campaigns as (

    select * from {{ ref('stg_raw__facebook') }}
    union all
    select * from {{ ref('stg_raw__adwords') }}
    union all
    select * from {{ ref('stg_raw__bing') }}
    union all
    select * from {{ ref('stg_raw__criteo') }}

)

select * from campaigns