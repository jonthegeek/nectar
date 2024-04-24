test_that("resp_parse fails gracefully for unsupported classes", {
  expect_error(
    resp_parse(1),
    class = "nectar_error_unsupported_response_class"
  )
  expect_snapshot(
    {
      resp_parse(1)
    },
    error = TRUE
  )
})

test_that("resp_parse parses json-containing httr2_response objects", {
  mock_response <- httr2::response_json(body = 1:3)
  test_result <- resp_parse(mock_response)
  expect_identical(test_result, as.list(1:3))
})

test_that("resp_parse parses httr2_response objects with specified parser", {
  mock_response <- httr2::response_json(body = 1:3)
  parser <- function(resp) {
    unlist(httr2::resp_body_json(resp))
  }
  test_result <- resp_parse(mock_response, response_parser = parser)
  expect_identical(test_result, 1:3)
})

test_that("resp_parse returns raw resp if NULL parser specified", {
  mock_response <- httr2::response_json(body = 1:3)
  test_result <- resp_parse(mock_response, response_parser = NULL)
  expect_identical(test_result, mock_response)
})

test_that("resp_parse accepts parser args", {
  mock_response <- httr2::response_json(body = 1:3)
  parser <- function(resp, unlist = FALSE) {
    x <- httr2::resp_body_json(resp)
    if (unlist) {
      return(unlist(x))
    }
    x
  }
  test_result <- resp_parse(mock_response, response_parser = parser)
  expect_identical(test_result, as.list(1:3))
  test_result <- resp_parse(
    mock_response,
    response_parser = parser,
    unlist = TRUE
  )
  expect_identical(test_result, 1:3)
})

test_that("resp_parse parses lists of httr2_responses", {
  mock_response <- list(
    httr2::response_json(body = 1:3),
    httr2::response_json(body = 4:6)
  )
  parser <- function(resp) {
    unlist(httr2::resp_body_json(resp))
  }
  test_result <- resp_parse(mock_response, response_parser = parser)
  expect_identical(test_result, 1:6)
})
