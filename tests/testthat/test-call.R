test_that("call_api() calls an API", {
  local_mocked_bindings(
    .resp_get = function(req) {
      structure(req, class = c("performed", class(req)))
    }
  )
  expect_no_error({
    test_result <- call_api(
      base_url = "https://example.com",
      response_parser = NULL,
      user_agent = NULL
    )
  })
  expect_identical(
    test_result$url,
    "https://example.com/"
  )
})

test_that("call_api() deals with paths.", {
  local_mocked_bindings(
    .resp_get = function(req) {
      structure(req, class = c("performed", class(req)))
    }
  )
  test_result <- call_api(
    base_url = "https://example.com",
    path = "foo/bar",
    response_parser = NULL,
    user_agent = NULL
  )
  expect_identical(
    test_result$url,
    "https://example.com/foo/bar"
  )

  test_result <- call_api(
    base_url = "https://example.com",
    path = list(
      "foo/{bar}",
      bar = "baz"
    ),
    response_parser = NULL,
    user_agent = NULL
  )
  expect_identical(
    test_result$url,
    "https://example.com/foo/baz"
  )
})

test_that("call_api() uses response_parser", {
  local_mocked_bindings(
    .resp_get = function(req) {
      structure(req, class = c("performed", class(req)))
    },
    .resp_parse_apply = function(resp, response_parser, response_parser_args) {
      rlang::expr(response_parser(resp, !!!response_parser_args))
    }
  )
  expect_snapshot({
    test_result <- call_api(
      base_url = "https://example.com",
      response_parser_args = list(simplifyVector = TRUE),
      user_agent = NULL
    )
    test_result
  })
  expect_snapshot({
    test_result <- call_api(
      base_url = "https://example.com",
      response_parser = httr2::resp_body_html,
      response_parser_args = list(check_type = FALSE),
      user_agent = NULL
    )
    test_result
  })
})

test_that("call_api() applies methods", {
  local_mocked_bindings(
    .resp_get = function(req) {
      structure(req, class = c("performed", class(req)))
    }
  )
  test_result <- call_api(
    base_url = "https://example.com",
    method = "PATCH",
    response_parser = NULL,
    user_agent = NULL
  )
  expect_identical(
    test_result$method,
    "PATCH"
  )
})

test_that("call_api() applies user_agent", {
  local_mocked_bindings(
    .resp_get = function(req) {
      structure(req, class = c("performed", class(req)))
    }
  )
  test_result <- call_api(
    base_url = "https://example.com",
    response_parser = NULL,
    user_agent = "foo"
  )
  expect_identical(
    test_result$options$useragent,
    "foo"
  )
})

test_that("call_api() applies security", {
  local_mocked_bindings(
    .resp_get = function(req) {
      structure(req, class = c("performed", class(req)))
    }
  )
  test_result <- call_api(
    base_url = "https://example.com",
    response_parser = NULL,
    user_agent = NULL,
    security_fn = httr2::req_url_query,
    security_args = list(
      security = "set"
    )
  )
  expect_identical(
    test_result$url,
    "https://example.com/?security=set"
  )
})
