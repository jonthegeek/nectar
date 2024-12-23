#' Parameters used in multiple functions
#'
#' Reused parameter definitions are gathered here for easier editing.
#'
#' @param additional_user_agent (`length-1 character`) A string to identify
#'   where a request is coming from. We automatically include information about
#'   your package and nectar, but use this to provide additional details.
#'   Default `NULL`.
#' @param api_key (`length-1 character`) The API key to use.
#' @param arg (`length-1 character`) An argument name as a string. This argument
#'   will be mentioned in error messages as the input that is at the origin of a
#'   problem.
#' @param auth_args (`list`) An optional list of arguments to the `auth_fn`
#'   function.
#' @param auth_fn (`function`) A function to use to authenticate the request. By
#'   default (`NULL`), no authentication is performed.
#' @param base_url (`length-1 character`) The part of the url that is shared by
#'   all calls to the API. In some cases there may be a family of base URLs,
#'   from which you will need to choose one.
#' @param body (multiple types) An object to use as the body of the request. If
#'   any component of the body is a path, pass it through [fs::path()] or
#'   otherwise give it the class "fs_path" to indicate that it is a path.
#' @param call  (`environment`) The environment from which a function was
#'   called, e.g. [rlang::caller_env()] (the default). The environment will be
#'   mentioned in error messages as the source of the error. This argument is
#'   particularly useful for functions that are intended to be called as
#'   utilities inside other functions.
#' @param existing_user_agent (`length-1 character`, optional) An existing user
#'   agent, such as the value of `req$options$useragent` in a [httr2::request()]
#'   object.
#' @param method (`length-1 character`, optional) If the method is something
#'   other than `GET` or `POST`, supply it. Case is ignored.
#' @param mime_type (`length-1 character`) The mime type of any files present in
#'   the body. Some APIs allow you to leave this as NULL for them to guess.
#' @param name (`length-1 character`) The name of a package or other thing to
#'   add to or remove from the user agent string.
#' @param pkg_name (`length-1 character`) The name of the calling package. This
#'   will usually be automatically determined based on the source of the call.
#' @param pkg_url (`length-1 character`) A url for information about the calling
#'   package (default `NULL`).
#' @param parameter_name (`length-1 character`) The name to use for the API key.
#' @param path (`character` or `list`) The route to an API endpoint. Optionally,
#'   a list or character vector with the path as one or more unnamed arguments
#'   (which will be concatenated with "/") plus named arguments to
#'   [glue::glue()] into the path.
#' @param query (`character` or `list`) An optional list or character vector of
#'   parameters to pass in the query portion of the request. Can also include a
#'   `.multi` argument to pass to [httr2::req_url_query()] to control how
#'   elements containing multiple values are handled.
#' @param req (`httr2_request`) A [httr2::request()] object.
#' @param resp (`httr2_response` or `list`) A single [httr2::response()] object
#'   (as returned by [httr2::req_perform()]) or a list of such objects (as
#'   returned by [httr2::req_perform_iterative()]).
#' @param response_parser (`function`) A function to parse the server response
#'   (`resp`). Defaults to [httr2::resp_body_json()], since JSON responses are
#'   common. Set this to `NULL` to return the raw response from
#'   [httr2::req_perform()].
#' @param response_parser_args (`list`) An optional list of arguments to pass to
#'   the `response_parser` function (in addition to `resp`).
#' @param url (`length-1 character`) An optional url associated with `name`.
#' @param version (`length-1 character`) The version of `name`.
#' @param x (multiple types) The object to update.
#' @param ... These dots are for future extensions and must be empty.
#'
#' @name .shared-params
#' @keywords internal
NULL

#' Returns from request functions
#'
#' @return A [httr2::request()] object.
#' @name .shared-request
#' @keywords internal
NULL
