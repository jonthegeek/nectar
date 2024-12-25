#' Automatically choose a body parser
#'
#' Use the `Content-Type` header (extracted using [httr2::resp_content_type()])
#' of a response to automatically choose and apply a body parser, such as
#' [httr2::resp_body_json()] or [resp_body_csv()].
#'
#' @inheritParams .shared-params
#'
#' @returns The parsed response body.
#' @export
resp_body_auto <- function(resp) {
  content_type <- httr2::resp_content_type(resp)
  switch(
    content_type,
    "application/json" = httr2::resp_body_json(resp),
    "application/xml" = httr2::resp_body_xml(resp),
    "text/xml" = httr2::resp_body_xml(resp),
    "application/xhtml+xml" = httr2::resp_body_html(resp),
    "text/html" = httr2::resp_body_html(resp),
    "text/csv" = resp_body_csv(resp),
    "text/tab-separated-values" = resp_body_tsv(resp),
    "image/svg+xml" = httr2::resp_body_string(resp),
    .resp_body_auto_other(resp)
  )
}

#' Automatically choose more body parsers
#'
#' This helper function exists to find somewhat variable content types and
#' attempt to send them to the proper body parser.
#'
#' @inheritParams .shared-params
#' @inherit resp_body_auto return
#' @keywords internal
.resp_body_auto_other <- function(resp) {
  content_type <- httr2::resp_content_type(resp)
  if (grepl("application/(.*)\\+json", content_type)) {
    return(httr2::resp_body_json(resp))
  }
  if (grepl("text/(.*)", content_type)) {
    return(httr2::resp_body_string(resp))
  }
  return(httr2::resp_body_raw(resp))
}
