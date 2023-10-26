#' Ensure an argument is a length-1 character
#'
#' Calls to APIs often require a string argument. This function ensures that
#' those arguments are length-1, non-`NA` character vectors, or length-1,
#' non-`NA` vectors that can be coerced to character vectors. This is intended
#' to ensure that calls to the API will not fail with predictable errors, thus
#' avoiding unnecessary internet traffic.
#'
#' @inheritParams rlang::args_error_context
#' @inheritParams stbl::stabilize_chr_scalar
#' @inheritDotParams stbl::stabilize_chr_scalar x_class
#'
#' @return `x` coerced to a length-1 character vector, if possible.
#' @export
#'
#' @examples
#' stabilize_string("a")
#' stabilize_string(1.1)
#' x <- letters
#' try(stabilize_string(x))
#' x <- NULL
#' try(stabilize_string(x))
#' x <- character()
#' try(stabilize_string(x))
#' x <- NA
#' try(stabilize_string(x))
stabilize_string <- function(x,
                             ...,
                             regex = NULL,
                             arg = rlang::caller_arg(x),
                             call = rlang::caller_env()) {
  stbl::stabilize_chr_scalar(
    x,
    allow_null = FALSE,
    allow_zero_length = FALSE,
    allow_na = FALSE,
    regex = regex,
    x_arg = arg,
    call = call,
    ...
  )
}
