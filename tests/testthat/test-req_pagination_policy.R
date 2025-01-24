test_that("req_pagination_policy errors informatively for bad fn", {
  expect_error(
    req_pagination_policy(
      httr2::request("https://example.com"),
      pagination_fn = "not a function"
    ),
    "was not found"
  )
})

test_that("req_pagination_policy applies the specified policy", {
  pag_fn <- httr2::iterate_with_offset("page")
  req <- req_pagination_policy(
    httr2::request("https://example.com"),
    pagination_fn = pag_fn
  )
  expect_identical(
    req$policies$pagination,
    list(
      pagination_fn = pag_fn
    )
  )
})

test_that("choose_pagination_fn returns NULL for no policy", {
  req <- httr2::request("https://example.com")
  expect_null(choose_pagination_fn(req))
})

test_that("choose_pagination_fn extracts the pagination_fn", {
  pag_fn <- httr2::iterate_with_offset("page")
  req <- req_pagination_policy(
    httr2::request("https://example.com"),
    pagination_fn = pag_fn
  )
  expect_identical(
    choose_pagination_fn(req),
    pag_fn
  )
})
