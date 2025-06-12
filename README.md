# zdeskR
Connect to your Zendesk data with R!

## Purpose
zdeskR facilitates making a connection to the Zendesk API and executing various queries. You can use it to get tickets and ticket metrics in the form of data frames.

## Installation
The development version can be installed from GitHub: `devtools::install_github("chrisumphlett/zdeskR")`.

## Usage
The API uses Zendesk email id and the token associated with it to make queries. This id and token will be used in every API call along with a function specific URL to fetch the data.

The current version has several functions to make requests to the API:

* `get_tickets()`. Returns all the tickets of your Zendesk organization between given start and end times.
* `get_all_tickets_metrics()`. Returns all the ticket metrics in your Zendesk organization. Zendesk does not have an incremental version of this API endpoint; you cannot get the data starting after a certain date as of March 2021.
* `get_users()`. Returns all the users registered in your Zendesk organization. Can set a start page not equal to one to pull more recent users.
* `get_custom_fields()`. Returns all the system and custom fields available for the tickets in your Zendesk organization.
* `get_tickets_comments()`. Returns all comments in a conversation for a given ticket id.
* `get_satisfaction_ratings()`. Returns answers to satisfaction surveys (or identifies those who didn't take it, or weren't offered it) for tickets in your Zendesk organization. This is the legacy CSAT endpoint (as of 2025-06-11) not the new surveys endpoint.
* `ticket_search()`. Returns tickets that match a search query using the Zendesk search API. Zendesk has its own query syntax for this, which is documented in the [Zendesk documentation](https://developer.zendesk.com/documentation/api-basics/working-with-data/searching-with-the-zendesk-api/). Using an LLM can be helpful to write these queries. The function handles URL encoding.

### Using get_custom_fields() along with get_tickets()

`get_tickets()` returns a data frame that contains the names of system fields and ids of custom fields which adds up an additional task to map those ids with their respective names.

One way to do that is to manually create a dictionary having 'id' as keys and 'names' as values, but this approach becomes cumbersome when the size of dictionary increases.

An alternative to this approach is to use `get_custom_fields()` which returns a data frame containing system and all the custom field names. 
Here is a code snippet that you can use for reference. 

```
# Fetch respective data frames
tickets <- get_tickets(email_id = email_id, token = token, subdomain = subdomain, start_time = start_time)
fields <- get_custom_fields(email_id = email_id,token = token,subdomain = subdomain)
# Create a data frame that contains only 'id' and 'title' columns
fields_reduced <- fields%>%
                    select(2,4)
# Remove the system fields from the data frame
sys_list <- c('a','b','c') # Assuming that these are the only system fields in fields_reduced
cust_fields <- fields_reduced[!fields_reduced$title %in% sys_list,]
# Pivoting the custom field dataframe
cust_fields_piv <- cust_fields%>%
           pivot_wider(names_from = .data$id, values_from = .data$title)
# Keep common column names , this will keep only the custom field ids
common_col <- intersect(names(tickets),names(cust_fields_piv))
# Change names in tickets data frame using the list of column names in common_col
names(tickets)[names(tickets) %in% common_col] = cust_fields_piv[common_col]
```
