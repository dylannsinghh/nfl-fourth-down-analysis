with fourth_downs as (

    select *
    from {{ ref('stg_plays')}}
    where season_type = 'REG'
        and down = 4
        and play_type in ('run', 'pass', 'punt', 'field_goal')


),

labeled as (
    
    select
        play_key,
        game_id,
        season,
        week,
        posteam,
        defteam,
    
        case 
            when posteam = home_team then home_coach
            when posteam = away_team then away_coach
        end as coach,

        case 
            when play_type in ('run', 'pass') then 'go'
            when play_type = 'punt' then 'punt'
            when play_type = 'field_goal' then 'field_goal'
        end as decision,

        case 
            when ydstogo = 1 then '1'
            when ydstogo between 2 and 3 then '2-3'
            when ydstogo between 4 and 6 then '4-6'
            when ydstogo >= 7 then '7+'
        end as distance_bucket,

        case 
            when yardline_100 between 70 and 99 then 'Own 1-30'
            when yardline_100 between 50 and 69 then 'Own 31-50'
            when yardline_100 between 35 and 49 then 'Opp 35-49'
            when yardline_100 between 20 and 34 then 'Opp 20-34'
            when yardline_100 between 1 and 19 then 'Opp 1-19'
        end as field_position_bucket,

        case 
            when score_differential <= -9 then 'Down 9+'
            when score_differential between -8 and 8 then 'One-score game'
            when score_differential >= 9 then 'Up 9+'
        end as score_bucket,

        case 
            when qtr between 1 and 3 then 'Q1-Q3'
            when qtr >= 4 then 'Q4 + OT'
        end as time_bucket,

        ydstogo,
        yardline_100,
        score_differential,
        qtr,
        game_seconds_remaining,
        wp,
        wpa,
        fourth_down_converted,
        field_goal_result,
        play_description
    
    from fourth_downs
)
select * from labeled