test_that("call_api() uses query parameters", {
  local_mocked_bindings(
    .resp_get = function(req) {
      structure(req, class = c("performed", class(req)))
    }
  )
  test_result <- call_api(
    base_url = "https://example.com",
    query = list(
      foo = "bar",
      baz = "qux"
    ),
    response_parser = NULL,
    user_agent = NULL
  )
  expect_identical(
    test_result$url,
    "https://example.com/?foo=bar&baz=qux"
  )
})

test_that("call_api() smushes and concatenates multi-value query parameters", {
  local_mocked_bindings(
    .resp_get = function(req) {
      structure(req, class = c("performed", class(req)))
    }
  )
  test_result <- call_api(
    base_url = "https://example.com",
    query = list(
      foo = "bar",
      baz = c("qux", "quux")
    ),
    response_parser = NULL,
    user_agent = NULL
  )
  expect_identical(
    test_result$url,
    "https://example.com/?foo=bar&baz=qux%2Cquux"
  )
})
