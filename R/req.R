#' Setup a basic API request
#'
#' For a given API, the `base_url` and `user_agent` will almost always be the
#' same. Use this function to prepare that piece of the request once for easy
#' reuse.
#'
#' @inheritParams rlang::args_dots_empty
#' @param base_url The part of the url that is shared by all calls to the API.
#'   In some cases there may be a family of base URLs, from which you will need
#'   to choose one.
#' @param user_agent A string to identify where this request is coming from.
#'   It's polite to set the user agent to identify your package, such as
#'   "MyPackage (https://mypackage.com)".
#'
#' @inherit .shared-request return
#' @export
#'
#' @examples
#' req_setup("https://example.com")
#' req_setup(
#'   "https://example.com",
#'   user_agent = "my_api_client (https://my.api.client)"
#' )
req_setup <- function(base_url,
                      ...,
                      user_agent = "nectar (https://nectar.api2r.org)") {
  req <- httr2::request(base_url)
  req <- httr2::req_user_agent(req, user_agent)
  return(req)
}

#' Modify an API request for a particular endpoint
#'
#' Modify the basic request for an API by adding a path and any other
#' path-specific properties.
#'
#' @inheritParams rlang::args_dots_empty
#' @inheritParams .req_path_append
#' @inheritParams .req_body_auto
#' @inheritParams .req_method_apply
#' @inheritParams .req_query_flatten
#'
#' @inherit .shared-request return
#' @export
#'
#' @examples
#' req_base <- req_setup(
#'   "https://example.com",
#'   user_agent = "my_api_client (https://my.api.client)"
#' )
#' req <- req_modify(req_base, path = c("specific/{path}", path = "endpoint"))
#' req
#' req <- req_modify(req, query = c("param1" = "value1", "param2" = "value2"))
#' req
req_modify <- function(req,
                       ...,
                       path = NULL,
                       query = NULL,
                       body = NULL,
                       mime_type = NULL,
                       method = NULL) {
  rlang::check_dots_empty()
  req <- .req_path_append(req, path)
  req <- .req_query_flatten(req, query)
  req <- .req_body_auto(req, body, mime_type)
  req <- .req_method_apply(req, method)
  return(req)
}

#' Prepare a request for an API
#'
#' This function implements an opinionated framework for preparing an API
#' request. It is intended to be used inside an API client package. It serves as
#' a wrapper around the `req_` family of functions, such as [httr2::request()].
#'
#' @inheritParams req_setup
#' @inheritParams req_modify
#' @inheritParams rlang::args_dots_empty
#'
#' @inherit .shared-request return
#' @export
req_prepare <- function(base_url,
                        ...,
                        path = NULL,
                        query = NULL,
                        body = NULL,
                        mime_type = NULL,
                        method = NULL,
                        user_agent = "nectar (https://nectar.api2r.org)") {
  rlang::check_dots_empty()
  req <- req_setup(base_url, user_agent = user_agent)
  req <- req_modify(
    req,
    path = path,
    query = query,
    body = body,
    mime_type = mime_type,
    method = method
  )
  return(req)
}
