#' Parameters used in multiple functions
#'
#' Reused parameter definitions are gathered here for easier editing.
#'
#' @param base_url The part of the url that is shared by all calls to the API.
#'   In some cases there may be a family of base URLs, from which you will need
#'   to choose one.
#' @param body An object to use as the body of the request. If any component of
#'   the body is a path, pass it through [fs::path()] or otherwise give it the
#'   class "fs_path" to indicate that it is a path.
#' @param case The case standard to apply. The possible values are
#'   self-descriptive. Defaults to "snake_case".
#' @param depth The current recursion depth.
#' @param method If the method is something other than GET or POST, supply it.
#'   Case is ignored.
#' @param mime_type A character scalar indicating the mime type of any files
#'   present in the body. Some APIs allow you to leave this as NULL for them to
#'   guess.
#' @param path The route to an API endpoint. Optionally, a list with the path
#'   plus variables to [glue::glue()] into the path.
#' @param query An optional list of parameters to pass in the query portion of
#'   the request.
#' @param req An [httr2::request()] object.
#' @param security_fn A function to use to authenticate the request. By default
#'   (`NULL`), no authentication is performed.
#' @param security_args An optional list of arguments to the `security_fn`
#'   function.
#' @param user_agent A string to identify where this request is coming from.
#'   It's polite to set the user agent to identify your package, such as
#'   "MyPackage (https://mypackage.com)".
#' @param x The object to update.
#'
#' @importFrom fs path
#'
#' @name .shared-parameters
#' @keywords internal
NULL

#' Returns from request functions
#'
#' @return An [httr2::request()] object.
#' @name .shared-request
#' @keywords internal
NULL
