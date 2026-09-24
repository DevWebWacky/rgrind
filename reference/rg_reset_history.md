# Clear your local challenge history

Permanently deletes your locally stored attempt history, including
streak data. This cannot be undone.

## Usage

``` r
rg_reset_history()
```

## Value

Invisibly, `TRUE`.

## Examples

``` r
old_opt <- options(rgrind.storage_dir = tempdir())
rg_reset_history()
options(old_opt)
```
