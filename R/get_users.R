#' Returns All Available Zendesk Users.
#'
#' It takes your Email Id, authentication token,
#' sub-domain and parse all the users in a list.
#' It iterates through all the pages returning only 100 users per
#' page until the "next_page" parameter becomes null indicating
#' there are no more pages to fetch.
#'
#' It's not a good practice to write down these authentication
#' parameters in your code. There are various methods and
#' packages available that are more secure; this package
#' doesn't require you to use any one in particular.
#'
#' The start_page parameter is useful if you have many users. Each
#' page contains 100 users. Zendesk does not have an incremental
#' method for pulling users by date but after you retrieve all of
#' your users once, you can then increment your start page to
#' something that will limit the number of users you are
#' re-pulling each time.
#'
#' If you are pulling partial lists of users be aware that you
#' will not get updates on older users. You will only get recently
#' created users, not modified/deleted users and their modified
#' data nor updated last login dates.
#'
#'
#' @references \url{https://developer.zendesk.com/rest_api
#' /docs/support/users}
#'
#' @param email_id Zendesk Email Id (username).
#' @param token Zendesk API token.
#' @param subdomain Your organization's Zendesk sub-domain.
#' @param start_time String with a date or datetime to get all
#' tickets modified after that date.
#' @param user_role User role, one of "all", "end-user", "agent", or "admin".
#'
#' @return Data Frame with user details
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
#' users <- get_users(email_id, token, subdomain)
#' }
get_users <- function(email_id, token, subdomain,
                      start_time, user_role = "all") {
  user <- paste0(email_id, "/token")
  pwd <- token
  unix_start <- to_unixtime(as.POSIXct(start_time))

  req_users <- list()
  stop_paging <- FALSE
  i <- 1

  while (stop_paging == FALSE) {
    url_users <- paste0(
      "https://", subdomain,
      ".zendesk.com/api/v2/incremental/users.json?start_time=", unix_start
    )
    req_users[[i]] <- httr::RETRY("GET",
                                  url = url_users,
                                  httr::authenticate(user, pwd),
                                  times = 4,
                                  pause_min = 10,
                                  terminate_on = NULL,
                                  terminate_on_success = TRUE,
                                  pause_cap = 5
    )
    unix_start <- (jsonlite::fromJSON(httr::content(
      req_users[[i]],
      "text"
    ), flatten = TRUE))$end_time

    if ((jsonlite::fromJSON(httr::content(req_users[[i]], "text"),
                            flatten = TRUE
    ))$end_of_stream == TRUE) {
      stop_paging <- TRUE
    }
    i <- i + 1
  }

  build_data_frame <- function(c) {
    users <- as.data.frame((jsonlite::fromJSON(httr::content(
      req_users[[c]],
      "text"
    ), flatten = TRUE))$users)
  }

  if(user_role == "all") {
    users_df <- purrr::map_dfr(seq_len(length(req_users)), build_data_frame)
  } else {
    users_df <- purrr::map_dfr(seq_len(length(req_users)), build_data_frame) %>%
      filter(.data$role == user_role)
  }
  return(users_df)
}
