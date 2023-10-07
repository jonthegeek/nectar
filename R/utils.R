#' Coerce to comma-separated scalar
#'
#' Collapse character-like objects to a single comma-separated value. All `NULL`
#' and `NA` values are removed, and lists are flattened.
#'
#' @param ... One or more character vectors (or things that can be
#'   coerced/flattened to character vectors) to collapse.
#' @return A character scalar like "this,that".
#' @export
#' @examples
#' to_csv_scalar(letters)
#' to_csv_scalar(NA, "a", list(a = NULL, b = "b"), "c")
to_csv_scalar <- function(...) {
  x <- unlist(list(...))
  return(paste(x[!is.na(x)], collapse = ","))
}

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
    lst <- purrr::map(
      lst, .compact_nested_list_impl,
      depth = depth + 1L
    )
  }
  return(purrr::compact(lst))
}

#' Convert strings to lowercase without underscore
#'
#' @inheritParams .shared-parameters
#'
#' @return The string, lowercase, with underscores removed.
#' @keywords internal
.to_lower_snakeless <- function(x) {
  return(gsub("_", "", tolower(x)))
}

#' Convert strings to uppercase without underscore
#'
#' @inheritParams .shared-parameters
#'
#' @return The string, uppercase, with underscores removed.
#' @keywords internal
.to_upper_snakeless <- function(x) {
  return(gsub("_", "", toupper(x)))
}
