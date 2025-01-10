#' Extract tabular data from response body
#'
#' Extract tabular data in comma-separated or tab-separated format from a
#' response body.
#'
#' @inheritParams .shared-params
#'
#' @returns The parsed response body as a data frame.
#' @export
resp_body_csv <- function(resp, check_type = TRUE) {
  httr2::resp_check_content_type(
    resp,
    valid_types = "text/csv",
    valid_suffix = "csv",
    check_type = check_type
  )
  utils::read.csv(text = httr2::resp_body_string(resp))
}

#' @rdname resp_body_csv
#' @export
resp_body_tsv <- function(resp, check_type = TRUE) {
  httr2::resp_check_content_type(
    resp,
    valid_types = "text/tab-separated-values",
    valid_suffix = "tsv",
    check_type = check_type
  )
  utils::read.delim(text = httr2::resp_body_string(resp))
}
