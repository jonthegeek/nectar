#' Iteration helper for json cursors
#'
#' This function is intended as a replacement for [httr2::iterate_with_cursor()]
#' for the common situation where the response body is json, and the cursor can
#' be "empty" in various ways. Even within a single API, some endpoints might
#' return a `NULL` `next_cursor` to indicate that there are no more pages of
#' results, while other endpoints might return `""`. This function normalizes
#' all such results to `NULL`.
#'
#' @param param_name (`length-1 character`) The name of the `cursor` parameter
#'   in the request.
#' @param next_cursor_path (`character`) A vector indicating the path to the
#'   `next_cursor` element in the body of the response. For example, for the
#'   [Slack API](https://api.slack.com/apis/pagination), this value is
#'   `c("response_metadata", "next_cursor")`, while for the [Crossref Unified
#'   Resource API](https://api.crossref.org/swagger-ui/index.html), this value
#'   is `"next-cursor"`.
#'
#' @returns A function that takes the response and the previous request, and
#'   returns the next request if there are more results.
#' @export
iterate_with_json_cursor <- function(param_name = "cursor",
                                     next_cursor_path) {
  httr2::iterate_with_cursor(
    param_name = param_name,
    resp_param_value = .next_cursor_finder(
      next_cursor_path,
      httr2::resp_body_json
    )
  )
}

#' Cursor finder factory
#'
#' @inheritParams iterate_with_json_cursor
#' @inheritParams .shared-params
#'
#' @returns A function that returns the next cursor, or `NULL` if the next
#'   cursor is `NULL` (or otherwise length-0) or `""`.
#' @keywords internal
.next_cursor_finder <- function(next_cursor_path,
                                resp_body_fn = resp_body_auto) {
  force(next_cursor_path)
  function(resp) {
    cursor <- purrr::pluck(resp_body_fn(resp), !!!next_cursor_path)
    if (!length(cursor) || identical(cursor, "")) {
      cursor <- NULL
    }
    return(cursor)
  }
}
