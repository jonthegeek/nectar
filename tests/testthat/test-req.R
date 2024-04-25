test_that("req_prepare() deals with paths.", {
  test_result <- req_prepare(
    base_url = "https://example.com",
    path = "foo/bar",
    user_agent = NULL
  )
  expect_identical(
    test_result$url,
    "https://example.com/foo/bar"
  )

  test_result <- req_prepare(
    base_url = "https://example.com",
    path = list(
      "foo/{bar}",
      bar = "baz"
    ),
    user_agent = NULL
  )
  expect_identical(
    test_result$url,
    "https://example.com/foo/baz"
  )
})

test_that("req_prepare() applies methods", {
  test_result <- req_prepare(
    base_url = "https://example.com",
    method = "PATCH",
    user_agent = NULL
  )
  expect_identical(
    test_result$method,
    "PATCH"
  )
  test_result <- req_prepare(
    base_url = "https://example.com",
    user_agent = NULL
  )
  expect_null(test_result$method)
  test_result <- req_prepare(
    base_url = "https://example.com",
    body = list(a = 1),
    user_agent = NULL
  )
  expect_null(test_result$method)
})

test_that("req_prepare() applies user_agent", {
  test_result <- req_prepare(
    base_url = "https://example.com",
    user_agent = "foo"
  )
  expect_identical(
    test_result$options$useragent,
    "foo"
  )
})
