#' Get Zendesk Ticket Audits
#'
#' This function takes your Email Id, authentication token,
#' sub-domain and ticket id as parameters and gets the first 100 audits.
#' Pagination to get additional audits was not set up in the first version
#' of this function.
#'
#' It's not a good practice to write down these authentication
#' parameters in your code. There are various methods and
#' packages available that are more secure; this package
#' doesn't require you to use any one in particular.
#'
#' @references \url{https://developer.zendesk.com/api-reference/ticketing/
#' tickets/ticket_audits/}
#'
#' @param email_id Zendesk Email Id (username).
#' @param token Zendesk API token.
#' @param subdomain Your organization's Zendesk sub-domain.
#' @param ticket_id Integer with Zendesk ticket id.
#'
#' @return a Data Frame containing first 100 audits for the ticket, with the
#' events as a nested data frame in each row.
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
#' all_tickets <- get_ticket_audits(email_id, token, subdomain,
#'   ticket_id = 123456
#' )
#' }
get_ticket_audits <- function(email_id, token, subdomain, ticket_id) {
  user <- paste0(email_id, "/token")
  pwd <- token

  url <- paste0(
    "https://", subdomain,
    ".zendesk.com/api/v2/tickets/", ticket_id, "/audits"
  )
  request_audits <- httr::RETRY("GET",
     url = url,
     httr::authenticate(user, pwd),
     times = 4,
     pause_min = 10,
     terminate_on = NULL,
     terminate_on_success = TRUE,
     pause_cap = 5
  )

  audits <- as.data.frame(jsonlite::fromJSON(
    httr::content(request_audits, "text"), flatten = TRUE)$audits
    )

  return(audits)
}
