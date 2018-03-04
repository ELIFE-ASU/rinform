## Test environments
* OS X 10.12.6 (local install), R 3.4.0
* OS X 10.12.6 (on travis-ci), R 3.4.3
* Windows Server 2012 R2 x64 (on AppVoyer), R 3.4.3
* Ubuntu 14.04.05 LTS (on travis-ci), R 3.4.2
* win-builder (devel and release)
* codecov 91% (using testthat)

## R CMD check results
There were no ERRORs or WARNINGs or NOTEs. 

## Downstream dependencies
I have also run R CMD check on downstream dependencies of httr 
(https://github.com/wch/checkresults/blob/master/httr/r-release). 
All packages that I could install passed except:

* Ecoengine: this appears to be a failure related to config on 
  that machine. I couldn't reproduce it locally, and it doesn't 
  seem to be related to changes in httr (the same problem exists 
  with httr 0.4).