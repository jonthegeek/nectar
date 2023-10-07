#' Send a request to an API
#'
#' This function implements an opinionated framework for making API calls. It is
#' intended to be used inside an API client package. It serves as a wrapper
#' around the `req_` family of functions, such as [httr2::request()].
#'
#' @inheritParams .shared-parameters
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
                     response_parser = httr2::resp_body_json,
                     response_parser_args = list(),
                     user_agent = "nectar (https://jonthegeek.github.io/nectar/)") {
  req <- .req_prep(
    base_url = base_url,
    path = path,
    query = query,
    body = body,
    method = method,
    mime_type = mime_type,
    user_agent = user_agent
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
                      user_agent) {
  req <- httr2::request(base_url)
  req <- .req_path_append(req, path)
  req <- .req_query_flatten(req, query)
  req <- .req_body_auto(req, body, mime_type)
  req <- httr2::req_method(req, method)
  if (length(user_agent)) {
    req <- httr2::req_user_agent(req, user_agent)
  }
  return(req)
}

.req_path_append <- function(req, path) {
  if (length(path)) {
    path <- rlang::inject(glue::glue(!!!path))
  }
  return(httr2::req_url_path_append(req, path))
}

.resp_parse <- function(resp, response_parser, response_parser_args) {
  if (length(response_parser)) {
    resp <- .resp_parse_apply(resp, response_parser, response_parser_args)
  }
  return(resp)
}

.resp_parse_apply <- function(resp, response_parser, response_parser_args) {
  return(rlang::inject(response_parser(resp, !!!response_parser_args))) # nocov
}
