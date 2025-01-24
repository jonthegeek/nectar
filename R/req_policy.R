#' Apply policies to a request
#'
#' This function is based on the unexported `req_policies()` function from
#' httr2. It is used to apply policies to a request object. I don't currently
#' export this function, but that may change in the future.
#'
#' @inheritParams .shared-params
#' @param ...
#'
#' @inherit .shared-request return
#' @keywords internal
.req_policy <- function(req, ..., call = rlang::caller_env()) {
  dots <- rlang::list2(...)
  if (!length(dots)) {
    return(.as_nectar_request(req))
  }
  if (!rlang::is_named(dots)) {
    .nectar_abort(
      "All components of {.arg ...} must be named.",
      "bad_policy",
      call = call
    )
  }
  req$policies <- req$policies[!names(req$policies) %in% names(dots)]
  req$policies <- c(req$policies, Filter(length, dots))
  if (!length(req$policies)) {
    names(req$policies) <- NULL
  }
  return(.as_nectar_request(req))
}
