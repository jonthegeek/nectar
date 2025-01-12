% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/req_auth_api_key.R
\name{req_auth_api_key}
\alias{req_auth_api_key}
\title{Authenticate with an API key}
\usage{
req_auth_api_key(req, ..., location = "header")
}
\arguments{
\item{req}{(\code{httr2_request}) A \code{\link[httr2:request]{httr2::request()}} object.}

\item{...}{Additional parameters depending on the location of the API key.
\itemize{
\item \code{parameter_name} (\verb{length-1 character}, "header" or "query" only) The name of the parameter to
use in the header or query.
\item \code{api_key} (\verb{length-1 character}, "header" or "query" only) The API key to use.
\item \code{path} (\verb{length-1 character}, "cookie" only) The location of the cookie.
}}

\item{location}{(\verb{length-1 character}) Where the API key should be passed.
One of \code{"header"} (default), \code{"query"}, or \code{"cookie"}.}
}
\value{
A \code{\link[httr2:request]{httr2::request()}} object.
}
\description{
Many APIs provide API keys that can be used to authenticate requests (or,
often, provide other information about the user). This function helps to
apply those keys to requests.
}
