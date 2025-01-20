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
  # As of 2025-01-20, httr2 on macos did not insert the "/", but all other OSs
  # did. Normalizing manually here.
  test_result$url <- stringr::str_replace(
    test_result$url,
    stringr::fixed("/?parm"),
    stringr::fixed("?parm")
  )
  expect_identical(
    test_result$url,
    "https://example.com?parm=my_key"
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
