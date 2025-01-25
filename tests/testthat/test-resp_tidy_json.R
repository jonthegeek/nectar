test_that("resp_tidy_json fails gracefully with a bad subset_path", {
  expect_error(
    resp_tidy_json(subset_path = list(a = 1:10, b = mean), resp = NULL),
    class = "stbl_error_coerce_character"
  )
})

test_that("resp_tidy_json tidies a response", {
  target_tibble <- tibble::tibble(
    a = letters, b = LETTERS, c = 1:26
  )
  mock_response <- httr2::response_json(
    body = target_tibble
  )
  expect_identical(
    resp_tidy_json(mock_response),
    target_tibble
  )
})

test_that("resp_tidy_json subsets a response", {
  target_tibble <- tibble::tibble(
    a = letters, b = LETTERS, c = 1:26
  )
  mock_response <- httr2::response_json(
    body = list(
      ok = TRUE,
      data = list(
        target_tibble = target_tibble
      )
    )
  )
  expect_identical(
    resp_tidy_json(mock_response, subset_path = c("data", "target_tibble")),
    target_tibble
  )
})

test_that("resp_tidy_json tidies a response with a spec", {
  source_tibble <- tibble::tibble(
    a = letters, b = LETTERS, c = 1:26
  )
  target_tibble <- tibble::tibble(
    lc = letters, uc = LETTERS, n = 1:26
  )
  mock_response <- httr2::response_json(
    body = source_tibble
  )
  spec <- tibblify::tspec_df(
    lc = tibblify::tib_chr("a"),
    uc = tibblify::tib_chr("b"),
    n = tibblify::tib_int("c"),
  )
  expect_identical(
    resp_tidy_json(mock_response, spec = spec),
    target_tibble
  )
})

test_that("resp_tidy_json works with resp_tidy", {
  source_tibble <- tibble::tibble(
    a = letters, b = LETTERS, c = 1:26
  )
  target_tibble <- tibble::tibble(
    lc = letters, uc = LETTERS, n = 1:26
  )
  mock_response <- httr2::response_json(
    body = source_tibble
  )
  mock_response$request <- list(
    policies = list(
      resp_tidy = list(
        tidy_fn = resp_tidy_json,
        tidy_args = list(
          spec = tibblify::tspec_df(
            lc = tibblify::tib_chr("a"),
            uc = tibblify::tib_chr("b"),
            n = tibblify::tib_int("c"),
          )
        )
      )
    )
  )
  expect_identical(
    resp_tidy(mock_response),
    target_tibble
  )
})

test_that("resp_tidy_json works with resp_tidy", {
  source_tibble <- tibble::tibble(
    a = letters, b = LETTERS, c = 1:26
  )
  mock_response <- httr2::response_json(
    body = source_tibble
  )
  mock_response$request <- list(
    policies = list(
      resp_tidy = list(
        tidy_fn = resp_tidy_json,
        tidy_args = list(
          subset_path = "d"
        )
      )
    )
  )
  test_result <- expect_no_error(resp_tidy(mock_response))
  expect_null(test_result)
})
