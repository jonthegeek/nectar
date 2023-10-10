# bodies with paths are handled properly

    Code
      test_result <- call_api(base_url = "https://example.com", body = list(foo = "bar",
        baz = fs::path(test_path("img-test.png"))), response_parser = NULL,
      user_agent = NULL)
      test_result$body
    Output
      $data
      $data$foo
      Form data of length 5 (type: application/json) 
      
      $data$baz
      Form file: img-test.png 
      
      
      $type
      [1] "multipart"
      
      $content_type
      NULL
      
      $params
      list()
      

