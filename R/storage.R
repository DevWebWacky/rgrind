#' @keywords internal
rg_storage_path <- function() {
  # Tests can override this via options(rgrind.storage_dir = tempdir())
  # so they never touch a real user's actual history file.
  dir <- getOption("rgrind.storage_dir")
  if (is.null(dir)) {
    dir <- tools::R_user_dir("rgrind", which = "data")
  }
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
  }
  file.path(dir, "history.rds")
}

#' Log a single challenge attempt
#' @keywords internal
rg_log_attempt <- function(challenge_id, passed) {
  path <- rg_storage_path()

  new_row <- data.frame(
    challenge_id = challenge_id,
    timestamp = Sys.time(),
    passed = passed,
    stringsAsFactors = FALSE
  )

  if (file.exists(path)) {
    history <- readRDS(path)
    history <- rbind(history, new_row)
  } else {
    history <- new_row
  }

  saveRDS(history, path)
  invisible(history)
}

#' Get your full local challenge attempt history
#'
#' Returns every attempt you've made across all challenges, including
#' both passes and failures, stored locally on your machine.
#'
#' @return A data frame with columns `challenge_id`, `timestamp`, and
#'   `passed`.
#'
#' @examples
#' old_opt <- options(rgrind.storage_dir = tempdir())
#' rg_get_history()
#' options(old_opt)
#'
#' @export
rg_get_history <- function() {
  path <- rg_storage_path()
  if (!file.exists(path)) {
    return(data.frame(
      challenge_id = character(0),
      timestamp = as.POSIXct(character(0)),
      passed = logical(0)
    ))
  }
  readRDS(path)
}

#' Clear your local challenge history
#'
#' Permanently deletes your locally stored attempt history, including
#' streak data. This cannot be undone.
#'
#' @return Invisibly, `TRUE`.
#'
#' @examples
#' old_opt <- options(rgrind.storage_dir = tempdir())
#' rg_reset_history()
#' options(old_opt)
#'
#' @export
rg_reset_history <- function() {
  path <- rg_storage_path()
  if (file.exists(path)) {
    file.remove(path)
  }
  invisible(TRUE)
}

#' Get your current solving streak
#'
#' Calculates how many consecutive days (ending today or yesterday)
#' you've passed at least one challenge. A streak is still considered
#' active if you solved something yesterday but haven't yet today.
#'
#' @return An integer: the current streak length in days.
#'
#' @examples
#' old_opt <- options(rgrind.storage_dir = tempdir())
#' rg_get_streak()
#' options(old_opt)
#'
#' @export
rg_get_streak <- function() {
  history <- rg_get_history()

  passed <- history[history$passed == TRUE, ]
  if (nrow(passed) == 0) {
    return(0L)
  }

  # Reduce to the distinct calendar dates on which at least one
  # challenge was passed (time-of-day doesn't matter for streaks)
  solved_dates <- unique(as.Date(passed$timestamp))
  solved_dates <- sort(solved_dates, decreasing = TRUE)

  today <- Sys.Date()

  # Streak must be "active", most recent solve must be today or
  # yesterday, otherwise the streak is broken (0)
  most_recent <- solved_dates[1]
  if (!(most_recent %in% c(today, today - 1))) {
    return(0L)
  }

  # Walk backwards from the most recent solved date, counting how
  # many consecutive days in a row have a solve
  streak <- 1L
  for (i in seq_len(length(solved_dates) - 1)) {
    gap <- as.integer(solved_dates[i] - solved_dates[i + 1])
    if (gap == 1) {
      streak <- streak + 1L
    } else {
      break
    }
  }

  streak
}

#' Calculate the longest streak ever achieved (not just the current one)
#' @keywords internal
rg_longest_streak <- function() {
  history <- rg_get_history()
  passed <- history[history$passed == TRUE, ]
  if (nrow(passed) == 0) return(0L)

  solved_dates <- sort(unique(as.Date(passed$timestamp)))

  longest <- 1L
  current <- 1L

  if (length(solved_dates) > 1) {
    for (i in 2:length(solved_dates)) {
      gap <- as.integer(solved_dates[i] - solved_dates[i - 1])
      if (gap == 1) {
        current <- current + 1L
        longest <- max(longest, current)
      } else {
        current <- 1L
      }
    }
  }

  longest
}

#' Show a summary of your overall rgrind progress
#'
#' Prints how many challenges you've solved, your total attempts, and
#' your current and longest solving streaks.
#'
#' @return Invisibly, a list with `solved`, `total_challenges`,
#'   `attempts`, `current_streak`, and `longest_streak`.
#'
#' @examples
#' old_opt <- options(rgrind.storage_dir = tempdir())
#' rg_stats()
#' options(old_opt)
#'
#' @export
rg_stats <- function() {
  history <- rg_get_history()

  n_solved <- length(unique(history$challenge_id[history$passed == TRUE]))
  n_total_challenges <- length(list_challenges())
  n_attempts <- nrow(history)
  current_streak <- rg_get_streak()
  longest_streak <- rg_longest_streak()

  cli::cli_h1("Your rgrind Stats")
  cli::cli_alert_info("Challenges solved: {n_solved}/{n_total_challenges}")
  cli::cli_alert_info("Total attempts: {n_attempts}")
  cli::cli_alert_info("\U0001F525 Current streak: {current_streak} day{if (current_streak != 1) 's' else ''}")
  cli::cli_alert_info("\U0001F3C6 Longest streak: {longest_streak} day{if (longest_streak != 1) 's' else ''}")

  invisible(list(
    solved = n_solved,
    total_challenges = n_total_challenges,
    attempts = n_attempts,
    current_streak = current_streak,
    longest_streak = longest_streak
  ))
}

#' @keywords internal
rg_heatmap_symbol <- function(n_solves) {
  if (n_solves == 0) return(cli::col_grey("\u00B7"))         # ·  grey, empty day
  if (n_solves == 1) return(cli::col_green("\u25AA"))         # ▪  solved once
  if (n_solves <= 3) return(cli::col_green("\u2593"))         # ▓  solved 2-3 times
  return(cli::style_bold(cli::col_green("\u2588")))            # █  solved 4+ times, bold
}

#' Show a 28-day activity heatmap
#'
#' Prints a simple ASCII grid showing how many challenges you passed
#' each day over the last 28 days, similar in spirit to GitHub's
#' contribution graph.
#'
#' @return Invisibly, a character vector of the rendered symbols.
#'
#' @examples
#' old_opt <- options(rgrind.storage_dir = tempdir())
#' rg_heatmap()
#' options(old_opt)
#'
#' @export
rg_heatmap <- function() {
  history <- rg_get_history()
  passed <- history[history$passed == TRUE, ]

  today <- Sys.Date()
  days <- seq(today - 27, today, by = "day")

  if (nrow(passed) > 0) {
    solved_dates <- as.Date(passed$timestamp)
    daily_counts <- table(solved_dates)
  } else {
    daily_counts <- table(character(0))
  }

  symbols <- vapply(days, function(d) {
    n <- if (as.character(d) %in% names(daily_counts)) {
      as.integer(daily_counts[as.character(d)])
    } else {
      0L
    }
    rg_heatmap_symbol(n)
  }, character(1))

  cli::cli_h3("Last 28 Days")

  # Print 7 symbols per row (one row per week)
  for (week_start in seq(1, length(symbols), by = 7)) {
    week_symbols <- symbols[week_start:min(week_start + 6, length(symbols))]
    cli::cli_text(paste(week_symbols, collapse = " "))
  }

  cli::cli_text("")
  cli::cli_text("{.emph \u00B7 none   \u25AA 1   \u2593 2-3   \u2588 4+}")

  invisible(symbols)
}
