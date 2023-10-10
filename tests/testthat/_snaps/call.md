# call_api() uses response_parser

    Code
      test_result <- call_api(base_url = "https://example.com", response_parser_args = list(
        simplifyVector = TRUE), user_agent = NULL)
      test_result
    Output
      response_parser(resp, simplifyVector = TRUE)

---

    Code
      test_result <- call_api(base_url = "https://example.com", response_parser = httr2::resp_body_html,
      response_parser_args = list(check_type = FALSE), user_agent = NULL)
      test_result
    Output
      response_parser(resp, check_type = FALSE)

