## Test environments
* OS X 10.12.6 (local install), R 3.4.0
* OS X 10.12.6 (on travis-ci), R 3.4.3
* Windows Server 2012 R2 x64 (on AppVoyer), R 3.4.3
* Ubuntu 14.04.05 LTS (on travis-ci), R 3.4.2
* win-builder (devel and release)
* codecov 91% (using testthat)

## R CMD check results
There were no ERRORs or WARNINGs. There was 1 NOTEs:

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Gabriele Valentini <gvalent3@asu.edu>'
New submission

## Previous comments from CRAN
* The copyright is now assigned to G. Valentini and D.G. Moore
  instead of ELIFE@ASU. All files in R/ tests/ and src/ have
  been updated to reflect the new copyright. LICENSE and
  DESCRIPTION have also been updated accordingly.

* non-POSIX make sintax in src/inform-1.0.0/Makevars has been
  converted to POSIX syntax

## Downstream dependencies
There are no downstream dependencies.