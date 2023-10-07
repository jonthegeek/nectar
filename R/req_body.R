#' Prepare the body of a request
#'
#' @inheritParams .shared-parameters
#'
#' @return A prepared body list object with a "json" or "multipart" subclass.
#' @keywords internal
.prepare_body <- function(body,
                          mime_type = NULL) {
  body <- compact_nested_list(body)

  if (purrr::some(body, \(x) inherits(x, "fs_path"))) {
    body <- purrr::map(body, .prepare_body_part, mime_type)
    class(body) <- c("multipart", "list")
    return(body)
  } else {
    class(body) <- c("json", "list")
    return(body)
  }
}

#' Prepare a multipart body part
#'
#' @param body_part One piece of a multipart body.
#' @inheritParams .shared-parameters
#'
#' @return A character or raw vector to post.
#' @keywords internal
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
#' @export
req_body_auto <- function(req,
                          body,
                          mime_type = NULL) {
  if (rlang::is_null(body)) {
    return(req)
  }

  body <- .prepare_body(body, mime_type)
  return(.add_body(req, body))
}

#' Add the body to the request
#'
#' @inheritParams .shared-parameters
#'
#' @return The request with the body appropriately added.
#' @keywords internal
.add_body <- function(req, body) {
  UseMethod(".add_body", body)
}


#' @export
.add_body.multipart <- function(req, body) {
  return(
    httr2::req_body_multipart(
      req,
      !!!unclass(body)
    )
  )
}

#' @export
.add_body.json <- function(req, body) {
  return(
    httr2::req_body_json(
      req,
      data = unclass(body)
    )
  )
}
