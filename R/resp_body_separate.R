#' Extract response body into list
#'
#' @inheritParams .shared-params
#'
#' @returns The parsed response body wrapped in a [list()]. This is useful for
#'   things like raw vectors that you wish to parse with [httr2::resps_data()].
#' @export
resp_body_separate <- function(resp, resp_body_fn = resp_body_auto) {
  list(resp_body_fn(resp))
}
