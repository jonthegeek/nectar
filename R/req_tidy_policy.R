#' Define a tidy policy for a request
#'
#' API responses generally follow a structured format. Use this function to
#' define a policy that will be used by [resp_tidy()] to extract the relevant
#' portion of a response and wrangle it into a desired format.
#'
#' @inheritParams .shared-params
#' @param tidy_fn A function that will be invoked by [resp_tidy()] to tidy the
#'   response.
#' @param tidy_args A list of additional arguments to pass to `tidy_fn`.
#'
#' @inherit .shared-request return
#' @export
#'
#' @examples
#' req <- httr2::request("https://example.com")
#' req_tidy_policy(req, httr2::resp_body_json, list(simplifyVector = TRUE))
req_tidy_policy <- function(req,
                            tidy_fn = resp_body_auto,
                            tidy_args = list(),
                            call = rlang::caller_env()) {
  tidy_fn <- rlang::as_function(tidy_fn, call = call)
  .req_policy(
    req,
    resp_tidy = list(tidy_fn = tidy_fn, tidy_args = tidy_args),
    call = call
  )
}
