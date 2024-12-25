test_that("iterate_with_json_cursor repeats with non-empty cursor", {
  httr2::local_mocked_responses(list(
    httr2::response_json(
      body = list(
        response_metadata = list(next_cursor = "a"),
        data = "response1"
      )
    ),
    httr2::response_json(
      body = list(
        response_metadata = list(next_cursor = NULL),
        data = "response2"
      )
    )
  ))
  req <- httr2::request("https://example.com")
  resps <- httr2::req_perform_iterative(
    req,
    next_req = iterate_with_json_cursor(
      "cursor",
      c("response_metadata", "next_cursor")
    ),
    max_reqs = 2
  )
  expect_length(resps, 2)
  expect_equal(httr2::resp_body_json(resps[[1]])$data, "response1")
  expect_equal(httr2::resp_body_json(resps[[2]])$data, "response2")
})

test_that("iterate_with_json_cursor stops with NULL cursor", {
  httr2::local_mocked_responses(list(
    httr2::response_json(
      body = list(
        response_metadata = list(next_cursor = "a"),
        data = "response1"
      )
    ),
    httr2::response_json(
      body = list(
        response_metadata = list(next_cursor = NULL),
        data = "response2"
      )
    ),
    httr2::response_json(
      body = list(
        response_metadata = list(next_cursor = NULL),
        data = "response3"
      )
    )
  ))
  req <- httr2::request("https://example.com")
  resps <- httr2::req_perform_iterative(
    req,
    next_req = iterate_with_json_cursor(
      "cursor",
      c("response_metadata", "next_cursor")
    ),
    max_reqs = 5
  )
  expect_length(resps, 2)
  expect_equal(httr2::resp_body_json(resps[[1]])$data, "response1")
  expect_equal(httr2::resp_body_json(resps[[2]])$data, "response2")
})

test_that("iterate_with_json_cursor stops with blank cursor", {
  httr2::local_mocked_responses(list(
    httr2::response_json(
      body = list(
        response_metadata = list(next_cursor = "a"),
        data = "response1"
      )
    ),
    httr2::response_json(
      body = list(
        response_metadata = list(next_cursor = ""),
        data = "response2"
      )
    ),
    httr2::response_json(
      body = list(
        response_metadata = list(next_cursor = NULL),
        data = "response3"
      )
    )
  ))
  req <- httr2::request("https://example.com")
  resps <- httr2::req_perform_iterative(
    req,
    next_req = iterate_with_json_cursor(
      "cursor",
      c("response_metadata", "next_cursor")
    ),
    max_reqs = 5
  )
  expect_length(resps, 2)
  expect_equal(httr2::resp_body_json(resps[[1]])$data, "response1")
  expect_equal(httr2::resp_body_json(resps[[2]])$data, "response2")
})

