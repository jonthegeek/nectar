test_that("resp_body_auto works for json", {
  local_mocked_bindings(
    resp_body_json = function(resp) "json",
    .package = "httr2"
  )
  resp <- httr2::response(headers = list(`Content-Type` = "application/json"))
  expect_identical(resp_body_auto(resp), "json")
})

test_that("resp_body_auto works for json", {
  local_mocked_bindings(
    resp_body_json = function(resp) "json",
    .package = "httr2"
  )
  resp <- httr2::response(
    headers = list(`Content-Type` = "application/something+json")
  )
  expect_identical(resp_body_auto(resp), "json")
})

test_that("resp_body_auto works for xml", {
  local_mocked_bindings(
    resp_body_xml = function(resp) "xml",
    .package = "httr2"
  )
  resp <- httr2::response(headers = list(`Content-Type` = "application/xml"))
  expect_identical(resp_body_auto(resp), "xml")
  resp <- httr2::response(headers = list(`Content-Type` = "text/xml"))
  expect_identical(resp_body_auto(resp), "xml")
})

test_that("resp_body_auto works for html", {
  local_mocked_bindings(
    resp_body_html = function(resp) "html",
    .package = "httr2"
  )
  resp <- httr2::response(headers = list(`Content-Type` = "application/xhtml+xml"))
  expect_identical(resp_body_auto(resp), "html")
  resp <- httr2::response(headers = list(`Content-Type` = "text/html"))
  expect_identical(resp_body_auto(resp), "html")
})

test_that("resp_body_auto works for svg", {
  local_mocked_bindings(
    resp_body_string = function(resp) "string",
    .package = "httr2"
  )
  resp <- httr2::response(headers = list(`Content-Type` = "image/svg+xml"))
  expect_identical(resp_body_auto(resp), "string")
})

test_that("resp_body_auto works for csv", {
  local_mocked_bindings(
    resp_body_csv = function(resp) "csv"
  )
  resp <- httr2::response(headers = list(`Content-Type` = "text/csv"))
  expect_identical(resp_body_auto(resp), "csv")
})

test_that("resp_body_auto works for tsv", {
  local_mocked_bindings(
    resp_body_tsv = function(resp) "tsv"
  )
  resp <- httr2::response(
    headers = list(`Content-Type` = "text/tab-separated-values")
  )
  expect_identical(resp_body_auto(resp), "tsv")
})

test_that("resp_body_auto works for other strings", {
  local_mocked_bindings(
    resp_body_string = function(resp) "string",
    .package = "httr2"
  )
  resp <- httr2::response(headers = list(`Content-Type` = "text/weird"))
  expect_identical(resp_body_auto(resp), "string")
})

test_that("resp_body_auto works for other things", {
  local_mocked_bindings(
    resp_body_raw = function(resp) "raw",
    .package = "httr2"
  )
  resp <- httr2::response(headers = list(`Content-Type` = "weird/thing"))
  expect_identical(resp_body_auto(resp), "raw")
})
