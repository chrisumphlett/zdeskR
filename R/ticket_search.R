#' Returns ticket data for a provided Zendesk search query
#'
#' It takes your Email Id, authentication token, sub-domain and search query
#' and returns all the tickets that meet the search criteria. 100 tickets are
#' returned at a time. If your search query has many results, the function
#' may run for a long time as it goes through each page of results.
#'
#' It's not a good practice to write down these authentication
#' parameters in your code. There are various methods and
#' packages available that are more secure; this package
#' doesn't require you to use any one in particular.
#'
#' @references \url{https://developer.zendesk.com/api-reference/ticketing/
#' ticket-management/search/#list-search-results}
#'
#' @param email_id Zendesk Email Id (username).
#' @param token Zendesk API token.
#' @param subdomain Your organization's Zendesk sub-domain.
#' @param query Zendesk search query to execute.
#'
#' @return Data Frame with user details
#'
#' @import dplyr
#' @importFrom jsonlite "fromJSON"
#' @importFrom httr "content"
#' @importFrom httr "authenticate"
#' @importFrom purrr "map_dfr"
#' @importFrom utils "URLencode"
#'
#' @export
#'
#' @examples \dontrun{
#' search_results <- ticket_search(email_id, token, subdomain,
#' query = "query=satisfaction:goodwithcomment updated>24hours")
#' }
ticket_search <- function(email_id, token, subdomain, query) {
  user <- paste0(email_id, "/token")
  pwd <- token

  request_search <- list()
  stop_paging <- FALSE
  i <- 1

  while (stop_paging == FALSE) {
    url <- paste0(
      "https://", subdomain,
      ".zendesk.com/api/v2/search.json?", utils::URLencode(query)
    )

    request_search[[i]] <- httr::RETRY("GET",
                                  url = url,
                                  httr::authenticate(user, pwd),
                                  times = 4,
                                  pause_min = 10,
                                  terminate_on = NULL,
                                  terminate_on_success = TRUE,
                                  pause_cap = 5
    )

    if (is.null(
      jsonlite::fromJSON(httr::content(request_search[[i]], "text"),
                         flatten = TRUE
      )$next_page))
    {
      stop_paging <- TRUE
    } else {
      url <- jsonlite::fromJSON(httr::content(request_search[[i]], "text",
                                              flatten = TRUE))$next_page
      i <- i + 1
    }
  }

  build_data_frame <- function(c) {
    search_results <- as.data.frame(jsonlite::fromJSON(httr::content(
      request_search[[c]],
      "text"
    ), flatten = TRUE)$results)
  }
  search_results <- purrr::map_dfr(seq_len(length(request_search)),
                                   build_data_frame)
  return(search_results)
}
