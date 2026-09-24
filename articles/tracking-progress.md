# Tracking Your Progress

This guide assumes you’ve already solved at least one challenge, if you
haven’t yet, start with [Getting Started with
rgrind](https://devwebwacky.github.io/rgrind/articles/getting-started.md)
first.

Every time you attempt a challenge, `rgrind` quietly records it,
locally, on your own machine, in a small file it manages for you.
Nothing is ever sent anywhere. This local history is what powers
streaks, stats, and the activity heatmap.

## Solving something to track

``` r

library(rgrind)

run_challenge("sum_evens", function(x) sum(x[x %% 2 == 0], na.rm = TRUE))
#> 
#> ── Sum of Even Numbers ─────────────────────────────────────────────────────────
#> Base R Optimisation • Easy
#> 
#> ────────────────────────────────────────────────────────────────────────────────
#> ✔ All 7 tests passed!
#> 🔥 Current streak: 1 day
#> 
#> ── Explanation
#> Idiomatic solution: sum(x[x %% 2 == 0], na.rm = TRUE) This avoids a for-loop
#> entirely by using R's vectorised modulo operator to build a logical mask, then
#> subsetting. This is roughly 50-100x faster than a for-loop for large vectors
#> because R's C-level vectorised operations avoid per-element interpreter
#> overhead.
#> 
```

Notice the line with a flame, that’s your **current streak**: the number
of consecutive days (including today) on which you’ve solved at least
one challenge.

## Understanding streaks

A streak counts **calendar days with at least one passing solve**, not
individual solves. Solving five challenges today still only counts as
one streak day. Solving nothing today doesn’t break your streak
immediately either, your streak stays alive until the day *after* the
one you last solved something, giving you until the end of today to keep
it going.

## Checking your overall stats

``` r

rg_stats()
#> 
#> ── Your rgrind Stats ───────────────────────────────────────────────────────────
#> ℹ Challenges solved: 1/10
#> ℹ Total attempts: 1
#> ℹ 🔥 Current streak: 1 day
#> ℹ 🏆 Longest streak: 1 day
```

This shows:

- **Challenges solved** : how many distinct challenges you’ve fully
  passed at least once (out of the total available)
- **Total attempts** : every submission you’ve made, passing or not
- **Current streak** : your active consecutive-day count
- **Longest streak** : the best run you’ve ever had, even if it’s since
  ended

## Viewing your activity heatmap

``` r

rg_heatmap()
#> 
#> ── Last 28 Days
#> · · · · · · ·
#> · · · · · · ·
#> · · · · · · ·
#> · · · · · · ▪
#> 
#> · none ▪ 1 ▓ 2-3 █ 4+
```

This shows the last 28 days as a simple grid, one row per week. Each
symbol represents how many challenges you passed that day:

- `·` : no solves that day
- `▪` : 1 solve
- `▓` : 2-3 solves
- `█` : 4 or more solves

It’s a quick visual way to see your consistency over time — the kind of
thing that’s satisfying to watch fill in as you build a habit.

## Viewing your raw history

If you want the full underlying data, every single attempt, with
timestamps, you can access it directly:

``` r

rg_get_history()
#>   challenge_id           timestamp passed
#> 1    sum_evens 2026-09-24 23:26:33   TRUE
```

This can be useful if you want to analyse your own progress further (for
example, seeing which challenges took you multiple attempts).

## Starting fresh

If you ever want to wipe your local history completely, for example, if
you’re demonstrating the package to someone else, or just want a clean
slate, you can reset it:

``` r

rg_reset_history()
```

**This cannot be undone**, so use it deliberately.

## What’s next

That’s the full loop: solve challenges, build a streak, watch your
heatmap fill in. Run
[`list_challenges()`](https://devwebwacky.github.io/rgrind/reference/list_challenges.md)
any time to see what’s left to try, and come back daily to keep your
streak alive.
