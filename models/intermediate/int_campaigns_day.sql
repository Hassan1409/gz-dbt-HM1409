with daily as (
    select
        date_date,
        sum(ads_cost) as ads_cost,
        sum(ads_impression) as ads_impression,
        sum(ads_clicks) as ads_clicks
    from {{ ref('int_campaigns') }}
    group by date_date
)

select *
from daily
order by date_date desc