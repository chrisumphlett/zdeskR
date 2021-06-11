#' Get Metrics on All Zendesk Tickets
#'
#' This function takes your Email Id, authentication token,
#' sub-domain and parse all the tickets and its corresponding
#' metrics in a list. Since each iteration only returns 100
#' tickets at a time you must run the loop until the
#' "next_page" parameter is equal to null.
#'
#' Its not a good practice to write down these authentication
#' parameters in your code. There are various methods and
#' packages available that are more secure; this package
#' doesn't require you to use any one in particular.
#'
#'
#' @references \url{https://developer.zendesk.com/rest_api
#' /docs/support/ticket_metrics}
#'
#' @param email_id Zendesk Email Id (username).
#' @param token Zendesk API token.
#' @param subdomain Your organization's Zendesk sub-domain.
#'
#' @return Data Frame with metrics for all tickets
#'
#' @import dplyr
#' @importFrom jsonlite "fromJSON"
#' @importFrom httr "content"
#' @importFrom httr "authenticate"
#' @importFrom purrr "map_dfr"
#'
#' @export
#'
#' @examples \dontrun{
#' ticket_metrics <- get_all_ticket_metrics(email_id, token, subdomain)
#' }

get_all_ticket_metrics <-  function(email_id, token, subdomain) {

  user <- paste0(email_id, "/token")
  pwd <- token
  subdomain <- subdomain
  url_metrics <- paste0("https://", subdomain,
                        ".zendesk.com/api/v2/ticket_metrics.json?page=")

  #Stop Pagination when the parameter "next_page" is null.
  req_metrics <- list()
  stop_paging <- FALSE
  i <- 1
  while (stop_paging == FALSE) {
    req_metrics[[i]] <-  httr::RETRY("GET",
                                     url = paste0(url_metrics, i),
                                     httr::authenticate(user, pwd),
                                     times = 4,
                                     pause_min = 10,
                                     terminate_on = NULL,
                                     terminate_on_success = TRUE,
                                     pause_cap = 5)
    if (is.null((jsonlite::fromJSON(httr::content(req_metrics[[i]],
                                                 "text")))$next_page)) {
      stop_paging <- TRUE
    }
    i <- i + 1
  }

  build_data_frame <- function(c) {
    metrics <- as.data.frame((jsonlite::fromJSON(httr::content(req_metrics[[c]],
                                      "text"), flatten = TRUE))$ticket_metrics)
  }

  ticket_metrics_df <- purrr::map_dfr(seq_len(length(req_metrics)),
                                      build_data_frame)

  return(ticket_metrics_df)

}
