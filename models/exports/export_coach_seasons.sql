{{ config(materialized='external', location='exports/coach_seasons.csv')}}

select *
from {{ ref('mart_coach_seasons')}}