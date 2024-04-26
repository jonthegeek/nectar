#' Send a request to an API
#'
#' This function implements an opinionated framework for making API calls. It is
#' intended to be used inside an API client package. It serves as a wrapper
#' around the `req_` family of functions, such as [httr2::request()], as well as
#' [httr2::req_perform()] and [httr2::req_perform_iterative()], and, by default,
#' [httr2::resp_body_json()].
#'
#' @seealso [req_setup()], [req_modify()], [req_perform_opinionated()],
#'   [resp_parse()], and [do_if_fn_defined()] for finer control of the process.
#'
#' @inheritParams rlang::args_dots_empty
#' @inheritParams req_setup
#' @inheritParams req_modify
#' @inheritParams req_perform_opinionated
#' @inheritParams resp_parse
#' @param security_fn A function to use to authenticate the request. By default
#'   (`NULL`), no authentication is performed.
#' @param security_args An optional list of arguments to the `security_fn`
#'   function.
#' @param response_parser_args An optional list of arguments to pass to the
#'   `response_parser` function (in addition to `resp`).
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
                     security_fn = NULL,
                     security_args = list(),
                     response_parser = httr2::resp_body_json,
                     response_parser_args = list(),
                     next_req = NULL,
                     max_reqs = Inf,
                     max_tries_per_req = 3,
                     user_agent = "nectar (https://nectar.api2r.org)") {
  rlang::check_dots_empty()
  req <- req_setup(base_url, user_agent = user_agent)
  req <- req_modify(
    req,
    path = path,
    query = query,
    body = body,
    mime_type = mime_type,
    method = method
  )
  req <- do_if_fn_defined(req, security_fn, !!!security_args)
  resp <- req_perform_opinionated(
    req,
    next_req = next_req,
    max_reqs = max_reqs,
    max_tries_per_req = max_tries_per_req
  )
  resp <- resp_parse(
    resp,
    response_parser = response_parser,
    !!!response_parser_args
  )
  return(resp)
}
