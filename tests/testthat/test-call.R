test_that("call_api() calls an API", {
  local_mocked_bindings(
    req_perform = function(req) {
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
})

test_that("call_api() deals with paths.", {
  local_mocked_bindings(
    req_perform = function(req) {
      structure(req, class = c("performed", class(req)))
    }
  )
  expect_snapshot({
    call_api(
      base_url = "https://example.com",
      path = "foo/bar",
      response_parser = NULL,
      user_agent = NULL
    )
  })
  expect_snapshot({
    call_api(
      base_url = "https://example.com",
      path = list(
        "foo/{bar}",
        bar = "baz"
      ),
      response_parser = NULL,
      user_agent = NULL
    )
  })
})
