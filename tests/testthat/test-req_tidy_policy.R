test_that("req_tidy_policy errors informatively for bad fn", {
  expect_error(
    req_tidy_policy(
      httr2::request("https://example.com"),
      tidy_fn = "not a function"
    ),
    "was not found"
  )
})

test_that("req_tidy_policy applies resp_body_auto by default", {
  req <- req_tidy_policy(httr2::request("https://example.com"))
  expect_identical(
    req$policies$resp_tidy,
    list(
      tidy_fn = resp_body_auto,
      tidy_args = list()
    )
  )
})

test_that("req_tidy_policy applies the specified policy", {
  req <- req_tidy_policy(
    httr2::request("https://example.com"),
    tidy_fn = httr2::resp_body_json,
    tidy_args = list(simplifyVector = TRUE)
  )
  expect_identical(
    req$policies$resp_tidy,
    list(
      tidy_fn = httr2::resp_body_json,
      tidy_args = list(simplifyVector = TRUE)
    )
  )
})
