test_that("req_perform_opinionated() applies iteration when appropriate", {
  local_mocked_bindings(
    req_perform = function(req) {
      "req_perform"
    },
    req_perform_iterative = function(req, next_req = NULL, max_reqs = Inf) {
      "req_perform_iterative"
    }
  )
  req <- httr2::request("https://example.com")
  expect_identical(req_perform_opinionated(req), list("req_perform"))
  expect_identical(
    req_perform_opinionated(req, next_req = c),
    "req_perform_iterative"
  )
})

test_that("req_perform_opinionated applies retries when appropriate", {
  local_mocked_bindings(
    req_perform = function(req) req,
    req_perform_iterative = function(req, ...) req
  )
  req <- httr2::request("https://example.com")
  expect_identical(
    req_perform_opinionated(req),
    list(httr2::req_retry(req, max_tries = 3))
  )
  req_with_retries <- httr2::req_retry(req, max_seconds = 10)
  expect_identical(
    req_perform_opinionated(req_with_retries),
    list(req_with_retries)
  )
})
