# Get your full local challenge attempt history

Returns every attempt you've made across all challenges, including both
passes and failures, stored locally on your machine.

## Usage

``` r
rg_get_history()
```

## Value

A data frame with columns `challenge_id`, `timestamp`, and `passed`.

## Examples

``` r
old_opt <- options(rgrind.storage_dir = tempdir())
rg_get_history()
#> [1] challenge_id timestamp    passed      
#> <0 rows> (or 0-length row.names)
options(old_opt)
```
