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
