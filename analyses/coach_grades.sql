-- Giants by season
-- Finding: (what you noticed about Shurmur vs Judge vs Daboll)
-- Pat Schurmur was goated, got so much worse after
SELECT
    season,
    coach,
    games,
    decisions,
    best_call_pct,
    ROUND(wins_lost, 2) AS wins_lost,
    season_rank
FROM mart_coach_seasons
WHERE team = 'NYG'
ORDER BY season;


-- Career leaderboard (2+ full seasons)
-- Finding: (who's best, who's worst, where Daboll ranks)
-- bruce arians so sad he had to leave, matt lafleur is gaoted, so is nick sirianni
SELECT
    coach,
    COUNT(*) AS seasons,
    SUM(games) AS games,
    ROUND(100.0 * SUM(best_calls) / SUM(graded_decisions), 1) AS best_call_pct,
    ROUND(SUM(wins_lost) / SUM(games) * 17, 2) AS wins_lost_per_season
FROM mart_coach_seasons
GROUP BY coach
HAVING SUM(games) >= 34
ORDER BY wins_lost_per_season;