#' Send a request to an API
#'
#' @description `r lifecycle::badge("questioning")`
#'
#'   This function implements an opinionated framework for making API calls. It
#'   is intended to be used inside an API client package. It serves as a wrapper
#'   around the `req_` family of functions, such as [httr2::request()], as well
#'   as [httr2::req_perform()] and [httr2::req_perform_iterative()], and, by
#'   default, [httr2::resp_body_json()].
#'
#' @seealso [req_prepare()], [req_perform_opinionated()], and [resp_parse()] for
#'   finer control of the process.
#'
#' @inheritParams rlang::args_dots_empty
#' @inheritParams req_prepare
#' @inheritParams req_perform_opinionated
#' @inheritParams resp_parse
#' @param response_parser_args (`list`) Additional arguments to pass to the
#'   `response_parser`.
#'
#' @return The response from the API, parsed by the `response_parser`.
#' @export
call_api <- function(base_url,
                     ...,
                     path = NULL,
                     query = NULL,
                     body = NULL,
                     mime_type = NULL,
                     method = NULL,
                     auth_fn = NULL,
                     auth_args = list(),
                     response_parser = resp_tidy,
                     response_parser_args = list(),
                     next_req = NULL,
                     max_reqs = Inf,
                     max_tries_per_req = 3,
                     additional_user_agent = NULL) {
  rlang::check_dots_empty()
  req <- req_prepare(
    base_url,
    path = path,
    query = query,
    body = body,
    mime_type = mime_type,
    method = method,
    additional_user_agent = additional_user_agent,
    auth_fn = auth_fn,
    auth_args = auth_args
  )
  resps <- req_perform_opinionated(
    req,
    next_req = next_req,
    max_reqs = max_reqs,
    max_tries_per_req = max_tries_per_req
  )
  result <- resp_parse(
    resps,
    response_parser = response_parser,
    !!!response_parser_args
  )
  return(result)
}
