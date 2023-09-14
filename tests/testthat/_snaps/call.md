# call_api() deals with paths.

    Code
      call_api(base_url = "https://example.com", path = "foo/bar", response_parser = NULL,
        user_agent = NULL)
    Message <cliMessage>
      <performed/httr2_request>
      GET https://example.com/foo/bar
      Body: empty

---

    Code
      call_api(base_url = "https://example.com", path = list("foo/{bar}", bar = "baz"),
      response_parser = NULL, user_agent = NULL)
    Message <cliMessage>
      <performed/httr2_request>
      GET https://example.com/foo/baz
      Body: empty

