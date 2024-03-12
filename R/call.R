#' Send a request to an API
#'
#' This function implements an opinionated framework for making API calls. It is
#' intended to be used inside an API client package. It serves as a wrapper
#' around the `req_` family of functions, such as [httr2::request()], as well as
#' [httr2::req_perform()] and, by default, [httr2::resp_body_json()].
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
                     security_fn = NULL,
                     security_args = list(),
                     response_parser = httr2::resp_body_json,
                     response_parser_args = list(),
                     user_agent = "nectar (https://nectar.api2r.org)") {
  req <- req_prepare(
    base_url = base_url,
    path = path,
    query = query,
    body = body,
    mime_type = mime_type,
    method = method,
    user_agent = user_agent
  )
  req <- .req_security_apply(req, security_fn, security_args)
  resp <- req_perform(req)
  resp <- .resp_parse(resp, response_parser, response_parser_args)
  return(resp)
}

.req_security_apply <- function(req, security_fn, security_args) {
  if (length(security_fn)) {
    req <- rlang::inject(
      security_fn(req, !!!security_args)
    )
  }
  return(req)
}

#' @export
#' @importFrom httr2 req_perform
httr2::req_perform

.resp_parse <- function(resp, response_parser, response_parser_args) {
  if (length(response_parser)) {
    resp <- .resp_parse_apply(
      resp,
      response_parser,
      response_parser_args
    )
  }
  return(resp)
}

.resp_parse_apply <- function(resp, response_parser, response_parser_args) {
  return(rlang::inject(response_parser(resp, !!!response_parser_args))) # nocov
}
