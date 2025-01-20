test_that("resp_tidy fails gracefully for non-responses", {
  test_obj <- 1
  expect_error(
    resp_tidy(test_obj),
    class = "nectar_error-unsupported_response_class"
  )
  expect_snapshot(
    {
      resp_tidy(test_obj)
    },
    error = TRUE
  )
})

test_that("resp_tidy fails gracefully for lists of non-responses", {
  test_obj <- list(a = letters, b = 1:26)
  expect_error(
    resp_tidy(test_obj),
    class = "nectar_error-unsupported_response_class"
  )
  expect_snapshot(
    {
      resp_tidy(test_obj)
    },
    error = TRUE
  )
})

test_that("resp_tidy parses json-containing httr2_response objects", {
  mock_response <- httr2::response_json(body = 1:3)
  test_result <- resp_tidy(mock_response)
  expect_identical(test_result, as.list(1:3))
})

test_that("resp_tidy parses httr2_response objects with resp_tidy policy", {
  mock_response <- httr2::response_json(body = 1:3)
  mock_response$request <- list(
    policies = list(
      resp_tidy = list(
        tidy_fn = function(resp) {
          unlist(httr2::resp_body_json(resp))
        }
      )
    )
  )
  test_result <- resp_tidy(mock_response)
  expect_identical(test_result, 1:3)
})

test_that("resp_tidy uses policies$resp_tidy$tidy_args", {
  mock_response <- httr2::response_json(body = 1:3)
  mock_response$request <- list(
    policies = list(
      resp_tidy = list(
        tidy_fn = function(resp, additional) {
          c(unlist(httr2::resp_body_json(resp)), additional)
        },
        tidy_args = list(additional = 4:6)
      )
    )
  )
  test_result <- resp_tidy(mock_response)
  expect_identical(test_result, 1:6)
})

test_that("resp_tidy parses and combines nectar_responses objects", {
  request_obj <- list(
    policies = list(
      resp_tidy = list(
        tidy_fn = function(resp) {
          unlist(httr2::resp_body_json(resp))
        }
      )
    )
  )
  mock_response1 <- httr2::response_json(body = 1:3)
  mock_response1$request <- request_obj
  mock_response2 <- httr2::response_json(body = 4:6)
  mock_response2$request <- request_obj
  mock_responses <- structure(
    list(mock_response1, mock_response2),
    class = c("nectar_responses", "list")
  )
  test_result <- resp_tidy(mock_responses)
  expect_identical(test_result, 1:6)
})

test_that("resp_tidy parses and combines lists of httr2_response objects", {
  request_obj <- list(
    policies = list(
      resp_tidy = list(
        tidy_fn = function(resp) {
          unlist(httr2::resp_body_json(resp))
        }
      )
    )
  )
  mock_response1 <- httr2::response_json(body = 1:3)
  mock_response1$request <- request_obj
  mock_response2 <- httr2::response_json(body = 4:6)
  mock_response2$request <- request_obj
  mock_responses <- list(mock_response1, mock_response2)
  test_result <- resp_tidy(mock_responses)
  expect_identical(test_result, 1:6)
})

