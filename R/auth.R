#' OAuth parameters
#'
#' These parameters are used in multiple authentication functions. We define
#' them here so they're consistent.
#'
#' @param api_token_url The URL to retrieve an access token from this API as
#'   part of the OAuth flow.
#' @param cache_disk Should the access token be cached on disk? Cached tokens
#'   are encrypted and automatically deleted 30 days after creation. See
#'   [httr2::req_oauth_auth_code()].
#' @param cache_key If you are authenticating with multiple users using the same
#'   client, use this key to differentiate between those users.
#' @param client_id An OAuth App client ID. We recommend you have your users
#'   save it as an environment variable, `YOUR_API_CLIENT_ID`.
#' @param client_secret A Zoom OAuth App client secret. We recommend you have
#'   your users save it as an environment variable, `YOUR_API_CLIENT_SECRET`.
#' @param force A logical indicating whether to force a refresh of the token.
#' @param refresh_token A refresh token associated with this `client`.
#' @param request A [httr2::request()].
#' @param scopes A character vector of allowed scopes.
#' @param token An API [httr2::oauth_token()].
#'
#' @name .oauth-parameters
#' @keywords internal
NULL

#' Visit an OAuth client management page
#'
#' Open a url in an HTML browser. This is a thin wrapper around
#' [`utils::browseURL()`].
#'
#' @param app_mgmt_url The page where the client can be managed.
#' @return The `app_mgmt_url`, invisibly.
#' @export
#' @examples
#' api_browse_oauth_app("https://example.com")
api_browse_oauth_app <- function(app_mgmt_url) {
  # TODO: Provide simple url-checking here, so we can return a standardized URL.
  if (rlang::is_interactive()) { # nocov start
    utils::browseURL(app_mgmt_url)
  } # nocov end
  return(invisible(app_mgmt_url))
}

#' Construct an OAuth client
#'
#' This is a wrapper around [httr2::oauth_client()] with stricter validation.
#'
#' @inheritParams .oauth-parameters
#' @inherit httr2::oauth_client return
#' @export
#' @examples
#' api_client("your_client_id", "your_client_secret", "https://example.com")
api_client <- function(client_id = "", client_secret = "", api_token_url) {
  # TODO: Update this to a general parameter checker. The whole idea is to make
  # sure the required parameters are set.
  #
  # TODO: Also validate that the api_token_url is a URL. Probably warn if it
  # doesn't have "token" in the name, but check more examples for patterns.
  if (
    length(client_id) && length(client_secret) &&
    !is.na(client_id) && !is.na(client_secret) &&
    nchar(client_id) && !nchar(client_secret)) {
    return(
      httr2::oauth_client(
        id = client_id,
        token_url = api_token_url,
        secret = client_secret,
        auth = "header"
      )
    )
  }
  cli::cli_abort(
    "Please provide a {.arg client_id} and {.arg client_secret}.",
    class = "missing_client_params"
  )
}

api_req_authenticate <- function(request,
                                 client,
                                 scopes = NULL,
                                 cache_disk = api_option_cache_disk(client),
                                 cache_key = NULL,
                                 token = NULL,
                                 refresh_token = NULL) {
  # The idea of this function is to wrap the various oauth bits from httr2,
  # importantly allowing the user to supply a refresh token outside of a full
  # oauth token object ~automatically (via an environment variable).

  # The hierarchy:
  # * If a valid oauth token object is provided, use it
  # * Check cache (if allowed), use that if token isn't expired
  # * If the refresh token is provided and works, use the resulting token
  # * If caching is allowed ... It really feels like all I'm doing is adding the
  #   ability to pass in a refresh token, check httr2 to see if it could be
  #   updated.
}

# TODO: What, if anything, do I need to override from
# httr2::req_oauth_auth_code()? Can I PR changes to httr2 to make it better in
# non-interactive contexts?
