{{ config(materialized='external', location='exports/graded_decisions.csv')}}

select *
from {{ref('fct_graded_decisions')}}