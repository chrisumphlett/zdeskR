# zdeskR 0.3.0

* `get_users()` changed to use Zendesk's incremental export endpoint. Instead of pagination with the `page=` parameter there is now a `start_time` parameter. This is a breaking change-- previous function calls with the page # will not work, and the `start_time` value must be given.
* `get_users()` now has a parameter for the user role. This is used to filter the api results before returning a data frame.
* `get_tickets()` was updated to use better logic for the stopping value for pagination.
* `get_tickets()` could have an error when combining custom field values of different types. These are now converted into a character column first before `purrr::map_dfr()` attempts to `bind_rows()`.

# zdeskR 0.2.0

* `styler` used to clean up formatting.
* `remove_cols` parameter added to `get_tickets` so that custom fields causing errors can be removed. Errors occurred when a field was sometimes blank and assigned a logical type were appended to non-blank, non-logical inside of a `purrr::map_dfr`. See issue #1 on GH.

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
