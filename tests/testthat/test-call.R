test_that("call_api() calls an API", {
  local_mocked_bindings(
    req_perform = function(req) {
      structure(req, class = "httr2_response")
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

test_that("call_api() applies security", {
  local_mocked_bindings(
    req_perform = function(req) {
      structure(req, class = "httr2_response")
    }
  )
  test_result <- call_api(
    base_url = "https://example.com",
    user_agent = NULL,
    security_fn = httr2::req_url_query,
    security_args = list(
      security = "set"
    ),
    response_parser = NULL
  )
  expect_identical(
    test_result$url,
    "https://example.com/?security=set"
  )
})

test_that("call_api() uses response_parser", {
  local_mocked_bindings(
    req_perform = function(req) {
      structure(req, class = "httr2_response")
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

test_that("call_api() applies iteration when appropriate", {
  local_mocked_bindings(
    req_perform = function(req) {
      "req_perform"
    },
    req_perform_iterative = function(req, next_req = NULL, max_reqs = Inf) {
      "req_perform_iterative"
    }
  )
  req <- httr2::request("https://example.com")
  expect_identical(.req_perform(req), "req_perform")
  expect_identical(
    .req_perform(req, next_req = mean),
    "req_perform_iterative"
  )
})

test_that("call_api() parses both single responses and paginated responses", {
  local_mocked_bindings(
    resps_data = function(resps, resp_data) {
      resp_data
    }
  )
  resp <- httr2::response()
  expect_identical(
    .resp_parse(resp, NULL, NULL),
    resp
  )
  parser_fun <- function(x) {
    x$body == "secret word"
  }
  test_result <- .resp_parse(list(), parser_fun, list())
  key <- httr2::response(body = "secret word")
  expect_true(test_result(key))
})
