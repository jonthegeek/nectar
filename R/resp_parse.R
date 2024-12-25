#' Parse one or more responses
#'
#' @description `r lifecycle::badge("questioning")`
#'
#'   If you have implemented the full `nectar` framework, use [resp_tidy()]
#'   directly to parse your responses. We may continue to support
#'   `resp_parse()`, but it is most useful as a bridge to the full framework.
#'
#'   `httr2` provides two methods for performing requests:
#'   [httr2::req_perform()], which returns a single [httr2::response()] object,
#'   and [httr2::req_perform_iterative()], which returns a list of
#'   [httr2::response()] objects. This function automatically determines whether
#'   a single response or multiple responses have been returned, and parses the
#'   responses appropriately.
#'
#' @inheritParams .shared-params
#' @param ... Additional arguments passed on to the `response_parser` function
#'   (in addition to `resps`).
#'
#' @return The response parsed by the `response_parser`. If `resps` was a list,
#'   the parsed responses are concatenated when possible. Unlike
#'   [httr2::resps_data], this function does not concatenate raw vector
#'   responses.
#' @export
resp_parse <- function(resps, ...) {
  UseMethod("resp_parse")
}

#' @inheritParams .shared-params
#' @export
#' @rdname resp_parse
resp_parse.default <- function(resps,
                               ...,
                               arg = rlang::caller_arg(resps),
                               call = rlang::caller_env()) {
  .nectar_abort(
    c(
      "{.arg {arg}} must be a {.cls list} or a {.cls httr2_response}.",
      x = "{.arg {arg}} is {.obj_type_friendly {resps}}."
    ),
    error_class = "unsupported_response_class",
    call = call
  )
}

#' @inheritParams .shared-params
#' @export
#' @rdname resp_parse
resp_parse.httr2_response <- function(resps,
                                      ...,
                                      response_parser = resp_tidy) {
  do_if_fn_defined(resps, response_parser, ...)
}

#' @export
resp_parse.list <- function(resps,
                            ...,
                            response_parser = resp_tidy) {
  resps_parsed <- .resp_parse_impl(resps, response_parser, ...)
  .resps_combine(resps_parsed)
}

.resp_parse_impl <- function(resps, response_parser, ...) {
  # httr2::resps_data concatenates raw vectors, which is almost certainly not
  # what users would want. For example, images get combined to be on top of one
  # another.
  lapply(
    httr2::resps_successes(resps),
    resp_parse,
    response_parser = response_parser,
    ...
  )
}

.resps_combine <- function(resps_parsed) {
  purrr::discard(resps_parsed, is.null)
  if (inherits(resps_parsed[[1]], "raw")) {
    # This is tested, but covr doesn't believe it.
    return(resps_parsed) # nocov
  }
  vctrs::list_unchop(resps_parsed)
}
