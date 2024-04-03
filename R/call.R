#' Send a request to an API
#'
#' This function implements an opinionated framework for making API calls. It is
#' intended to be used inside an API client package. It serves as a wrapper
#' around the `req_` family of functions, such as [httr2::request()], as well as
#' [httr2::req_perform()] and [httr2::req_perform_iterative()], and, by default,
#' [httr2::resp_body_json()].
#'
#' @inheritParams .shared-parameters
#' @inheritParams httr2::req_perform_iterative
#' @param response_parser A function to parse the server response (`resp`).
#'   Defaults to [httr2::resp_body_json()], since JSON responses are common. Set
#'   this to `NULL` to return the raw response from [httr2::req_perform()].
#' @param response_parser_args An optional list of arguments to pass to the
#'   `response_parser` function (in addition to `resp`).
#' @param next_req An optional function that takes the previous response
#'   (`resp`) to generate the next request in a call to
#'   [httr2::req_perform_iterative()]. This function can usually be generated
#'   using [httr2::iterate_with_offset()], [httr2::iterate_with_cursor()], or
#'   [httr2::iterate_with_link_url()].
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
                     next_req = NULL,
                     max_reqs = Inf,
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
  resp <- .req_perform(req, next_req, max_reqs)
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

.req_perform <- function(req, next_req = NULL, max_reqs = Inf) {
  if (is.null(next_req)) {
    return(req_perform(req))
  }
  req <- httr2::req_retry(
    req,
    max_tries = 4,
    backoff = function(attempts) {
      10 * attempts # nocov
    }
  )
  req_perform_iterative(
    req,
    next_req = next_req,
    max_reqs = max_reqs
  )
}

.resp_parse <- function(resp, response_parser, response_parser_args) {
  UseMethod(".resp_parse")
}

#' @export
.resp_parse.list <- function(resp, response_parser, response_parser_args) {
  resps_data(
    httr2::resps_successes(resp),
    resp_data = function(resp) {
      .resp_parse(resp, response_parser, response_parser_args)
    }
  )
}

#' @export
.resp_parse.httr2_response <- function(resp,
                                       response_parser,
                                       response_parser_args) {
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
