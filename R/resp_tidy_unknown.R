#' Error informatively for unknown response types
#'
#' If you have not defined a parser for a response type, use this function to
#' return useful information to help construct a parser.
#'
#' @inheritParams .shared-params
#'
#' @returns This function always throws an error. The error lists the names of
#'   the response pieces after parsing with [resp_body_auto()].
#' @export
resp_tidy_unknown <- function(resp, call = rlang::caller_env()) {
  results <- resp_body_auto(resp)
  .nectar_abort(
    c(
      "No parser is defined for this response.",
      i = "Response pieces: {names(results)}"
    ),
    error_class = "unknown_response_type",
    call = call
  )
}
