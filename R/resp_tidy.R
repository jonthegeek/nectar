#' Extract and clean an API response
#'
#' API responses generally follow a structured format. Use this function to
#' extract the relevant portion of a response, and wrangle it into a desired
#' format. This function is most useful when the response was fetched with a
#' request that includes a tidying policy defined via [req_tidy_policy()].
#'
#' @inheritParams .shared-params
#'
#' @returns The extracted and cleaned response, or, for a list of responses,
#'   those responses cleaned then concatenated via [httr2::resps_data()]. By
#'   default, the response is processed with [resp_body_auto()].
#'
#' @seealso [resp_tidy_json()] for an opinionated response parser for JSON
#'   responses, [resp_body_auto()] (etc) for a family of response parsers that
#'   attempts to automatically select the appropriate parser based on the
#'   response content type, [httr2::resp_body_raw()] (etc) for the underlying
#'   httr2 response parsers, and [resp_parse()] for an alternative approach to
#'   dealing with responses (particularly useful if the request does not include
#'   a `resp_tidy` policy).
#' @export
resp_tidy <- function(resps) {
  UseMethod("resp_tidy")
}

#' @export
resp_tidy.httr2_response <- function(resps) {
  # TODO: Replace this with httr2::resp_request() after
  # https://github.com/r-lib/httr2/pull/615
  req <- resps$request
  if (length(req$policies$resp_tidy)) {
    return(
      rlang::exec(
        req$policies$resp_tidy$tidy_fn,
        resps,
        !!!req$policies$resp_tidy$tidy_args
      )
    )
  }
  resp_body_auto(resps)
}

#' @export
resp_tidy.nectar_responses <- function(resps) {
  httr2::resps_data(resps, resp_tidy)
}

#' @export
resp_tidy.list <- function(resps) {
  if (length(resps) && inherits(resps[[1]], "httr2_response")) {
    class(resps) <- c("nectar_responses", "list")
    return(resp_tidy(resps))
  }
  .nectar_abort(
    c(
      "No method is available to {.fn nectar::resp_tidy} this object.",
      i = "You might want to try {.fn nectar::resp_parse} instead."
    ),
    "unsupported_response_class"
  )
}

#' @export
resp_tidy.default <- function(resps) {
  .nectar_abort(
    c(
      "No method is available to {.fn nectar::resp_tidy} this object.",
      i = "{.fn nectar::resp_tidy} expects {.cls httr2_response} objects, or lists thereof."
    ),
    "unsupported_response_class"
  )
}
