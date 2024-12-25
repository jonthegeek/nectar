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
  expect_identical(
    req_perform_opinionated(req),
    structure(
      list("req_perform"),
      class = c("nectar_responses", "list")
    )
  )
  expect_identical(
    req_perform_opinionated(req, next_req = c),
    structure(
      "req_perform_iterative",
      class = c("nectar_responses", "character")
    )
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
    structure(
      list(httr2::req_retry(req, max_tries = 3)),
      class = c("nectar_responses", "list")
    )
  )
  req_with_retries <- httr2::req_retry(req, max_seconds = 10)
  expect_identical(
    req_perform_opinionated(req_with_retries),
    structure(
      list(req_with_retries),
      class = c("nectar_responses", "list")
    )
  )
})
