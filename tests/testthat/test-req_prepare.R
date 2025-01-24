test_that("req_prepare() applies user agent", {
  test_result <- req_prepare(
    base_url = "https://example.com",
    additional_user_agent = "foo"
  )
  this_version <- utils::packageVersion("nectar")
  expect_identical(
    test_result$options$useragent,
    unclass(glue::glue(
      "foo nectar/{this_version} (https://nectar.api2r.org)"
    ))
  )
})

test_that("req_prepare() deals with paths.", {
  test_result <- req_prepare(
    base_url = "https://example.com",
    path = "foo/bar"
  )
  expect_identical(
    test_result$url,
    "https://example.com/foo/bar"
  )

  test_result <- req_prepare(
    base_url = "https://example.com",
    path = list(
      "foo/{bar}",
      bar = "baz"
    )
  )
  expect_identical(
    test_result$url,
    "https://example.com/foo/baz"
  )
})

test_that("req_prepare() uses query parameters", {
  test_result <- req_prepare(
    base_url = "https://example.com",
    query = list(
      foo = "bar",
      baz = "qux"
    )
  )
  expect_identical(
    url_normalize(test_result$url),
    "https://example.com/?foo=bar&baz=qux"
  )
})

test_that("req_prepare() uses the .multi arg", {
  test_result <- req_prepare(
    base_url = "https://example.com",
    query = list(
      foo = "bar",
      baz = c("qux", "quux"),
      .multi = "comma"
    )
  )
  expect_identical(
    url_normalize(test_result$url),
    "https://example.com/?foo=bar&baz=qux%2Cquux"
  )
})

test_that("req_prepare() removes empty query parameters", {
  test_result <- req_prepare(
    base_url = "https://example.com",
    query = list(
      foo = NULL,
      bar = "baz"
    )
  )
  expect_identical(
    url_normalize(test_result$url),
    "https://example.com/?bar=baz"
  )
})

test_that("req_prepare() uses body parameters", {
  test_result <- req_prepare(
    base_url = "https://example.com",
    body = list(
      foo = "bar",
      baz = "qux"
    )
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
        baz = fs::path(test_path("fixtures", "img-test.png"))
      )
    )
    test_result$body
  })
  expect_identical(test_result$body$type, "multipart")
})

test_that("req_prepare() applies methods", {
  test_result <- req_prepare(
    base_url = "https://example.com",
    method = "PATCH"
  )
  expect_identical(
    test_result$method,
    "PATCH"
  )
  test_result <- req_prepare(
    base_url = "https://example.com"
  )
  expect_null(test_result$method)
  test_result <- req_prepare(
    base_url = "https://example.com",
    body = list(a = 1)
  )
  expect_null(test_result$method)
})
