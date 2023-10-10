test_that("call_api() uses body parameters", {
  local_mocked_bindings(
    .resp_get = function(req) {
      structure(req, class = c("performed", class(req)))
    }
  )
  test_result <- call_api(
    base_url = "https://example.com",
    body = list(
      foo = "bar",
      baz = "qux"
    ),
    response_parser = NULL,
    user_agent = NULL
  )
  expect_identical(
    test_result$body$data,
    list(foo = "bar", baz = "qux")
  )
})

test_that("bodies with paths are handled properly", {
  local_mocked_bindings(
    .resp_get = function(req) {
      structure(req, class = c("performed", class(req)))
    }
  )
  expect_snapshot({
    test_result <- call_api(
      base_url = "https://example.com",
      body = list(
        foo = "bar",
        baz = fs::path(test_path("img-test.png"))
      ),
      response_parser = NULL,
      user_agent = NULL
    )
    test_result$body
  })
  expect_identical(test_result$body$type, "multipart")
})
