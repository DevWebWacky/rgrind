
# rgrind <img src="man/figures/logo.svg" align="right" height="180" />

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

`rgrind` brings gamified, LeetCode-style algorithmic and data wrangling
challenges directly into your R console. Solve puzzles against real test
cases, get instant styled feedback with explanations, and build a daily
solving streak, all running locally, with zero setup and zero cost.

## Why rgrind?

Popular coding practice platforms (LeetCode, HackerRank, Codewars)
barely support R. Existing R learning tools (like DataCamp) rely on
passive video courses in a browser. `rgrind` is different: it is an
active, in-console practice tool built specifically for R’s own idioms:
vectorisation, the tidyverse, and statistical computing, with nothing to
install beyond the package itself.

## Installation

You can install the development version of rgrind from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("DevWebWacky/rgrind")
```

## Quick example

``` r
library(rgrind)

my_solution <- function(x) sum(x[x %% 2 == 0], na.rm = TRUE)
run_challenge("sum_evens", my_solution)
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

## Browse available challenges

``` r
list_challenges()
#>  [1] "avg_above"            "bootstrap_ci"         "count_missing"       
#>  [4] "count_na"             "first_duplicate"      "max_consecutive_ones"
#>  [7] "pivot_long_scores"    "remove_outliers"      "rolling_sum"         
#> [10] "sum_evens"
```

`rgrind` currently ships with 10 challenges across four categories: Base
R Optimisation, Tidyverse Wrangling, Vectorisation Efficiency, and
Statistical Algorithms, ranging from Easy warm-ups to Medium/Hard
puzzles.

## Track your progress

Every attempt is logged locally on your own machine, nothing is sent
anywhere. Check your stats and keep your streak alive:

``` r
rg_stats()
#> 
#> ── Your rgrind Stats ───────────────────────────────────────────────────────────
#> ℹ Challenges solved: 1/10
#> ℹ Total attempts: 1
#> ℹ 🔥 Current streak: 1 day
#> ℹ 🏆 Longest streak: 1 day
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

## License

MIT © Uwakmfon Paul
