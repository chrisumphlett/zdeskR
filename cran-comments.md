## Release summary

* This is a minor release that added some new functions.
* Added `get_custom_fields()` to pull system aswell as all the custom fields defined for a zendesk organizationm.
* Added `get_users()` to pull all the details of the users registered in an zendesk organization.
* Improved handling API request errors.

## Test environments

* Developed on and tested with Windows 10, R 4.0.2
* Tested on R-devel with devtools::check_win_devel()
* Testing against multiple Linux platforms with devtools::check_rhub()

## R CMD check results
0 errors √ | 0 warning x | 0 notes √

## No reverse dependencies

