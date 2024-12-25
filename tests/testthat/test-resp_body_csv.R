test_that("resp_body_csv extracts csv data", {
  resp <- httr2::response(
    headers = list(`Content-Type` = "text/csv"),
    body = charToRaw("a,b,c\n1,3,5\n2,4,6")
  )
  expect_identical(
    resp_body_csv(resp),
    data.frame(a = 1:2, b = 3:4, c = 5:6)
  )
})

test_that("resp_body_csv fails gracefully for bad data", {
  resp <- httr2::response(
    headers = list(`Content-Type` = "not/csv"),
    body = charToRaw("a,b,c\n1,3,5\n2,4,6")
  )
  expect_error(
    resp_body_csv(resp),
    "Unexpected content type"
  )
})

test_that("resp_body_tsv extracts tsv data", {
  resp <- httr2::response(
    headers = list(`Content-Type` = "text/tab-separated-values"),
    body = charToRaw("a\tb\tc\n1\t3\t5\n2\t4\t6")
  )
  expect_identical(
    resp_body_tsv(resp),
    data.frame(a = 1:2, b = 3:4, c = 5:6)
  )
})

test_that("resp_body_tsv fails gracefully for bad data", {
  resp <- httr2::response(
    headers = list(`Content-Type` = "not/tsv"),
    body = charToRaw("a\tb\tc\n1\t3\t5\n2\t4\t6")
  )
  expect_error(
    resp_body_tsv(resp),
    "Unexpected content type"
  )
})
