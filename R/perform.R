#' Perform a request with opinionated defaults
#'
#' This function ensures that a request has [httr2::req_retry()] applied, and
#' then performs the request, using either [httr2::req_perform_iterative()] (if
#' a `next_req` function is supplied) or [httr2::req_perform()] (if not).
#'
#' @inheritParams httr2::req_perform_iterative
#' @inheritParams rlang::args_dots_empty
#' @param next_req An optional function that takes the previous response
#'   (`resp`) to generate the next request in a call to
#'   [httr2::req_perform_iterative()]. This function can usually be generated
#'   using one of the iteration helpers described in
#'   [httr2::iterate_with_offset()].
#' @param max_reqs The maximum number of separate requests to perform. Passed to
#'   the max_reqs argument of [httr2::req_perform_iterative()] when `next_req`
#'   is supplied. The default `2` should likely be changed to `Inf` after you
#'   validate the function.
#' @param max_tries_per_req The maximum number of times to attempt each
#'   individual request. Passed to the `max_tries` argument of
#'   [httr2::req_retry()].
#'
#' @return A list of [httr2::response()] objects, one for each request
#'   performed.
#' @export
req_perform_opinionated <- function(req,
                                    ...,
                                    next_req = NULL,
                                    max_reqs = 2,
                                    max_tries_per_req = 3) {
  rlang::check_dots_empty()
  req <- .req_apply_retry_default(req, max_tries_per_req)
  if (is.null(next_req)) {
    return(list(req_perform(req)))
  }
  req_perform_iterative(
    req,
    next_req = next_req,
    max_reqs = max_reqs
  )
}

.req_apply_retry_default <- function(req, max_tries_per_req) {
  if (
    any(c("retry_max_wait", "retry_max_tries") %in% names(req$policies)) ||
      is.null(max_tries_per_req)
  ) {
    return(req)
  }
  return(httr2::req_retry(req, max_tries = max_tries_per_req))
}
