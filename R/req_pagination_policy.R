#' Define a pagination policy for a request
#'
#' APIs generally have a specified method for requesting multiple pages of
#' results (or sometimes two or three methods). The methods are sometimes
#' documented within a given endpoint, and sometimes documented at the "top" of
#' the documentation. Use this function to attach a pagination policy to a
#' request, so that [req_perform_opinionated()] can automatically handle
#' pagination.
#'
#' @inheritParams .shared-params
#' @inherit .shared-request return
#' @family opinionated request functions
#' @export
#'
#' @examples
#' req <- httr2::request("https://example.com")
#' req_pagination_policy(req, httr2::iterate_with_offset("page"))
req_pagination_policy <- function(req,
                                  pagination_fn,
                                  call = rlang::caller_env()) {
  pagination_fn <- rlang::as_function(pagination_fn, call = call)
  .req_policy(
    req,
    # I used a list here to allow for future expansion.
    pagination = list(pagination_fn = pagination_fn),
    call = call
  )
}

#' Extract a pagination policy from a request
#'
#' If a request has a pagination policy defined by [req_pagination_policy()],
#' extract the `pagination_fn` from that policy. Otherwise return `NULL`.
#'
#' @inheritParams .shared-params
#'
#' @returns The pagination function, or `NULL`.
#' @export
#'
#' @examples
#' req <- httr2::request("https://example.com")
#' req <- req_pagination_policy(req, httr2::iterate_with_offset("page"))
#' choose_pagination_fn(req)
choose_pagination_fn <- function(req) {
  req$policies$pagination$pagination_fn
}
