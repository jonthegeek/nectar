#' Add non-empty query elements to a request
#'
#' @inheritParams .shared-parameters
#' @param query An optional list or character vector of parameters to pass in
#'   the query portion of the request. Can also include a `.multi` argument to
#'   pass to [httr2::req_url_query()] to control how elements containing
#'   multiple values are handled.
#'
#' @inherit .shared-request return
#' @keywords internal
.req_query_flatten <- function(req,
                               query) {
  query <- purrr::discard(query, is.null)
  rlang::inject(httr2::req_url_query(req, !!!query))
}
