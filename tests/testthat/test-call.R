test_that("call_api() calls an API", {
  local_mocked_bindings(
    req_perform = function(req) {
      structure(req, class = "httr2_response")
    }
  )
  expect_no_error({
    test_result <- call_api(
      base_url = "https://example.com",
      response_parser = NULL,
      user_agent = NULL
    )
  })
  expect_identical(
    test_result$url,
    "https://example.com/"
  )
})

test_that("call_api() applies security", {
  local_mocked_bindings(
    req_perform = function(req) {
      structure(req, class = "httr2_response")
    }
  )
  test_result <- call_api(
    base_url = "https://example.com",
    user_agent = NULL,
    security_fn = httr2::req_url_query,
    security_args = list(
      security = "set"
    ),
    response_parser = NULL
  )
  expect_identical(
    test_result$url,
    "https://example.com/?security=set"
  )
})

test_that("call_api() uses response_parser", {
  local_mocked_bindings(
    req_perform = function(req) {
      httr2::response(body = "specific text")
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

test_that("call_api() applies iteration when appropriate", {
  local_mocked_bindings(
    req_perform = function(req) {
      "req_perform"
    },
    req_perform_iterative = function(req, next_req = NULL, max_reqs = Inf) {
      "req_perform_iterative"
    }
  )
  req <- httr2::request("https://example.com")
  expect_identical(.req_perform(req), "req_perform")
  expect_identical(
    .req_perform(req, next_req = mean),
    "req_perform_iterative"
  )
})
