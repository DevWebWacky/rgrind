#' Run an rgrind puzzle against your own solution
#'
#' Tests a user-submitted function against a challenge's test cases,
#' printing styled pass/fail feedback to the console. On a full pass,
#' shows an explanation of the idiomatic solution and updates your
#' local solving streak. On any failure, shows details for the failed
#' tests and a hint.
#'
#' @param challenge_id Character. The id of the challenge to run.
#'   See [list_challenges()] for all available ids.
#' @param user_fun Function. Your own solution to test — written and
#'   defined in your own R session, then passed in directly.
#'
#' @return Invisibly, a list with `passed` (number of test cases
#'   passed) and `total` (total number of test cases).
#'
#' @examples
#' old_opt <- options(rgrind.storage_dir = tempdir())
#' my_solution <- function(x) sum(x[x %% 2 == 0], na.rm = TRUE)
#' run_challenge("sum_evens", my_solution)
#' options(old_opt)
#'
#' @export
run_challenge <- function(challenge_id, user_fun) {

  challenge <- get_challenge(challenge_id)

  cli::cli_h1(challenge$title)
  cli::cli_text("{.emph {challenge$category}} \u2022 {.emph {challenge$difficulty}}")
  cli::cli_text("")

  n_tests <- length(challenge$test_cases)
  n_passed <- 0
  failures <- list()  # collect details only for failed tests

  for (i in seq_len(n_tests)) {
    tc <- challenge$test_cases[[i]]

    actual <- tryCatch(
      do.call(user_fun, tc$input),
      error = function(e) e
    )

    if (inherits(actual, "error")) {
      failures[[length(failures) + 1]] <- list(
        index = i,
        message = sprintf("Your function errored: %s", conditionMessage(actual))
      )
      next
    }

    check_result <- rg_check_equal(
      actual, tc$expected,
      tolerance = tc$tolerance  # NULL if not set on this test case, exact match
    )
    passed <- isTRUE(check_result)

    if (passed) {
      n_passed <- n_passed + 1
    } else {
      failures[[length(failures) + 1]] <- list(
        index = i,
        message = check_result  # rg_check_equal already gives a readable message
      )
    }
  }

  cli::cli_rule()

  if (n_passed == n_tests) {
    cli::cli_alert_success("{.strong All {n_tests} tests passed!}")

    rg_log_attempt(challenge_id, passed = TRUE)
    streak <- rg_get_streak()
    streak_word <- if (streak == 1) "day" else "days"
    cli::cli_text("{.strong \U0001F525 Current streak: {streak} {streak_word}}")

    cli::cli_text("")
    cli::cli_h3("Explanation")
    cli::cli_text(challenge$explanation)
    cli::cli_text("")
  } else {
    cli::cli_alert_danger("{.strong {n_passed}/{n_tests} tests passed}")
    cli::cli_text("")

    # Only show detail for the failed tests
    cli::cli_h3("Failed tests")
    for (f in failures) {
      cli::cli_alert_danger("Test {f$index}: {f$message}")
    }

    cli::cli_text("")
    cli::cli_h3("Hint")
    cli::cli_text(challenge$hint)
    cli::cli_text("")
  }

  if (n_passed != n_tests) {
    rg_log_attempt(challenge_id, passed = FALSE)
  }

  invisible(list(passed = n_passed, total = n_tests))
}
