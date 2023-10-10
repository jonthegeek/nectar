#' Send a request to an API
#'
#' This function implements an opinionated framework for making API calls. It is
#' intended to be used inside an API client package. It serves as a wrapper
#' around the `req_` family of functions, such as [httr2::request()].
#'
#' @inheritParams .shared-parameters
#' @param security_fn A function to use to authenticate the request. By default
#'   (`NULL`), no authentication is performed.
#' @param security_args An optional list of arguments to the `security_fn`
#'   function.
#' @param response_parser A function to use to parse the server response.
#'   Defaults to [httr2::resp_body_json()], since JSON responses are common. Set
#'   this to `NULL` to return the raw response from [httr2::req_perform()].
#' @param response_parser_args An optional list of arguments to the
#'   `response_parser` function.
#'
#' @return The response from the API, parsed by the `response_parser`.
#' @export
call_api <- function(base_url,
                     path = NULL,
                     query = NULL,
                     body = NULL,
                     mime_type = NULL,
                     method = NULL,
                     security_fn = NULL,
                     security_args = list(),
                     response_parser = httr2::resp_body_json,
                     response_parser_args = list(),
                     user_agent = "nectar (https://nectar.api2r.org)") {
  req <- .req_prep(
    base_url = base_url,
    path = path,
    query = query,
    body = body,
    method = method,
    mime_type = mime_type,
    user_agent = user_agent,
    security_fn = security_fn,
    security_args = security_args
  )
  resp <- .resp_get(req)
  resp <- .resp_parse(resp, response_parser, response_parser_args)
  return(resp)
}

.resp_get <- function(req) {
  return(httr2::req_perform(req)) # nocov
}

.req_prep <- function(base_url,
                      path,
                      query,
                      body,
                      method,
                      mime_type,
                      user_agent,
                      security_fn,
                      security_args) {
  req <- httr2::request(base_url)
  req <- .req_path_append(req, path)
  req <- .req_query_flatten(req, query)
  req <- .req_body_auto(req, body, mime_type)
  req <- .req_method_apply(req, method)
  req <- .req_user_agent_apply(req, user_agent)
  req <- .req_security_apply(req, security_fn, security_args)
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

.req_security_apply <- function(req, security_fn, security_args) {
  if (length(security_fn)) {
    req <- rlang::inject(
      security_fn(req, !!!security_args)
    )
  }
  return(req)
}

.resp_parse <- function(resp, response_parser, response_parser_args) {
  if (length(response_parser)) {
    resp <- .resp_parse_apply(
      resp,
      response_parser,
      response_parser_args
    )
  }
  return(resp)
}

.resp_parse_apply <- function(resp, response_parser, response_parser_args) {
  return(rlang::inject(response_parser(resp, !!!response_parser_args))) # nocov
}
