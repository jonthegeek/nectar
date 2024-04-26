#' Add a method if it is supplied
#'
#' [httr2::req_method()] errors if `method` is `NULL`, rather than using the
#' default rules. This function deals with that.
#'
#' @inheritParams .shared-parameters
#' @param method If the method is something other than GET or POST, supply it.
#'   Case is ignored.
#'
#' @inherit .shared-request return
#' @keywords internal
.req_method_apply <- function(req, method) {
  .do_if_args_defined(req, httr2::req_method, method = method)
}
