test_that("call_api() calls an API", {
  local_mocked_bindings(
    req_perform_opinionated = function(req, ...) list("performed"),
    resp_parse = function(resp, ...) {
      identical(resp, list("performed"))
    }
  )
  expect_no_error({
    test_result <- call_api(
      base_url = "https://example.com",
      user_agent = NULL
    )
  })
  expect_true(test_result)
})

test_that("call_api() applies security", {
  local_mocked_bindings(
    req_perform_opinionated = function(req, ...) req,
    resp_parse = function(resp, ...) resp
  )
  test_result <- call_api(
    base_url = "https://example.com",
    user_agent = NULL,
    security_fn = httr2::req_url_query,
    security_args = list(
      security = "set"
    )
  )
  expect_identical(
    url_normalize(test_result$url),
    "https://example.com/?security=set"
  )
})

test_that("call_api() uses response_parser", {
  local_mocked_bindings(
    req_perform_opinionated = function(req, ...) {
      list(httr2::response(body = "specific text"))
    }
  )
  parser <- function(resp) {
    resp$body == "specific text"
  }
  test_result <- call_api(
    base_url = "https://example.com",
    user_agent = NULL,
    response_parser = parser
  )
  expect_true(test_result)
})
