with decisions as (

    select *
    from {{ ref('fct_fourth_downs')}}

),

by_situation as (

    select 
    distance_bucket,
    field_position_bucket,
    score_bucket,
    time_bucket,
    decision,
    count(*) as plays,
    avg(wpa) as avg_wpa
from decisions
group by
    distance_bucket,
    field_position_bucket,
    score_bucket,
    time_bucket,
    decision
),

flagged as (

    select 
    *, 
    plays >= {{ var('min_sample_size')}} as is_reliable
from by_situation

),

ranked as (

    select
    *,
    sum(case when is_reliable then 1 else 0 end) over (
        partition by distance_bucket, field_position_bucket, score_bucket, time_bucket

    ) as reliable_options,
    rank() over(
        partition by distance_bucket, field_position_bucket, score_bucket, time_bucket
        order by is_reliable desc, avg_wpa desc
    ) as wpa_rank,
    max(case when is_reliable then avg_wpa end) over (
        partition by distance_bucket, field_position_bucket, score_bucket, time_bucket
    ) as best_avg_wpa
from flagged

)

select 
    distance_bucket,
    field_position_bucket,
    score_bucket,
    time_bucket,
    decision,
    plays,
    avg_wpa,
    is_reliable,
    reliable_options,
    wpa_rank,
    (wpa_rank = 1 and is_reliable and reliable_options >= 2) as is_best_decision, 
    case 
        when is_reliable and reliable_options >= 2 then avg_wpa - best_avg_wpa
    end as wpa_vs_best
from ranked 