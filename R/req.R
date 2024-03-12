#' Prepare a request for an API
#'
#' This function implements an opinionated framework for preparing an API
#' request. It is intended to be used inside an API client package. It serves as
#' a wrapper around the `req_` family of functions, such as [httr2::request()].
#'
#' @inheritParams .shared-parameters
#' @inheritParams rlang::args_dots_empty
#'
#' @return A [httr2::request()] object.
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
  req <- httr2::request(base_url)
  req <- .req_path_append(req, path)
  req <- .req_query_flatten(req, query)
  req <- .req_body_auto(req, body, mime_type)
  req <- .req_method_apply(req, method)
  req <- .req_user_agent_apply(req, user_agent)
  return(req)
}

.req_path_append <- function(req, path) {
  if (length(path)) {
    path <- rlang::inject(glue::glue(!!!path))
  }
  return(httr2::req_url_path_append(req, path))
}

.req_method_apply <- function(req, method) {
  if (!length(method)) {
    # I'm pretty sure this is a current httr2 or httptest2 bug. NULL methods
    # fail during testing.
    if (length(req$body)) {
      method <- "POST"
    } else {
      method <- "GET"
    }
  }
  return(httr2::req_method(req, method))
}

.req_user_agent_apply <- function(req, user_agent) {
  if (length(user_agent)) {
    req <- httr2::req_user_agent(req, user_agent)
  }
  return(req)
}
