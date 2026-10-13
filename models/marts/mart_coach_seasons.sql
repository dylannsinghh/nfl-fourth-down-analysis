with graded as (

    select *
    from {{ ref('fct_graded_decisions')}}
),

coach_seasons as (

    select 
        season,
        coach,
        posteam as team,
        count(distinct game_id) as games,
        count(*) as decisions,
        sum(case when decision = 'go' then 1 else 0 end) as go_decisions,
        sum(case when is_graded then 1 else 0 end) as graded_decisions,
        sum(case when made_best_call then 1 else 0 end ) as best_calls,
        -1 * sum(coalesce(wpa_vs_best, 0)) as wins_lost
    from graded
    group by
        season,
        coach,
        posteam

),

with_rates as (

    select
        *,
        round(100.0 * go_decisions / decisions, 1) as go_pct,
        round(100.0 * best_calls / nullif(graded_decisions, 0), 1) as best_call_pct,
        wins_lost / games as wins_lost_per_game
    from coach_seasons
)

select
    *,
    rank() over (
        partition by season
        order by wins_lost_per_game asc
    ) as season_rank,
    lag(wins_lost_per_game) over (
        partition by coach
        order by season
    ) as prev_season_wins_lost_per_game
    from with_rates