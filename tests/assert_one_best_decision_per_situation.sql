-- Every situation with 2+ reliable options must have exactly one best decision.
-- This test returns the situations that break that rule. Zero rows = pass.
select
    distance_bucket,
    field_position_bucket,
    score_bucket,
    time_bucket,
    sum(case when is_best_decision then 1 else 0 end) as best_count
from {{ ref('mart_decision_benchmark') }}
where reliable_options >= 2
group by
    distance_bucket,
    field_position_bucket,
    score_bucket,
    time_bucket
having sum(case when is_best_decision then 1 else 0 end) <> 1