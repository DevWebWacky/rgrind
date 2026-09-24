# Show a 28-day activity heatmap

Prints a simple ASCII grid showing how many challenges you passed each
day over the last 28 days, similar in spirit to GitHub's contribution
graph.

## Usage

``` r
rg_heatmap()
```

## Value

Invisibly, a character vector of the rendered symbols.

## Examples

``` r
old_opt <- options(rgrind.storage_dir = tempdir())
rg_heatmap()
#> 
#> ── Last 28 Days 
#> · · · · · · ·
#> · · · · · · ·
#> · · · · · · ·
#> · · · · · · ·
#> 
#> · none ▪ 1 ▓ 2-3 █ 4+
options(old_opt)
```
