test_that(".req_policy returns reqs unchanged when no policies added", {
  req <- .as_nectar_request(httr2::request("https://example.com"))
  expect_identical(
    .req_policy(req),
    req
  )
})

test_that(".req_policy errors informatively for unnamed policies", {
  req <- httr2::request("https://example.com")
  expect_error(
    .req_policy(req, list(my_policy = "whatever")),
    "must be named",
    class = "nectar_error-bad_policy"
  )
})

test_that(".req_policy applies a policy", {
  req <- httr2::request("https://example.com")
  new_policy <- list(a = 1, b = "thing")
  test_result <- .req_policy(req, new_policy = new_policy)
  expect_identical(
    test_result$policies,
    list(new_policy = new_policy)
  )
})

test_that(".req_policy adds to existing policies", {
  req <- httr2::request("https://example.com")
  new_policy <- list(a = 1, b = "thing")
  new_policy2 <- list(a = 2, b = "thing2")
  req <- .req_policy(req, new_policy = new_policy)
  test_result <- .req_policy(req, new_policy2 = new_policy2)
  expect_identical(
    test_result$policies,
    list(new_policy = new_policy, new_policy2 = new_policy2)
  )
})

test_that(".req_policy removes emptied policies", {
  req <- httr2::request("https://example.com")
  new_policy <- list(a = 1, b = "thing")
  req <- .req_policy(req, new_policy = new_policy)
  test_result <- .req_policy(req, new_policy = NULL)
  expect_identical(
    test_result$policies,
    list()
  )
})
