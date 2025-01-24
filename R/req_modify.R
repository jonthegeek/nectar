#' Modify an API request for a particular endpoint
#'
#' Modify the basic request for an API by adding a path and any other
#' path-specific properties.
#'
#' @inheritParams rlang::args_dots_empty
#' @inheritParams .shared-params
#'
#' @inherit .shared-request return
#' @export
#' @family opinionated request functions
#'
#' @examples
#' req_base <- req_init("https://example.com")
#' req_modify(req_base, path = c("specific/{path}", path = "endpoint"))
#' req_modify(req_base, query = c("param1" = "value1", "param2" = "value2"))
req_modify <- function(req,
                       ...,
                       path = NULL,
                       query = NULL,
                       body = NULL,
                       mime_type = NULL,
                       method = NULL,
                       call = rlang::caller_env()) {
  rlang::check_dots_empty()
  req <- .req_path_append(req, path, call = call)
  req <- .req_query_flatten(req, query)
  req <- .req_body_auto(req, body, mime_type, call = call)
  req <- .req_method_apply(req, method, call = call)
  return(.as_nectar_request(req))
}

#' Process a path with glue syntax and append it
#'
#' @inheritParams .shared-params
#' @inherit .shared-request return
#' @keywords internal
.req_path_append <- function(req, path, call = rlang::caller_env()) {
  .do_if_args_defined(req, .req_path_append_impl, path = path, call = call)
}

.req_path_append_impl <- function(req, path) {
  path <- rlang::inject(glue::glue(!!!path, .sep = "/"))
  path <- .path_merge(path)
  req <- httr2::req_url_path_append(req, path)
}

#' Add non-empty query elements to a request
#'
#' @inheritParams .shared-params
#' @inherit .shared-request return
#' @keywords internal
.req_query_flatten <- function(req,
                               query) {
  query <- purrr::discard(query, is.null)
  rlang::inject(httr2::req_url_query(req, !!!query))
}

#' Add a method if it is supplied
#'
#' [httr2::req_method()] errors if `method` is `NULL`, rather than using the
#' default rules. This function deals with that.
#'
#' @inheritParams .shared-params
#' @inherit .shared-request return
#' @keywords internal
.req_method_apply <- function(req, method, call = rlang::caller_env()) {
  .do_if_args_defined(req, httr2::req_method, method = method, call = call)
}

.prepare_body <- function(body,
                          mime_type = NULL) {
  body <- compact_nested_list(body)
  if (length(body)) {
    if (purrr::some(body, \(x) inherits(x, "fs_path"))) {
      return(.prepare_body_path(body, mime_type))
    }
    class(body) <- c("json", "list")
  }
  return(body)
}

.prepare_body_path <- function(body, mime_type) {
  body <- purrr::map(body, .prepare_body_part, mime_type)
  class(body) <- c("multipart", "list")
  return(body)
}

.prepare_body_part <- function(body_part, mime_type = NULL) {
  if (inherits(body_part, "fs_path")) {
    return(curl::form_file(body_part, type = mime_type))
  }
  return(curl::form_data(
    jsonlite::toJSON(body_part, auto_unbox = TRUE),
    type = "application/json"
  ))
}


#' Send data in request body
#'
#' Automatically choose between [httr2::req_body_json()] and
#' [httr2::req_body_multipart()] based on the content of the body. This is
#' currently experimental and needs to be tested on more APIs.
#'
#' @inheritParams .shared-params
#' @inherit httr2::req_body_json return
#' @keywords internal
.req_body_auto <- function(req,
                           body,
                           mime_type = NULL,
                           call = rlang::caller_env()) {
  body <- .prepare_body(body, mime_type)
  .do_if_args_defined(req, .add_body, body = body, call = call)
}

.add_body <- function(req, body) {
  UseMethod(".add_body", body)
}

#' @export
.add_body.multipart <- function(req, body) {
  return(httr2::req_body_multipart(req, !!!unclass(body)))
}

#' @export
.add_body.json <- function(req, body) {
  return(httr2::req_body_json(req, data = unclass(body)))
}
