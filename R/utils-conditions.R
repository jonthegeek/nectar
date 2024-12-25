#' Error messaging for this package.
#'
#' @inheritParams .shared-params
#' @inheritParams cli::cli_abort
#' @param error_class (`length-1 character`) A short string to identify the
#'   error family.
#'
#' @returns An error condition with classes `"nectar-condition"`,
#'   `"nectar-error"`, and `"nectar-error-{error_class}"`.
#' @keywords internal
.nectar_abort <- function(message,
                          error_class,
                          ...,
                          call = rlang::caller_env(),
                          .envir = rlang::caller_env()) {
  cli::cli_abort(
    message,
    class = c(
      paste0("nectar_error-", error_class),
      "nectar_error",
      "nectar_condition"
    ),
    call = call,
    .envir = .envir,
    ...
  )
}
