#' Send a request to an API
#'
#' This function implements an opinionated framework for making API calls. It is
#' intended to be used inside an API client package. It serves as a wrapper
#' around the `req_` family of functions, such as [httr2::request()].
#'
#' @inheritParams .shared-parameters
#' @param api_authenticator An API-specific authenticator function. More details
#'   to come in a future update to this package.
#' @param api_authenticator_args Arguments for the API authenticator function.
#' @param api_resp_parser An API-specific response parser function. More details
#'   to come in a future update to this package.
#' @param api_resp_parser_args Arguments for the API response parser function.
#' @param api_error_handler An API-specific error handler function. More details
#'   to come in a future update to this package.
#' @param api_error_handler_args Arguments for the API error handler function.
#'
#' @return The response from the API, parsed by the `api_resp_parser`.
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
                     api_authenticator = NULL,
                     api_authenticator_args = list(),
                     api_resp_parser = NULL,
                     api_resp_parser_args = list(),
                     api_error_handler = NULL,
                     api_error_handler_args = list()) {
  req <- .prepare_request(
    base_url,
    endpoint,
    query,
    body,
    method,
    api_case,
    mime_type
  )
  if (!rlang::is_null(api_authenticator)) {
    req <- rlang::inject(api_authenticator(req, !!!api_authenticator_args))
  }
  if (!rlang::is_null(api_error_handler)) {
    req <- rlang::inject(api_error_handler(req, !!!api_error_handler_args))
  }
  # TODO: Probably allow them to pass in a `path` argument for req_perform.
  resp <- httr2::req_perform(req)

  if (!rlang::is_null(api_resp_parser)) {
    resp <- rlang::inject(api_resp_parser(resp, !!!api_resp_parser_args))
  }
  return(resp)
}
