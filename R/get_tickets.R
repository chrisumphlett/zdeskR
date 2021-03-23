#' Get Zendesk Tickets
#'
#' This function takes your Email Id, authentication token,
#' sub-domain and start time as parameters and gets all the
#' tickets which have been updated on or after the start
#' time parameter. By default each page returns 1000 unique
#' tickets and an "after_cursor" value which stores a
#' pointer to the next page. After getting the first page
#' it uses the pointer to fetch the subsequent pages.
#'
#' The start time parameter should be in 'UTC' format as
#' Zendesk uses the 'UTC' time zone when retrieving tickets
#' after the start time. For example, the US Eastern Time Zone
#' is currently four hours being UTC. If one wanted to get tickets
#' starting on August 1 at 12 am, you would need to enter
#' "2020-08-01 04:00:00". The user must do proper adjustment
#' to accommodate the time zone difference, if desired. A
#' date can be provided, it will retrieve results as of 12 am
#' in the UTC time zone.
#'
#' It's not a good practice to write down these authentication
#' parameters in your code. There are various methods and
#' packages available that are more secure; this package
#' doesn't require you to use any one in particular.
#'
#' @references \url{https://developer.zendesk.com/rest_api
#' /docs/support/incremental_export#start_time}
#'
#' @param email_id Zendesk Email Id (username).
#' @param token Zendesk API token.
#' @param subdomain Your organization's Zendesk sub-domain.
#' @param start_time Date or Datetime object to get all
#' tickets modified after that date, by default all
#' non-archived tickets will be returned.
#' @param end_time Date or Datetime object to get all
#' tickets modified before that date, default is the current
#' system time
#'
#' @return a Data Frame containing all tickets after the
#' start time.
#'
#' @import dplyr
#' @importFrom magrittr "%>%"
#' @importFrom jsonlite "fromJSON"
#' @importFrom httr "content"
#' @importFrom tidyr "pivot_wider"
#' @importFrom purrr "map_dfr"
#' @importFrom plyr "rbind.fill"
#'
#' @export
#'
#' @examples \dontrun{
#' all_tickets <- get_tickets(email_id, token, subdomain,
#' start_time = "2021-01-31 00:00:00", end_time = "2021-01-31 23:59:59")
#' }


get_tickets <- function(email_id, token, subdomain, start_time = 0, end_time = Sys.time()){

  user <- paste0(email_id, "/token")
  pwd <- token
  unix_start <- to_unixtime(as.POSIXct(start_time))
  unix_end <- to_unixtime(as.POSIXct(end_time))


  request_ticket <- list()
  stop_paging <- FALSE
  i <-1

  while(stop_paging == FALSE){
    url <- paste0("https://", subdomain,
                  ".zendesk.com/api/v2/incremental/tickets.json?start_time=",
                  unix_start)

    request_ticket[[i]] <- httr::RETRY('GET',
                                       url = url,
                                       httr::authenticate(user, pwd),
                                       times = 4,
                                       pause_min = 10,
                                       terminate_on = NULL,
                                       terminate_on_success = TRUE,
                                       pause_cap = 5)
    unix_start <- (jsonlite::fromJSON(httr::content(request_ticket[[i]], 'text'),flatten = TRUE))$end_time
    if((jsonlite::fromJSON(httr::content(request_ticket[[i]], 'text'),flatten = TRUE))$end_time >= unix_end){
      stop_paging <- TRUE
    }
    i <- i + 1
  }


  build_data_frame <- function(c){
    tickets <- as.data.frame((jsonlite::fromJSON(httr::content(request_ticket[[c]], 'text'), flatten = TRUE))$tickets)
  }
  tickets <- purrr::map_dfr(1:length(request_ticket), build_data_frame)

  pivot_data_frame <- function(c){
    pivot_df <- as.data.frame(tickets$custom_fields[c])%>%
      tidyr::pivot_wider(names_from= .data$id, values_from= .data$value)
  }


  ticket_final <- purrr::map_dfr(1:nrow(tickets), pivot_data_frame)
  ticket_final2 <- bind_cols(tickets, ticket_final)

  return(ticket_final2)

}
