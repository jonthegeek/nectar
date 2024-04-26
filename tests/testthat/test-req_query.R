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
    url_normalize(test_result$url),
    "https://example.com/?foo=bar&baz=qux"
  )
})

test_that("req_prepare() uses the .multi arg", {
  test_result <- req_prepare(
    base_url = "https://example.com",
    query = list(
      foo = "bar",
      baz = c("qux", "quux"),
      .multi = "comma"
    ),
    user_agent = NULL
  )
  expect_identical(
    url_normalize(test_result$url),
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
    url_normalize(test_result$url),
    "https://example.com/?bar=baz"
  )
})
