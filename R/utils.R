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

#' Apply a case standard to all names of an object
#'
#' Standardize the names of an object to follow a case standard, such as
#' "snake_case" (lowercase, words separated by "_") or "camelCase" (first letter
#' lowercase, first letter of subsequent words uppercase). Resulting objects are
#' identical to input objects, but with names standardized to the given case.
#'
#' @inheritParams .shared-parameters
#'
#' @inherit .enforce_name_case_impl return
#' @export
#' @examples
#' x <- list(
#'   fiRsT_laBel = c(firsT_Label_1 = 1, firsT_Label_2 = 2), SECond_labEL = 3
#' )
#' enforce_name_case(x, "snake_case")
#' enforce_name_case(x, "camelCase")
#' enforce_name_case(x, "UpperCamel")
#' enforce_name_case(x, "SCREAMING_SNAKE")
enforce_name_case <- function(x,
                              case = c(
                                "snake_case", "camelCase", "UpperCamel",
                                "SCREAMING_SNAKE", "alllower",
                                "ALLUPPER", "lowerUPPER", "UPPERlower",
                                "Sentence case", "Title Case"
                              )) {
  if (missing(case)) {
    case <- "snake_case"
  }
  case <- tolower(case)
  case <- rlang::arg_match(
    case,
    values = c(
      "snake_case", "camelcase", "uppercamel", "screaming_snake", "alllower",
      "allupper", "lowerupper", "upperlower", "sentence case", "title case"
    )
  )
  case_function <- switch(
    case,
    "snake_case" = snakecase::to_snake_case,
    "camelcase" = snakecase::to_lower_camel_case,
    "uppercamel" = snakecase::to_upper_camel_case,
    "screaming_snake" = snakecase::to_screaming_snake_case,
    "alllower" = .to_lower_snakeless,
    "allupper" = .to_upper_snakeless,
    "lowerupper" = snakecase::to_lower_upper_case,
    "upperlower" = snakecase::to_upper_lower_case,
    "sentence case" = snakecase::to_sentence_case,
    "title case" = snakecase::to_title_case
  )
  return(.enforce_name_case_impl(x, case_function))
}

#' Apply a case standard to all names of an object
#'
#' @param case_function The function to apply.
#' @inheritParams .shared-parameters
#'
#' @return The input object with all names converted to the specified case
#'   standard.
#' @keywords internal
.enforce_name_case_impl <- function(x,
                                    case_function,
                                    depth = 1L) {
  if (length(x) && depth < 20L) {
    for (i in seq_along(x)) {
      x[[i]] <- .enforce_name_case_impl(x[[i]], case_function, depth + 1L)
    }
  }
  if (rlang::is_named(x)) {
    names(x) <- case_function(names(x))
  }
  return(x)
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
