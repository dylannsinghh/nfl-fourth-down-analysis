{{ config(materialized='external', location='exports/decision_benchmark.csv')}}

select *
from {{ ref('mart_decision_benchmark')}}
