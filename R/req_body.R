.prepare_body <- function(body,
                          mime_type = NULL) {
  body <- compact_nested_list(body)
  if (purrr::some(body, \(x) inherits(x, "fs_path"))) {
    return(.prepare_body_path(body, mime_type))
  }
  class(body) <- c("json", "list")
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
#' @inheritParams .shared-parameters
#'
#' @inherit httr2::req_body_json return
#' @keywords internal
.req_body_auto <- function(req,
                           body,
                           mime_type = NULL) {
  if (!length(body)) {
    return(req)
  }
  body <- .prepare_body(body, mime_type)
  return(.add_body(req, body))
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
