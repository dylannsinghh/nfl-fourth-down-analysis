-- Ticket 3 findings: how often do teams go for it on 4th down?
-- Run in the DuckDB notebook: duckdb -ui data/nfl.duckdb

-- 1. Go-for-it rate by season
-- Finding: about 15% in 2018, rising to about 23% in 2025
SELECT
    season,
    ROUND(100.0 * SUM(CASE WHEN decision = 'go' THEN 1 ELSE 0 END) / COUNT(*), 1) AS go_pct
FROM fct_fourth_downs
GROUP BY season
ORDER BY season;

-- 2. Go-for-it rate by season and distance
-- Finding: 4th and 1 rose from 56% (2018) to 76% (2025), and 2-3 yards rose from 21% to 39%.
-- 7+ yards stayed flat (6-9%). The shift is broad in short yardage, not just the tush push.
SELECT
    season,
    distance_bucket,
    ROUND(100.0 * SUM(CASE WHEN decision = 'go' THEN 1 ELSE 0 END) / COUNT(*), 1) AS go_pct
FROM fct_fourth_downs
GROUP BY season, distance_bucket
ORDER BY distance_bucket, season;