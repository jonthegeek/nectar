test_that("req_pkg_user_agent adds a package agent", {
  req <- httr2::request("https://example.com")
  test_result <- req_pkg_user_agent(req, pkg_name = "stbl")
  # Scrub versions but make sure they're there.
  test_agent <- stringr::str_replace_all(
    test_result$options$useragent,
    r"(\d+(\.\d+){2,3})",
    "x.x.x"
  )
  expect_identical(
    test_agent,
    "httr2/x.x.x r-curl/x.x.x libcurl/x.x.x nectar/x.x.x (https://nectar.api2r.org) stbl/x.x.x"
  )
})

test_that("req_pkg_user_agent adds a package agent and url", {
  req <- httr2::request("https://example.com")
  test_result <- req_pkg_user_agent(
    req,
    pkg_name = "stbl",
    pkg_url = "https://stbl.api2r.org"
  )
  # Scrub versions but make sure they're there.
  test_agent <- stringr::str_replace_all(
    test_result$options$useragent,
    r"(\d+(\.\d+){2,3})",
    "x.x.x"
  )
  expect_identical(
    test_agent,
    "httr2/x.x.x r-curl/x.x.x libcurl/x.x.x nectar/x.x.x (https://nectar.api2r.org) stbl/x.x.x (https://stbl.api2r.org)"
  )
})

test_that("Corner case of no supplied name works.", {
  existing <- stringi::stri_rand_strings(1, 10)
  expect_identical(
    .lib_user_agent_append(existing, name = NULL, version = "x"),
    existing
  )
})

test_that("Corner case of no supplied agent works.", {
  expect_null(.user_agent_remove(NULL, NULL))
})
