## Release summary

* This is a minor release that improves one function and does some cleanup.
* `styler` used to clean up formatting.
* `remove_cols` parameter added to `get_tickets` so that custom fields causing errors can be removed. Errors occurred when a field was sometimes blank and assigned a logical type were appended to non-blank, non-logical inside of a `purrr::map_dfr`. See issue #1 on GH.


## Test environments

* Developed on and tested with Windows 10, R 4.0.2
* Tested on R-devel with devtools::check_win_devel()
* Testing against multiple Linux platforms with devtools::check_rhub()


## R CMD check results
0 errors √ | 0 warning x | 0 notes √

## No reverse dependencies
