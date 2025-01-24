#' Setup a basic API request
#'
#' For a given API, the `base_url` and user agent will generally be the same for
#' every call to that API. Use this function to prepare that piece of the
#' request once for easy reuse.
#'
#' @inheritParams rlang::args_dots_empty
#' @inheritParams .shared-params
#' @inherit .shared-request return
#' @family opinionated request functions
#' @export
#'
#' @examples
#' req_init("https://example.com")
#' req_init(
#'   "https://example.com",
#'   additional_user_agent = "my_api_client (https://my.api.client)"
#' )
req_init <- function(base_url,
                     ...,
                     additional_user_agent = NULL,
                     call = rlang::caller_env()) {
  req <- httr2::request(base_url)
  req <- httr2::req_user_agent(req, additional_user_agent)
  req <- req_pkg_user_agent(req, call = call)
  return(.as_nectar_request(req))
}
