-- Why 120 situations instead of a finer split?
-- Finding: the finer split (5 score groups, 4 time groups) makes 332 situations,
-- but only 36 have 2+ choices with 30+ plays. The 120-situation version has 42.
WITH finer AS (
    SELECT
        distance_bucket,
        field_position_bucket,
        CASE
            WHEN score_differential <= -9 THEN 'Down 9+'
            WHEN score_differential BETWEEN -8 AND -1 THEN 'Down 1-8'
            WHEN score_differential = 0 THEN 'Tied'
            WHEN score_differential BETWEEN 1 AND 8 THEN 'Up 1-8'
            WHEN score_differential >= 9 THEN 'Up 9+'
        END AS score_detail,
        CASE
            WHEN qtr >= 5 THEN 'Overtime'
            WHEN game_seconds_remaining > 900 THEN 'Q1-Q3'
            WHEN game_seconds_remaining > 300 THEN 'Q4, 5+ min left'
            ELSE 'Q4, final 5 min'
        END AS time_detail,
        decision
    FROM fct_fourth_downs
),

choices AS (
    SELECT
        distance_bucket,
        field_position_bucket,
        score_detail,
        time_detail,
        decision,
        COUNT(*) AS plays
    FROM finer
    GROUP BY distance_bucket, field_position_bucket, score_detail, time_detail, decision
),

situations AS (
    SELECT
        distance_bucket,
        field_position_bucket,
        score_detail,
        time_detail,
        SUM(CASE WHEN plays >= 30 THEN 1 ELSE 0 END) AS reliable_options
    FROM choices
    GROUP BY distance_bucket, field_position_bucket, score_detail, time_detail
)

SELECT
    COUNT(*) AS situations,
    SUM(CASE WHEN reliable_options >= 2 THEN 1 ELSE 0 END) AS comparable_situations
FROM situations;