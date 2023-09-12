#' Send a request to an API
#'
#' This function implements an opinionated framework for making API calls. It is
#' intended to be used inside an API client package. It serves as a wrapper
#' around the `req_` family of functions, such as [httr2::request()].
#'
#' @inheritParams .shared-parameters
#' @param authenticator An authenticator function. More details to come in a
#'   future update to this package.
#' @param authenticator_args Arguments for the authenticator function.
#' @param response_parser A response parser function. More details to come in a
#'   future update to this package.
#' @param response_parser_args Arguments for the response parser function.
#' @param error_handler An error handler function. More details to come in a
#'   future update to this package.
#' @param error_handler_args Arguments for the error handler function.
#' @param user_agent A string to identify where this request is coming from.
#'   It's polite to set the user agent to identify your package, such as
#'   "MyPackage (https://mypackage.com)".
#'
#' @return The response from the API, parsed by the `response_parser`.
#' @export
call_api <- function(base_url,
                     endpoint,
                     query = NULL,
                     body = NULL,
                     mime_type = NULL,
                     method = NULL,
                     api_case = c(
                       "snake_case", "camelCase", "UpperCamel",
                       "SCREAMING_SNAKE", "alllower",
                       "ALLUPPER", "lowerUPPER", "UPPERlower",
                       "Sentence case", "Title Case"
                     ),
                     authenticator = NULL,
                     authenticator_args = list(),
                     response_parser = NULL,
                     response_parser_args = list(),
                     error_handler = NULL,
                     error_handler_args = list(),
                     user_agent = "nectar (https://jonthegeek.github.io/nectar/)") {
  req <- .prepare_request(
    base_url,
    endpoint,
    query,
    body,
    method,
    api_case,
    mime_type
  )
  req <- httr2::req_user_agent(req, user_agent)
  if (!rlang::is_null(authenticator)) {
    req <- rlang::inject(authenticator(req, !!!authenticator_args))
  }
  if (!rlang::is_null(error_handler)) {
    req <- rlang::inject(error_handler(req, !!!error_handler_args))
  }
  # TODO: Probably allow them to pass in a `path` argument for req_perform.
  resp <- httr2::req_perform(req)

  if (!rlang::is_null(response_parser)) {
    resp <- rlang::inject(response_parser(resp, !!!response_parser_args))
  }
  return(resp)
}
