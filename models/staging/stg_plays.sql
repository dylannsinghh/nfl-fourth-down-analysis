select
    -- unique ID for every play: game_id + "_" + play_id
    game_id || '_' || cast(cast(play_id as integer) as varchar) as play_key,

    -- which game and when
    game_id,
    cast(play_id as integer) as play_id,
    season,
    season_type,
    week,

    -- teams and coaches
    home_team,
    away_team,
    home_coach,
    away_coach,
    posteam,
    defteam,


    -- game situation
    cast(qtr as integer) as qtr,
    game_seconds_remaining, 
    cast(down as integer) as down,
    cast(ydstogo as integer) as ydstogo,
    cast(yardline_100 as integer) as yardline_100,
    cast(score_differential as integer) as score_differential,

    -- the play and its result
    play_type,
    wp,
    wpa,
    cast(fourth_down_converted as integer) as fourth_down_converted,
    cast(fourth_down_failed as integer) as fourth_down_failed,
    field_goal_result,
    "desc" as play_description

from {{source('nflverse', 'play_by_play')}}

