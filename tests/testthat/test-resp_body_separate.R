test_that("resp_body_separate listifies responses", {
  expect_identical(
    resp_body_separate("1", as.integer),
    list(1L)
  )
})
