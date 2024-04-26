#' Process a path with glue syntax and append it
#'
#' @inheritParams .shared-parameters
#' @param path The route to an API endpoint. Optionally, a list or character
#'   vector with the path as one or more unnamed arguments (which will be
#'   concatenated with "/") plus named arguments to [glue::glue()] into the
#'   path.
#'
#' @inherit .shared-request return
#' @keywords internal
.req_path_append <- function(req, path) {
  .do_if_args_defined(req, .req_path_append_impl, path = path)
}

.req_path_append_impl <- function(req, path) {
  path <- rlang::inject(glue::glue(!!!path, .sep = "/"))
  path <- url_normalize(path)
  req <- httr2::req_url_path_append(req, path)
}
