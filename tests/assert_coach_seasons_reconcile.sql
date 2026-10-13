-- Every decisions in fct_fourth_downs should be counted exactly once in mart_coach_seasons.
-- Returns a row only if the two totals don't match. Zero rows = pass.
with mart_total as (

    select sum(decisions) as total_decisions
    from {{ ref('mart_coach_seasons')}}
),

source_total as (

    select count(*) as total_decisions
    from {{ ref('fct_fourth_downs')}}
)

select 
    mart_total.total_decisions as mart_decisions,
    source_total.total_decisions as source_decisions
from mart_total
cross join source_total
where mart_total.total_decisions <> source_total.total_decisions