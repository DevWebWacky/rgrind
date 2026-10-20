## Resubmission

This is a resubmission. I have:

* Replaced `\dontrun{}` with runnable examples (all execute in well
  under 5 seconds), removing the "Not run" warning noted in review.
* Ensured examples no longer write to the user's home filespace by
  default, they now redirect to `tempdir()` via
  `options(rgrind.storage_dir = tempdir())` before running, and
  restore the previous option afterward.

## R CMD check results

0 errors | 0 warnings | 0 notes (local)

Win-builder (R-devel) previously showed 1 NOTE: "New submission"
