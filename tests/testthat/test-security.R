test_that("security_api_key works for header", {
  test_result <- security_api_key(
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

  test_result <- security_api_key(
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

test_that("security_api_key works for query", {
  test_result <- security_api_key(
    httr2::request("https://example.com"),
    parameter_name = "parm",
    api_key = "my_key",
    location = "query"
  )
  expect_identical(
    test_result$url,
    "https://example.com?parm=my_key"
  )
})
