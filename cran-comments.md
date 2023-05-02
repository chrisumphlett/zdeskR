## Release summary

* This is a minor release that improves one function and does some cleanup.
* There is a breaking change on `get_users` but it is worth it, by significantly reducing the number of api calls required since an incremental export approach can be used.


## Test environments

* Developed on and tested with Windows 10, R 4.1
* Tested on R-devel with devtools::check_win_devel()
* Testing against multiple Linux platforms with devtools::check_rhub()


## R CMD check results
0 errors √ | 0 warning x | 0 notes √

## No reverse dependencies
