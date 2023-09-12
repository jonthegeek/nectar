test_that("call_api() calls an API", {
  local_mocked_bindings(
    req_perform = function(req) {
      structure(req, class = c("performed", class(req)))
    }
  )
  expect_snapshot({
    call_api(base_url = "https://example.com", response_parser = NULL)
  })
})
