test_that("resp_tidy_unknown fails gracefully with object information", {
  target_tibble <- tibble::tibble(
    a = letters, b = LETTERS, c = 1:26
  )
  mock_response <- httr2::response_json(
    body = list(
      structured = target_tibble,
      other = 1:5,
      status = "ok"
    )
  )

  expect_error(
    resp_tidy_unknown(mock_response),
    class = "nectar_error-unknown_response_type"
  )
})
