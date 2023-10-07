#' Send a request to an API
#'
#' This function implements an opinionated framework for making API calls. It is
#' intended to be used inside an API client package. It serves as a wrapper
#' around the `req_` family of functions, such as [httr2::request()].
#'
#' @inheritParams .shared-parameters
#' @param response_parser A function to use to parse the server response.
#'   Defaults to [httr2::resp_body_json()], since JSON responses are common. Set
#'   this to `NULL` to return the raw response from [httr2::req_perform()].
#' @param response_parser_args An optional list of arguments to the
#'   `response_parser` function.
#'
#' @return The response from the API, parsed by the `response_parser`.
#' @export
call_api <- function(base_url,
                     path = NULL,
                     query = NULL,
                     body = NULL,
                     mime_type = NULL,
                     method = NULL,
                     response_parser = httr2::resp_body_json,
                     response_parser_args = list(),
                     user_agent = "nectar (https://jonthegeek.github.io/nectar/)") {
  req <- .prepare_request(
    base_url,
    path,
    query,
    body,
    method,
    mime_type,
    user_agent
  )
  resp <- req_perform(req)

  if (length(response_parser)) {
    resp <- rlang::inject(response_parser(resp, !!!response_parser_args))
  }
  return(resp)
}
