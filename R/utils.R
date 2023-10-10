#' Discard empty elements
#'
#' Discard empty elements in nested lists.
#'
#' @inheritParams .compact_nested_list_impl
#'
#' @inherit .compact_nested_list_impl return
#' @export
#' @examples
#' x <- list(
#'   a = list(
#'     b = letters,
#'     c = NULL,
#'     d = 1:5
#'   ),
#'   e = NULL,
#'   f = 1:3
#' )
#' compact_nested_list(x)
compact_nested_list <- function(lst) {
  return(.compact_nested_list_impl(lst))
}

#' Discard empty elements
#'
#' @param lst A (nested) list to filter.
#' @inheritParams .shared-parameters
#'
#' @return The list, minus empty elements and branches.
#' @keywords internal
.compact_nested_list_impl <- function(lst, depth = 1L) {
  if (is.list(lst) && depth < 20L) {
    lst <- purrr::map(lst, .compact_nested_list_impl, depth = depth + 1L)
  }
  return(purrr::compact(lst))
}
