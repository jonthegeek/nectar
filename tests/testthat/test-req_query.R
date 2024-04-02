test_that("req_prepare() uses query parameters", {
  test_result <- req_prepare(
    base_url = "https://example.com",
    query = list(
      foo = "bar",
      baz = "qux"
    ),
    user_agent = NULL
  )
  expect_identical(
    test_result$url,
    "https://example.com/?foo=bar&baz=qux"
  )
})

test_that("req_prepare() smushes & concatenates multi-value query parameters", {
  test_result <- req_prepare(
    base_url = "https://example.com",
    query = list(
      foo = "bar",
      baz = c("qux", "quux")
    ),
    user_agent = NULL
  )
  expect_identical(
    test_result$url,
    "https://example.com/?foo=bar&baz=qux%2Cquux"
  )
})

test_that("req_prepare() removes empty query parameters", {
  test_result <- req_prepare(
    base_url = "https://example.com",
    query = list(
      foo = NULL,
      bar = "baz"
    ),
    user_agent = NULL
  )
  expect_identical(
    test_result$url,
    "https://example.com/?bar=baz"
  )
})
