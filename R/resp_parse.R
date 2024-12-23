#' Parse one or more responses
#'
#' `httr2` provides two methods for performing requests: [httr2::req_perform()],
#' which returns a single [httr2::response()] object, and
#' [httr2::req_perform_iterative()], which returns a list of [httr2::response()]
#' objects. This function automatically determines whether a single response or
#' multiple responses have been returned, and parses the responses
#' appropriately.
#'
#' @inheritParams .shared-params
#' @param ... Additional arguments passed on to the `response_parser` function
#'   (in addition to `resp`).
#'
#' @return The response parsed by the `response_parser`. If `resp` was a list,
#'   the parsed responses are concatenated when possible. Unlike
#'   [httr2::resps_data], this function does not concatenate raw vector
#'   responses.
#' @export
resp_parse <- function(resp, ...) {
  UseMethod("resp_parse")
}

#' @inheritParams .shared-params
#' @export
#' @rdname resp_parse
resp_parse.default <- function(resp,
                               ...,
                               arg = rlang::caller_arg(resp),
                               call = rlang::caller_env()) {
  cli_abort(
    c(
      "{.arg {arg}} must be a {.cls list} or a {.cls httr2_response}.",
      x = "{.arg {arg}} is {.obj_type_friendly {resp}}."
    ),
    class = "nectar_error_unsupported_response_class",
    call = call
  )
}

#' @inheritParams .shared-params
#' @export
#' @rdname resp_parse
resp_parse.httr2_response <- function(resp,
                                      ...,
                                      response_parser = httr2::resp_body_json) {
  do_if_fn_defined(resp, response_parser, ...)
}

#' @export
resp_parse.list <- function(resp,
                            ...,
                            response_parser = httr2::resp_body_json) {
  resp_parsed <- .resp_parse_impl(resp, response_parser, ...)
  .resp_combine(resp_parsed)
}

.resp_parse_impl <- function(resp, response_parser, ...) {
  # httr2::resps_data concatenates raw vectors, which is almost certainly not
  # what users would want. For example, images get combined to be on top of one
  # another.
  lapply(
    httr2::resps_successes(resp),
    resp_parse,
    response_parser = response_parser,
    ...
  )
}

.resp_combine <- function(resp_parsed) {
  purrr::discard(resp_parsed, is.null)
  if (inherits(resp_parsed[[1]], "raw")) {
    return(resp_parsed)
  }
  vctrs::list_unchop(resp_parsed)
}
