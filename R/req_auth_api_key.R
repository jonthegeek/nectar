#' Authenticate with an API key
#'
#' Many APIs provide API keys that can be used to authenticate requests (or,
#' often, provide other information about the user). This function helps to
#' apply those keys to requests.
#'
#' @inheritParams .shared-params
#' @inheritParams rlang::args_dots_empty
#' @param parameter_name (`length-1 character`) The name of the parameter to use
#'   in the header, query, or cookie.
#' @param api_key (`length-1 character` or `NULL`) The API key to use. If this
#'   value is `NULL`, `req` is returned unchanged.
#' @param location (`length-1 character`) Where the API key should be passed.
#'   One of `"header"` (default), `"query"`, or `"cookie"`.
#'
#' @inherit .shared-request return
#' @export
req_auth_api_key <- function(req,
                             parameter_name,
                             ...,
                             api_key = NULL,
                             location = c("header", "query", "cookie"),
                             call = rlang::caller_env()) {
  rlang::check_dots_empty(call = call)
  parameter_name <- stabilize_string(parameter_name, call = call)
  api_key <- stbl::to_chr_scalar(api_key, call = call)
  # Return without failing if api_key isn't set. This makes it easier to set up
  # APIs that change behavior when an API key is set, without failing when it
  # isn't.
  if (length(api_key) && nchar(api_key)) {
    location <- rlang::arg_match(location, error_call = call)
    req_api_key_set <- switch(
      location,
      header = httr2::req_headers_redacted,
      query = httr2::req_url_query,
      cookie = httr2::req_cookies_set
    )
    req <- rlang::exec(req_api_key_set, req, !!parameter_name := api_key)
  }
  return(req)
}
