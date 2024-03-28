test_that("Can build clean urls", {
  expected_result <- "https://example.com/api/v1/users"
  expect_identical(
    url_path_append("https://example.com", "api", "v1", "users"),
    expected_result
  )
  expect_identical(
    url_path_append("https://example.com/", "/api", "/v1", "/users"),
    expected_result
  )
  expect_identical(
    url_path_append("https://example.com/", "/api/v1/users"),
    expected_result
  )
})
