#' Get Ticket Satisfaction Ratings
#'
#' This function takes your Email Id, authentication token,
#' sub-domain and start time as parameters and gets all the
#' satisfaction ratings for tickets which have been received
#' on or after the start time parameter. By default each page returns
#' 100 unique tickets and a next page url value which stores a
#' pointer to the next page (by updating the start time parameter). After
#' getting the first page this function will then loop through all subsequent
#' pages until there are none left.
#'
#' It's not a good practice to write down these authentication
#' parameters in your code. There are various methods and
#' packages available that are more secure; this package
#' doesn't require you to use any one in particular.
#'
#' The start time parameter should be in 'UTC' format as
#' Zendesk uses the 'UTC' time zone when retrieving tickets
#' after the start time. For example, the US Eastern Time Zone
#' is currently four hours behind UTC. If one wanted to get tickets
#' starting on August 1 at 12 am, you would need to enter
#' "2020-08-01 04:00:00". The user must do proper adjustment
#' to accommodate the time zone difference, if desired.
#'
#' rating_type allows you to get the satisfaction ratings, or, to see
#' the tickets where a user was offered the opportunity to respond and
#' did not, or to see the tickets where a user was not offered the
#' survey. By default it will do received.
#'
#' @references \url{https://developer.zendesk.com/api-reference/
#' ticketing/ticket-management/satisfaction_ratings/}
#'
#' @param email_id Zendesk Email Id (username).
#' @param token Zendesk API token.
#' @param subdomain Your organization's Zendesk sub-domain.
#' @param start_time String with a date or datetime to get all
#' tickets modified after that date.
#' @param rating_type String that specifies whether you want to see all
#' received ratings, offered ratings, or unoffered ratings.
#'
#' @return a Data Frame containing all tickets, satisfaction ratings,
#' and the comments.
#'
#' @import dplyr
#' @importFrom magrittr "%>%"
#' @importFrom jsonlite "fromJSON"
#' @importFrom httr "content"
#' @importFrom purrr "map_dfr"
#'
#' @export
#'
#' @examples \dontrun{
#' ratings <- get_satisfaction_ratings(email_id, token, subdomain,
#'   start_time = "2021-01-31 00:00:00", rating_type = "received")
#' )
#' }
get_satisfaction_ratings <- function(email_id, token, subdomain, start_time,
                        rating_type = "received") {

  user <- paste0(email_id, "/token")
  pwd <- token
  unix_start <- to_unixtime(as.POSIXct(start_time))

  request_rating<- list()
  stop_paging <- FALSE
  i <- 1

  url <- paste0(
    "https://", subdomain,
    ".zendesk.com/api/v2/satisfaction_ratings.json?score=",
    rating_type,
    "&start_time=",
    unix_start
  )

  while (stop_paging == FALSE) {
    request_rating[[i]] <- httr::RETRY("GET",
                                       url = url,
                                       httr::authenticate(user, pwd),
                                       times = 4,
                                       pause_min = 10,
                                       terminate_on = NULL,
                                       terminate_on_success = TRUE,
                                       pause_cap = 5
    )

    if (is.null(
      jsonlite::fromJSON(httr::content(request_rating[[i]], "text"),
                            flatten = TRUE
                         )$next_page))
    {
      stop_paging <- TRUE
    } else {
      url <- jsonlite::fromJSON(httr::content(request_rating[[i]], "text",
                                               flatten = TRUE))$next_page
      i <- i + 1
    }
  }

  build_data_frame <- function(c) {
    ratings <- as.data.frame(jsonlite::fromJSON(httr::content(
      request_rating[[c]], "text"
    ), flatten = TRUE)$satisfaction_ratings)
  }
  ratings <- purrr::map_dfr(seq_len(length(request_rating)), build_data_frame)

  return(ratings)
}
