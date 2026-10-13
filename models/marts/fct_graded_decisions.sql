with decisions as (

    select *
    from {{ ref('fct_fourth_downs') }}

),

benchmark as (

    select *
    from {{ ref('mart_decision_benchmark') }}

),

best_choices as (

    select
        distance_bucket,
        field_position_bucket,
        score_bucket,
        time_bucket,
        decision as best_decision
    from benchmark
    where is_best_decision

),

graded as (

    select
        d.play_key,
        d.game_id,
        d.season,
        d.week,
        d.posteam,
        d.coach,
        d.distance_bucket,
        d.field_position_bucket,
        d.score_bucket,
        d.time_bucket,
        d.decision,
        bc.best_decision,
        d.wpa,
        b.wpa_vs_best,
        d.play_description
    from decisions as d
    left join benchmark as b
        on  d.distance_bucket = b.distance_bucket
        and d.field_position_bucket = b.field_position_bucket
        and d.score_bucket = b.score_bucket
        and d.time_bucket = b.time_bucket
        and d.decision = b.decision
    left join best_choices as bc
        on  d.distance_bucket = bc.distance_bucket
        and d.field_position_bucket = bc.field_position_bucket
        and d.score_bucket = bc.score_bucket
        and d.time_bucket = bc.time_bucket

)

select
    *,
    wpa_vs_best is not null as is_graded,
    case
        when wpa_vs_best is not null then decision = best_decision
    end as made_best_call
from graded