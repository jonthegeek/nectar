.req_query_flatten <- function(req, query) {
  query <- purrr::discard(query, is.null)
  query <- purrr::map_chr(query, .prepare_query_element)
  return(httr2::req_url_query(req, !!!query))
}

.prepare_query_element <- function(query_element) {
  return(paste(unlist(query_element), collapse = ","))
}
