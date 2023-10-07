#' Combine request pieces
#'
#' @inheritParams .shared-parameters
#'
#' @inherit .shared-request return
#' @keywords internal
.prepare_request <- function(base_url,
                             path = NULL,
                             query = NULL,
                             body = NULL,
                             method = NULL,
                             mime_type = NULL,
                             user_agent = NULL) {
  req <- httr2::request(base_url)

  if (length(path)) {
    path <- rlang::inject(glue::glue(!!!path))
    req <- httr2::req_url_path_append(req, path)
  }

  if (length(query)) {
    # TODO: If query contains an element with length > 1, to_csv_scalar it
    # (after smushing it). Basically do a lot of what I do to bodies.
    req <- httr2::req_url_query(req, !!!query)
  }
  req <- req_body_auto(req, body, mime_type)
  if (length(method)) {
    req <- httr2::req_method(req, method)
  }
  if (length(user_agent)) {
    req <- httr2::req_user_agent(req, user_agent)
  }

  return(req)
}
