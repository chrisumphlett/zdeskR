## Release summary

* This is a maintenance release that updates `get_all_ticket_metrics()`. Zendesk
instructed developers to switch from offset-based pagination to cursor-based
pagination. This is the only function that uses OBP. The other functions either
do not use pagination or use time-based pagination.


## Test environments

* Developed on and tested with Windows 10, R 4.1
* Tested on R-devel with devtools::check_win_devel()
* Testing against multiple Linux platforms with devtools::check_rhub()


## R CMD check results
0 errors √ | 0 warning x | 0 notes √

## No reverse dependencies
