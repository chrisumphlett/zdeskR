# zdeskR 0.6.0.9000

* dev version

# zdeskR 0.6.0

* Corrected example for `ticket_search()`.
* Created `get_ticket_audits()` to fetch the audits for a ticket. This is useful for seeing the history of changes made to a ticket.

# zdeskR 0.5.0

* Corrected typo in `get_tickets()` documentation.
* Created `get_satisfaction_ratings()` to pull satisfaction ratings for tickets from the legacy CSAT endpoint.
* Created `ticket_search()` to search for tickets using the Zendesk search API.

# zdeskR 0.4.2

* Fixed examples in `get_tickets()` and `get_users` to reflect changes made previously in the function parameters for incremental querying. Addresses issue #8 brought up by @k-dutra.

# zdeskR 0.4.1

* This is a maintenance release that updates `get_all_ticket_metrics()`. Zendesk
instructed developers to switch from offset-based pagination to cursor-based
pagination. This is the only function that uses OBP. The other functions either
do not use pagination, or, use time-based pagination.

# zdeskR 0.4.0

* added `get_tickets_comments()` to fetch the comments in a conversation on a ticket (#5, thanks to @k-dutra for making the request and creating the PR).

# zdeskR 0.3.0

* `get_users()` changed to use Zendesk's incremental export endpoint. Instead of pagination with the `page=` parameter there is now a `start_time` parameter. This is a breaking change-- previous function calls with the page # will not work, and the `start_time` value must be given.
* `get_users()` now has a parameter for the user role. This is used to filter the api results before returning a data frame.
* `get_tickets()` was updated to use better logic for the stopping value for pagination.
* `get_tickets()` could have an error when combining custom field values of different types. These are now converted into a character column first before `purrr::map_dfr()` attempts to `bind_rows()`.

# zdeskR 0.2.0

* `styler` used to clean up formatting.
* `remove_cols` parameter added to `get_tickets` so that custom fields causing errors can be removed. Errors occurred when a field was sometimes blank and assigned a logical type were appended to non-blank, non-logical inside of a `purrr::map_dfr`. See issue #1 on GH opened by @nschaefer1211.

# zdeskR 0.1.1

* Added `start_date` parameter to the `get_users` function to enable pulling just more recent users rather than all users.
* Changed `get_tickets` from using cursor pagination to start/end time pagination.
* Pagination change allowed for the introduction of `end_time` as a parameter for the tickets call.

# zdeskR 0.1.0

* Added 2 more functions `get_custom_fields()` and `get_users()` to the package.
* `get_custom_fields()` will allow us to fetch the system and all the custom fields defined by the zendesk administrator for an organization.
* `get_users()` will allow us to fetch details of all the user registered in your zendesk organization.

# zdeskR 0.0.1

* Created initial set of functions to allow to authenticate and fetch tickets and tickets metrics data.
* Tested and released to GitHub.
