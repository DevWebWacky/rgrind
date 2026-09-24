# Get your current solving streak

Calculates how many consecutive days (ending today or yesterday) you've
passed at least one challenge. A streak is still considered active if
you solved something yesterday but haven't yet today.

## Usage

``` r
rg_get_streak()
```

## Value

An integer: the current streak length in days.

## Examples

``` r
old_opt <- options(rgrind.storage_dir = tempdir())
rg_get_streak()
#> [1] 0
options(old_opt)
```
