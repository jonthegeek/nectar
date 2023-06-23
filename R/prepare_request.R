#' Combine request pieces
#'
#' @inheritParams .shared-parameters
#'
#' @inherit .shared-request return
#' @keywords internal
.prepare_request <- function(base_url,
                             endpoint,
                             query = NULL,
                             body = NULL,
                             method = NULL,
                             api_case = c(
                               "snake_case", "camelCase", "UpperCamel",
                               "SCREAMING_SNAKE", "alllower",
                               "ALLUPPER", "lowerUPPER", "UPPERlower",
                               "Sentence case", "Title Case"
                             ),
                             mime_type = NULL) {
  # Path.
  req <- httr2::request(base_url)
  endpoint <- rlang::inject(glue::glue(!!!endpoint))
  req <- httr2::req_url_path_append(req, endpoint)
  # TODO: If query contains an element with length > 1, to_csv_scalar it (after
  # smushing it). Basically do a lot of what I do to bodies.
  req <- httr2::req_url_query(req, !!!query)
  req <- req_body_auto(req, body, api_case, mime_type)
  if (!rlang::is_null(method)) {
    req <- httr2::req_method(req, method)
  }

  return(req)
}
