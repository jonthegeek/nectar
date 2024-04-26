# compact_nested_list ----------------------------------------------------------

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
#' @param depth The current recursion depth.
#'
#' @return The list, minus empty elements and branches.
#' @keywords internal
.compact_nested_list_impl <- function(lst, depth = 1L) {
  if (is.list(lst) && depth < 20L) {
    lst <- purrr::map(lst, .compact_nested_list_impl, depth = depth + 1L)
  }
  return(purrr::compact(lst))
}

# urls -------------------------------------------------------------------------

#' Add path elements to a URL
#'
#' Append zero or more path elements to a URL without duplicating "/"
#' characters. Based on [httr2::req_url_path_append()].
#'
#' @param url A URL to modify.
#' @param ... Path elements to append, as strings.
#'
#' @return A modified URL.
#' @export
#'
#' @examples
#' url_path_append("https://example.com", "api", "v1", "users")
#' url_path_append("https://example.com/", "/api", "/v1", "/users")
#' url_path_append("https://example.com/", "/api/v1/users")
url_path_append <- function(url, ...) {
  url <- httr2::url_parse(url)
  url$path <- .path_merge(url$path, ...)
  return(httr2::url_build(url))
}

#' Normalize a URL
#'
#' This function normalizes a URL by adding a trailing slash to the base if it
#' is missing. It is mainly for testing and other comparisons.
#'
#' @param url A URL to normalize.
#'
#' @return A normalized URL
#' @export
#'
#' @examples
#' identical(
#'   url_normalize("https://example.com"),
#'   url_normalize("https://example.com/")
#' )
#' identical(
#'   url_normalize("https://example.com?param=value"),
#'   url_normalize("https://example.com/?param=value")
#' )
url_normalize <- function(url) {
  url_path_append(url)
}

.path_merge <- function(...) {
  path <- paste(c(...), collapse = "/")
  path <- sub("^([^/])", "/\\1", path)
  path <- gsub("/+", "/", path)
  return(sub("/$", "", path))
}

# Do if ------------------------------------------------------------------------

#' Use a provided function
#'
#' When constructing API calls programmatically, you may encounter situations
#' where an upstream task should indicate which function to apply. For example,
#' one endpoint might use a special security function that isn't used by other
#' endpoints. This function exists to make coding such situations easier.
#'
#' @param x An object to potentially modify, such as a [httr2::request()]
#'   object.
#' @param fn A function to apply to `x`. If `fn` is `NULL`, `x` is returned
#'   unchanged.
#' @param ... Additional arguments to pass to `fn`.
#'
#' @return The object, potentially modified.
#' @export
#'
#' @examples
#' build_api_req <- function(endpoint, security_fn = NULL, ...) {
#'   req <- httr2::request("https://example.com")
#'   req <- httr2::req_url_path_append(req, endpoint)
#'   do_if_fn_defined(req, security_fn, ...)
#' }
#'
#' # Most endpoints of this API do not require authentication.
#' unsecure_req <- build_api_req("unsecure_endpoint")
#' unsecure_req$headers
#'
#' # But one endpoint requires
#' secure_req <- build_api_req(
#'   "secure_endpoint", httr2::req_auth_bearer_token, "secret-token"
#' )
#' secure_req$headers$Authorization
do_if_fn_defined <- function(x, fn = NULL, ...) {
  if (is.function(fn)) {
    # Higher-level calls can include !!!'ed arguments.
    dots <- rlang::list2(...)
    x <- rlang::inject(fn(x, !!!dots))
  }
  return(x)
}

#' Use a function if args are provided
#'
#' @param x An object to potentially modify, such as a [httr2::request()]
#'   object.
#' @param fn A function to apply to `x`. If `fn` is `NULL`, `x` is returned
#'   unchanged.
#' @param ... Additional arguments to pass to `fn`.
#'
#' @return The object, potentially modified.
#' @keywords internal
.do_if_args_defined <- function(x, fn = NULL, ...) {
  if (is.function(fn)) {
    dots <- rlang::list2(...)
    dots <- purrr::discard(dots, is.null)
    if (length(dots)) {
      x <- rlang::inject(fn(x, !!!dots))
    }
  }
  return(x)
}
