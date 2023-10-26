test_that("stabilize_string() checks strings", {
  expect_error(stabilize_string(letters), class = "stbl_error_non_scalar")
  expect_error(stabilize_string(NULL), class = "stbl_error_bad_null")
  expect_error(stabilize_string(character()), class = "stbl_error_bad_empty")
  expect_error(stabilize_string(NA), class = "stbl_error_bad_na")
  expect_identical(
    stabilize_string("a"),
    "a"
  )
})
