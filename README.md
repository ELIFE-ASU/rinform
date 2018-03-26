# rinform #
[![Travis-CI Build Status](https://travis-ci.org/ELIFE-ASU/rinform.svg?branch=master)](https://travis-ci.org/ELIFE-ASU/rinform) [![AppVeyor Build status](https://ci.appveyor.com/api/projects/status/oanb720jqsyf8n8s?svg=true)](https://ci.appveyor.com/project/gvalentini85/rinform) [![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/rinform)](https://cran.r-project.org/package=rinform) [![codecov](https://codecov.io/gh/ELIFE-ASU/rinform/branch/master/graph/badge.svg)](https://codecov.io/gh/ELIFE-ASU/rinform)

An R wrapper of the [Inform v1.0.0](https://elife-asu.github.io/Inform/) C library for performing information analysis of complex system. As for the Inform library, _rinform_ is structured around the concepts of:

* discrete empirical probability distributions which form the basis for
  all of the information-theoretic measures,
* classic information-theoretic measures built upon empirical distributions (e.g.,
  Shannon entropy, mutual information, cross entropy),
* advanced measures of information dynamics for time series (e.g., transfer entropy,
  active information, evidence of integration).
  
In addition to the core components, rinform also provides a small collection of utilities
to deal with time series (e.g., binning of continuous values, black-boxing of time series).

Detailed installation instructions and documentation for the _rinform_ package as well as
information about related projects can be found in the online
[documentation](https://elife-asu.github.io/rinform/).

If you are using _rinform_, consider citing the following articles:

* D.G. Moore, G. Valentini, S.I. Walker, M. Levin. "Inform: Efficient 
Information-Theoretic Analysis of Collective Behaviors". _Frontiers in Robotics & AI_.
(_under review_)
* D.G. Moore, G. Valentini, S.I. Walker, M. Levin. "Inform: A Toolkit for
Information-Theoretic Analysis of Complex Systems". In: _Proceedings of the 
2017 IEEE Symposium Series on Computational Intelligence, Symposium on 
Artificial Life_, 1-8, IEEE Press, 2017. [https://doi.org/10.1109/SSCI.2017.8285197](https://doi.org/10.1109/SSCI.2017.8285197)

__Acknowledgement:__ This project was supported in part by the grant _Emergent computation in
collective decision making by the crevice-dwelling rock ant Temnothorax
rugatulus_ provided by the National Science Foundation (NSF grant PHY-1505048).

## Installation ##

The _rinform_ package includes some C code, that is, the sources of the _Inform_
library. You may need some extra tools to install _rinform_ as they are required
to compile the _Inform_ source (e.g.,
[Xcode](https://developer.apple.com/xcode/) for Mac users,
[Rtools](http://cran.us.r-project.org/bin/windows/Rtools/) for Windows users)

### Installation from CRAN ###

To install _rinform_ directly from the CRAN repository you will simply need to
type:
```{r eval = FALSE}
install.packages("rinform")
```

Once installed, you can load _rinform_ prior to use it with:
```{r eval = FALSE}
library(rinform)
```

### Installation from GitHub ###

To install _rinform_ from its [GitHub](https://github.com/ELIFE-ASU/rinform) repository
you will need to have installed the [devtools](https://github.com/r-lib/devtools) package.
If you don't have devtools already, you can install it with:
```{r eval = FALSE}
install.packages("devtools")
```

Load devtools and install the latest stable version of _rinform_ (i.e., _master_ branch):
```{r eval = FALSE}
library(devtools)
install_github("ELIFE-ASU/rinform")
```

In case you need to use the development version of _rinform_, you can specify to install
from the _dev_ branch:
```{r eval = FALSE}
install_github("ELIFE-ASU/rinform", ref = "dev")
```

Once installed, you can load _rinform_ prior to use it with:
```{r eval = FALSE}
library(rinform)
```

## Example ##

Compute the amount of directed information transfered from a process `X` to a process
`Y` using transfer entropy:
```{r}
library(rinform)

xs <- c(0, 1, 1, 1, 1, 0, 0, 0, 0)
ys <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
transfer_entropy(xs, ys, ws = NULL, k = 2)
```

Examples of each function of the _rinform_ package can be found in the online
[documentation](https://elife-asu.github.io/rinform/).


## Getting Help ##

*rinform*, as its parent library [inform](https://github.com/elife-asu/inform),
is developed to help anyone
interested in applying information-theoretic techniques get things done
quickly and painlessly. We cannot do that without your feedback. We host the
project's source code and issue tracker on [Github](https://github.com/elife-asu/rinform).
Please create an issue if you find a bug, an error in this documentation,
or have a feature you'd like to request. Your contribution will make
*rinform* a better tool for everyone.

If you are interested in contributing to *rinform*, please contact the developers,
and we'll get you up and running!

Resources: [Source Repository](https://github.com/elife-asu/rinform) and [Issue Tracker](https://github.com/elife-asu/rinform/issues)


## Copyright and Licensing ##

Copyright © 2017-2018 Gabriele Valentini and Douglas G. Moore, Arizona State University.
Free use of this software is granted under the terms of the MIT License. See the
[LICENSE](https://github.com/elife-asu/rinform/blob/master/LICENSE) file for details.


