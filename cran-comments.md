## Test environments
* OS X 10.12.6 (local install), R 3.4.3
* OS X 10.12.6 (on travis-ci), R 3.4.3
* Windows Server 2012 R2 x64 (on AppVoyer), R 3.4.3
* Ubuntu 14.04.05 LTS (on travis-ci), R 3.4.2
* win-builder (devel and release)
* codecov 91% (using testthat)

## R CMD check results
There were no ERRORs, WARNINGs and NOTEs.

## Notes to previous comments from CRAN
* Modified `src/inform-1.0.0/Makevars` to solve compilation issues on Solaris
  on CRAN (NB: we are unable to reproduce this problem locally and we cannot
  guarantee that it actually works on the CRAN machine).

* Memory management for functions `r_integration_evidence_parts_`
  and `r_black_box_parts_` has been converted from using malloc to R_alloc,
  which was still causing an invalid read of 4 bytes on CRAN. (NB: we are unable
  to reproduce this problem locally and we cannot guarantee that it
  actually works on the CRAN machine).

## Downstream dependencies
There are no downstream dependencies.