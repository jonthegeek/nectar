#' Authenticate with an API key
#'
#' Many APIs provide API keys that can be used to authenticate requests (or,
#' often, provide other information about the user). This function helps to
#' apply those keys to requests.
#'
#' @inheritParams .shared-parameters
#' @param location Where the API key should be passed. One of `"header"`
#'   (default), `"query"`, or `"cookie"`.
#' @param ... Additional parameters depending on the location of the API key.
#'   * `parameter_name` ("header" or "query" only) The name of the parameter to
#'   use in the header or query.
#'   * `api_key` ("header" or "query" only) The API key to use.
#'   * `path` ("cookie" only) The location of the cookie.
#'
#' @inherit .shared-request return
#' @export
security_api_key <- function(req,
                             ...,
                             location = "header") {
  switch(location,
    header = .security_api_key_header(req, ...),
    query = .security_api_key_query(req, ...),
    cookie = .security_api_key_cookie(req, ...) # nocov
  )
}

#' Authenticate with an API key in the header of the request
#'
#' @inheritParams .shared-parameters
#' @param parameter_name The name to use for the API key.
#' @param api_key The API key to use.
#'
#' @inherit .shared-request return
#' @keywords internal
.security_api_key_header <- function(req, ..., parameter_name, api_key) {
  rlang::check_dots_empty()
  if (length(api_key) && nchar(api_key)) {
    req <- httr2::req_headers(
      req,
      !!parameter_name := api_key,
      .redact = parameter_name
    )
  }
  return(req)
}

.security_api_key_query <- function(req, ..., parameter_name, api_key) {
  rlang::check_dots_empty()
  if (length(api_key) && nchar(api_key)) {
    req <- httr2::req_url_query(req, !!parameter_name := api_key)
  }
  return(req)
}

#' Authenticate with an API key in a cookie
#'
#' @inheritParams .shared-parameters
#' @param path The path to the cookie.
#'
#' @inherit .shared-request return
#' @keywords internal
.security_api_key_cookie <- function(req, ..., path) { # nocov start
  if (length(path) && nchar(path)) {
    req <- httr2::req_cookie_preserve(req, path)
  }
  return(req)
} # nocov end
# Not tested yet, because the httr2 feature is in flux.
