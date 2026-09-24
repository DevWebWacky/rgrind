# Show a summary of your overall rgrind progress

Prints how many challenges you've solved, your total attempts, and your
current and longest solving streaks.

## Usage

``` r
rg_stats()
```

## Value

Invisibly, a list with `solved`, `total_challenges`, `attempts`,
`current_streak`, and `longest_streak`.

## Examples

``` r
old_opt <- options(rgrind.storage_dir = tempdir())
rg_stats()
#> 
#> ── Your rgrind Stats ───────────────────────────────────────────────────────────
#> ℹ Challenges solved: 0/10
#> ℹ Total attempts: 0
#> ℹ 🔥 Current streak: 0 days
#> ℹ 🏆 Longest streak: 0 days
options(old_opt)
```
