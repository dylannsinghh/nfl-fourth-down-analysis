# NFL 4th Down Decision Analysis

Should a team go for it on 4th down? This project grades every regular season 4th down call since 2018 against what has historically worked best in the same situation, and turns that into a tool you can pull up during a game.

**Live dashboard:** [NFL 4th Down Decision Tool](https://public.tableau.com/app/profile/dylan.singh/viz/NFL4thDownDecisionTool/4thDownDecisions)

*Numbers through Week 5 of the 2026 season.*

## The question
If I were advising an NFL front office: is our head coach too conservative on 4th down, and what is it costing us in wins?

## What I found
- **Teams go for it much more than they used to.** The go rate rose from 15% in 2018 to 23% in 2025. On 4th and 1 it went from 56% to 76%. On 4th and 7+ it barely moved, so the shift is all short yardage.
- **When the data can compare options, going for it usually wins.** In the 42 situations with enough plays of at least two choices, going for it had the best average outcome in 30.
- **Coaches still leave wins on the table.** Compared with the best historical option, the average team gives up about half a win per season (0.49 per 17 games) on 4th down calls alone.
- **Best and worst.** Among 50 coaches with two or more full seasons, Bruce Arians, Nick Sirianni, and Matt LaFleur lose the least (about 0.32 wins per season). Brian Callahan, Matt Patricia, and Mike Tomlin lose the most (0.63 to 0.70).
- **Giants.** Brian Daboll gave up 0.68 wins in 2022 and improved every season, down to 0.51 in 2025.

## How it works
```
nflverse play-by-play (2018-2026)
  -> stg_plays                one clean row per play (403K plays)
  -> fct_fourth_downs         31K regular season 4th down decisions, labeled go / punt / field goal
                              and sorted into 120 game situations
  -> mart_decision_benchmark  average win probability added by each choice in each situation
  -> fct_graded_decisions     every real decision compared with the best option for its situation
  -> mart_coach_seasons       wins lost, best-call rate, and rank by coach and season
  -> CSV exports -> Tableau Public dashboard
```
A situation combines yards to go (1, 2-3, 4-6, 7+), field position (5 zones), score (down 9+, one-score game, up 9+), and time (Q1-Q3, Q4 + OT).

## Key decisions
- **Penalties and timeouts are excluded.** When a 4th down play is wiped out by a penalty, the down gets replayed and the real decision shows up in the next row. Counting both would double count.
- **120 situations, not more.** A finer split made 332 situations, but only 36 had enough data to compare choices, fewer than the 42 in this version.
- **Minimum sample size.** A choice needs 30+ plays to count, and a situation needs 2+ such choices before a best call is named.
- **Coaches are ranked per game, not by totals,** so interim coaches and partial seasons compare fairly.

## Data quality
23 automated tests run on every build, including:
- Unique, non-null keys on every play, which catches rows duplicated by a bad join
- Every play must land in a situation bucket, so nothing silently drops out
- A custom test that every comparable situation has exactly one best decision
- A reconciliation test that coach totals add back up to the source decision count

## Limitations
- Built from historical averages using nflverse's win probability model, not a model I trained.
- Assumes an average team. It can't see a team's own strengths (an elite defense makes punting worth more), weather, or injuries.
- Teams tend to go for it in favorable spots, which flatters the "go" numbers a little.
- Only 41% of decisions fall in situations that can be graded. Ungraded calls count as zero cost, so wins lost is