#' Parse one or more responses
#'
#' `httr2` provides two methods for performing requests: [httr2::req_perform()],
#' which returns a single [httr2::response()] object, and
#' [httr2::req_perform_iterative()], which returns a list of [httr2::response()]
#' objects. This function automatically determines whether a single response or
#' multiple responses have been returned, and parses the responses
#' appropriately.
#'
#' @param resp A single [httr2::response()] object (as returned by
#'   [httr2::req_perform()]) or a list of such objects (as returned by
#'   [httr2::req_perform_iterative()]).
#' @param ... Additional arguments passed on to the `response_parser` function
#'   (in addition to `resp`).
#'
#' @return The response parsed by the `response_parser`. If `resp` was a list,
#'   the parsed responses are concatenated. See [httr2::resps_data()] for
#'   examples.
#' @export
resp_parse <- function(resp, ...) {
  UseMethod("resp_parse")
}

#' @export
#' @param arg An argument name as a string. This argument will be mentioned in
#'   error messages as the input that is at the origin of a problem.
#' @param call The execution environment of a currently running function, e.g.
#'   caller_env(). The function will be mentioned in error messages as the
#'   source of the error. See the call argument of abort() for more information.
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

#' @inheritParams .shared-parameters
#' @export
#' @rdname resp_parse
resp_parse.httr2_response <- function(resp,
                                      ...,
                                      response_parser = httr2::resp_body_json) {
  if (length(response_parser)) {
    # Higher-level calls can include !!!'ed arguments.
    dots <- rlang::list2(...)
    return(rlang::inject(response_parser(resp, !!!dots)))
  }
  return(resp)
}

#' @export
resp_parse.list <- function(resp,
                            ...,
                            response_parser = httr2::resp_body_json) {
  httr2::resps_data(
    httr2::resps_successes(resp),
    resp_data = function(resp) {
      resp_parse(resp, response_parser = response_parser, ...)
    }
  )
}
