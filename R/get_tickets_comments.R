#' Get tickets comments/replies
#'
#' This function takes your email ID, authentication token, sub-domain, 
#' and specific ticket ID to fetch all comments/replies to this wanted ticket. 
#' By default, this function works for just one ticket at once; if you need 
#' to extract comments/replies of multiple tickets, it is recommended to do a loop
#' using this function. Additionally, the default variables are: "id", "type", 
#' "author_id", "body", "created_at", "have_attachments". 
#' You can add other variables using the add_cols parameter. 
#' The variables that can be inserted are described in the Zendesk API documentation:
#' https://developer.zendesk.com/api-reference/ticketing/tickets/ticket-requests/#request-comments . 
#' The meaning of the default variables included in the function are described in the previous link, 
#' except by "have-attachments", which is a binary variable; if the comment has an attachment, 
#' the result is "Yes"; if not, it is "No". The function does not provide the attachments.
#' If you need sensitive data (location, lat, long, IP address...), you must set sentitive_data = T. 
#' Due to legal reasons, it is not recommended to store sensitive data. 
#' 
#' @references \url{https://developer.zendesk.com/api-reference/ticketing/tickets/ticket-requests/#request-comments}
#'
#' @param email_id Zendesk Email ID (username).
#' @param token Zendesk API token.
#' @param subdomain Your organization's Zendesk sub-domain.
#' @param ticket_id The ticket ID number. A numeric value.
#' @param add_cols Vector of column names to add at the results.
#' @param sensitive_data Logical value (TRUE or FALSE). If TRUE, all metadata variables will be added to the results. 
#' If FALSE, the default, the sensitive data will be not added.
#'
#' @return a Data Frame containing all comments/replies of the single ticket ID selected.
#'
#' @import dplyr
#' @import jsonlite
#' @import httr
#' @importFrom magrittr "%>%"
#' @importFrom jsonlite "fromJSON"
#' @importFrom httr "content"
#'
#' @export
#'
#' @examples \dontrun{
#' ## Extracting comments with default columns and without sensitive data
#' comments_ticket_id <- get_tickets_comments(email_id, token, subdomain, ticket_id,
#' add_cols= NULL, sensitive_data=F)
#' 
#'## Extracting comments with additional columns and sensitive data
#' comments_ticket_id <- get_tickets_comments(email_id, token, subdomain, ticket_id,
#' add_cols= c("html_body", "attachments"), sensitive_data=T)
#' }

# function to extract tickets comments/replies
get_tickets_comments <- function(email_id, token, subdomain, ticket_id,
                                 add_cols= NULL, sensitive_data=F) {
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

  columns <- c("id", "type", "author_id", "body", "created_at", "have_attachments") #default columns
  
  if(length(add_cols)!= 0) {
    columns_final <- c(columns, add_cols)
    }
  
  sensitive_data_columns <- c("metadata") 
  if(sensitive_data== T) { #default without sensitive data
    columns_final <- c(columns_final, sensitive_data_columns)
  }
  
 
  comments_extracted2 <- as.data.frame(parsed_response$comments) %>% 
  mutate(have_attachments = ifelse(sapply("attachments", function(list_element) length(list_element)==0), "No", "Yes")) %>%
  select(all_of(columns_final))
}
