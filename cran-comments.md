## Corrected release

* I deleted some lines from DESCRIPTION that were not needed for this package and had caused notes in the CRAN checks.

## Release summary

* This is a maintenance release that improves two functions.
* `get_tickets()` has an end time parameter, taking advantage of new functionality in the Zendesk API.
* `get_users()` now has a start page parameter which can be used to avoid having to pull down all users and create the possibility of an incremental update workflow.


## Test environments

* Developed on and tested with Windows 10, R 4.0.2
* Tested on R-devel with devtools::check_win_devel()
* Testing against multiple Linux platforms with devtools::check_rhub()

## R CMD check results
0 errors √ | 0 warning x | 0 notes √

## No reverse dependencies

