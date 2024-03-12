test_that("req_prepare() uses body parameters", {
  test_result <- req_prepare(
    base_url = "https://example.com",
    body = list(
      foo = "bar",
      baz = "qux"
    ),
    user_agent = NULL
  )
  expect_identical(
    test_result$body$data,
    list(foo = "bar", baz = "qux")
  )
})

test_that("bodies with paths are handled properly", {
  expect_snapshot({
    test_result <- req_prepare(
      base_url = "https://example.com",
      body = list(
        foo = "bar",
        baz = fs::path(test_path("img-test.png"))
      ),
      user_agent = NULL
    )
    test_result$body
  })
  expect_identical(test_result$body$type, "multipart")
})
