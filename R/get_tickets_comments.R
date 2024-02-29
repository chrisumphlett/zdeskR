#' Get tickets comments/replies
#'
#' This function takes your email ID, authentication token, sub-domain,
#' and specific ticket ID to fetch all comments/replies to this wanted ticket.
#'
#' By default only these columns are returned: "id", "type", "author_id",
#' "body", "created_at", "have_attachments". You can add other variables using
#' the `add_cols` parameter. The variables that can be inserted are described in
#' the Zendesk API documentation: https://developer.zendesk.com/api-reference/
#' ticketing/tickets/ticket_comments/.
#'
#' The meaning of the default columns included are described in the previous
#' link, except "have-attachments" which is a boolean field that will be "Yes"
#' if the comment has an attachment or "No" if it does not. The attachment
#' itself cannot be returned.
#'
#' If you request the `metadata` sensitive data (location, lat, long,
#' IP address, etc.) will be included. This data should be handled with care and
#' only stored and used per your organization's policies and applicable
#' privacy regulations.
#'
#' @references \url{https://developer.zendesk.com/api-reference/ticketing/
#' tickets/ticket_comments/}
#'
#' @param email_id Zendesk Email ID (username).
#' @param token Zendesk API token.
#' @param subdomain Your organization's Zendesk sub-domain.
#' @param ticket_id The ticket ID number. A numeric value.
#' @param add_cols Vector of column names to select in addition to the default.
#' @param metadata Logical value (TRUE or FALSE). If TRUE, metadata columns will
#' be included. This is set to FALSE by default.
#'
#' @return a Data Frame containing all comments/replies for a single ticket.
#'
#' @import dplyr
#' @import jsonlite
#' @import httr
#' @importFrom magrittr "%>%"
#' @importFrom jsonlite "fromJSON"
#' @importFrom httr "content"
#' @importFrom tidyselect "all_of"
#'
#' @export
#'
#' @examples \dontrun{
#' ## Extracting comments with default columns and without sensitive data
#' comments_ticket_id <- get_tickets_comments(email_id, token, subdomain,
#' ticket_id, add_cols = NULL, metadata = FALSE)
#'
#'## Extracting comments with additional columns and sensitive data
#' comments_ticket_id <- get_tickets_comments(email_id, token, subdomain,
#' ticket_id, add_cols = c("html_body", "attachments"), metadata = TRUE)
#' }

# function to extract tickets comments/replies
get_tickets_comments <- function(email_id, token, subdomain, ticket_id,
                                 add_cols = NULL, metadata = FALSE) {
  user <- paste0(email_id, "/token")
  pwd <- token
  ticket_id <- ticket_id

  url <- paste0(
    "https://", subdomain,
    ".zendesk.com/api/v2/tickets/", ticket_id, "/comments?")

  request_ticket <- httr::RETRY("GET",
                                url = url,
                                httr::authenticate(user, pwd))

  response_text <- httr::content(request_ticket, as = "text")
  parsed_response <- jsonlite::fromJSON(response_text)

  default_columns <- c("id", "type", "author_id", "body", "created_at",
               "have_attachments")

  if(length(add_cols)!= 0) {
    columns_final <- c(default_columns, add_cols)
  } else {
    columns_final <- default_columns
  }

  sensitive_data_columns <- c("metadata")
  if(metadata == TRUE) { # default without sensitive data
    columns_final <- c(columns_final, sensitive_data_columns)
  } else {
    columns_final <- columns_final
  }

  comments_extracted2 <- as.data.frame(parsed_response$comments) %>%
  mutate(have_attachments = ifelse(
      sapply("attachments", function(list_element) length(list_element)==0),
      "No",
      "Yes"
    )) %>%
  select(all_of(columns_final))
}
