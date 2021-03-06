
#' Set the random seed for widget element ids
#'
#' Set a random seed for generating widget element ids. Calling this
#' function rather than relying on the default behavior ensures
#' stable widget ids across sessions.
#'
#' @inheritParams base::set.seed
#'
#' @export
setWidgetIdSeed <- function(seed, kind = NULL, normal.kind = NULL) {
  sysSeed <- .GlobalEnv$.Random.seed
  on.exit({
    .globals$idSeed <- .GlobalEnv$.Random.seed
    if (!is.null(sysSeed))
      .GlobalEnv$.Random.seed <- sysSeed
    else
      rm(".Random.seed", envir = .GlobalEnv)
  })
  set.seed(seed, kind = kind, normal.kind = normal.kind)
}

# create a new unique widget id
createWidgetId <- function(bytes = 10) {

  # Note what the system's random seed is before we start, so we can restore it after
  sysSeed <- .GlobalEnv$.Random.seed
  # Replace system seed with our own seed
  if (!is.null(.globals$idSeed)) {
    .GlobalEnv$.Random.seed <- .globals$idSeed
  }
  on.exit({
    # Change our own seed to match the current seed
    .globals$idSeed <- .GlobalEnv$.Random.seed
    # Restore the system seed--we were never here
    .GlobalEnv$.Random.seed <- sysSeed
  })

  paste(
    format(as.hexmode(sample(256, bytes, replace = TRUE)-1), width=2),
    collapse = "")
}

