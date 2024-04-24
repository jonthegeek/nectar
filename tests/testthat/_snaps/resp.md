# resp_parse fails gracefully for unsupported classes

    Code
      resp_parse(1)
    Condition
      Error:
      ! `1` must be a <list> or a <httr2_response>.
      x `1` is a number.

