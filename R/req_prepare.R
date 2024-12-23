#' Prepare a request for an API
#'
#' This function implements an opinionated framework for preparing an API
#' request. It is intended to be used inside an API client package. It serves as
#' a wrapper around the `req_` family of functions, such as [httr2::request()].
#'
#' @seealso [req_init()], [req_modify()], and [do_if_fn_defined()] for finer
#'   control of the process.
#'
#' @inheritParams rlang::args_dots_empty
#' @inheritParams .shared-params
#'
#' @inherit .shared-request return
#' @export
req_prepare <- function(base_url,
                        ...,
                        path = NULL,
                        query = NULL,
                        body = NULL,
                        mime_type = NULL,
                        method = NULL,
                        additional_user_agent = NULL,
                        auth_fn = NULL,
                        auth_args = list()) {
  rlang::check_dots_empty()
  req <- req_init(base_url, additional_user_agent = additional_user_agent)
  req <- req_modify(
    req,
    path = path,
    query = query,
    body = body,
    mime_type = mime_type,
    method = method
  )
  req <- do_if_fn_defined(req, auth_fn, !!!auth_args)
  class(req) <- c("nectar_request", class(req))
  return(req)
}
