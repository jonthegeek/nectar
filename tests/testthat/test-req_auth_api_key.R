test_that("req_auth_api_key works for header", {
  test_result <- req_auth_api_key(
    httr2::request("https://example.com"),
    parameter_name = "parm",
    api_key = "my_key"
  )
  expect_in(
    test_result$headers,
    list(parm = "my_key")
  )
  expect_in(
    attr(test_result$headers, "redact"),
    "parm"
  )

  test_result <- req_auth_api_key(
    httr2::request("https://example.com"),
    parameter_name = "parm",
    api_key = "my_key",
    location = "header"
  )
  expect_in(
    test_result$headers,
    list(parm = "my_key")
  )
  expect_in(
    attr(test_result$headers, "redact"),
    "parm"
  )
})

test_that("req_auth_api_key works for query", {
  test_result <- req_auth_api_key(
    httr2::request("https://example.com"),
    parameter_name = "parm",
    api_key = "my_key",
    location = "query"
  )
  # In httr2 <=1.0.7, path can be NULL. in 1.1.0+, path is normalized to at
  # least "/". Normalize to make sure this test passes in both of those
  # versions.
  test_result$url <- stringr::str_replace(
    test_result$url,
    stringr::fixed("example.com?parm"),
    stringr::fixed("example.com/?parm")
  )
  expect_identical(
    test_result$url,
    "https://example.com/?parm=my_key"
  )
})

test_that("req_auth_api_key errors informatively with unused arguments", {
  expect_error(
    {
      req_auth_api_key(
        httr2::request("https://example.com"),
        location = "header",
        api_key = "ok",
        file_path = "bad"
      )
    },
    class = "rlib_error_dots_nonempty"
  )
  expect_error(
    {
      req_auth_api_key(
        httr2::request("https://example.com"),
        location = "query",
        api_key = "ok",
        file_path = "bad"
      )
    },
    class = "rlib_error_dots_nonempty"
  )
  expect_error(
    {
      req_auth_api_key(
        httr2::request("https://example.com"),
        location = "cookie",
        api_key = "bad",
        file_path = "ok"
      )
    },
    class = "rlib_error_dots_nonempty"
  )
})
