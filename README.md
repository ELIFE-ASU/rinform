# rinform #
[![Travis-CI Build Status](https://travis-ci.org/ELIFE-ASU/rinform.svg?branch=master)](https://travis-ci.org/ELIFE-ASU/rinform) [![AppVeyor Build status](https://ci.appveyor.com/api/projects/status/oanb720jqsyf8n8s?svg=true)](https://ci.appveyor.com/project/gvalentini85/rinform) [![codecov](https://codecov.io/gh/ELIFE-ASU/rinform/branch/master/graph/badge.svg)](https://codecov.io/gh/ELIFE-ASU/rinform)

An R wrapper of the [Inform v1.0.0](https://elife-asu.github.io/Inform/) C library for performing information analysis of complex system. As for the Inform library, _rinform_ is structured around the concepts of:

* discrete empirical probability distributions which form the basis for
  all of the information-theoretic measures,
* classic information-theoretic measures built upon empirical distributions (e.g.,
  Shannon entropy, mutual information, cross entropy),
* advanced measures of information dynamics for time series (e.g., transfer entropy,
  active information, evidence of integration).
  
In addition to the core components, rinform also provides a small collection of utilities
to deal with time series (e.g., binning of continuous values, black-boxing of time series).

Installation instructions and documentation for the _rinform_ package as well as
information about related projects can be found in the online
[documentation](https://elife-asu.github.io/rinform/).

If you are using _rinform_, consider citing the following articles:

* D.G. Moore, G. Valentini, S.I. Walker, M. Levin. "Inform: Efficient 
Information-Theoretic Analysis of Collective Behaviors". _Frontiers in Robotics & AI.
(_under review_)
* D.G. Moore, G. Valentini, S.I. Walker, M. Levin. "Inform: A Toolkit for
Information-Theoretic Analysis of Complex Systems". In: _Proceedings of the 
2017 IEEE Symposium Series on Computational Intelligence, Symposium on 
Artificial Life_, IEEE Press, 2017. (_in press_)

__Acknowledgement:__ This project was supported in part by the grant _Emergent computation in
collective decision making by the crevice-dwelling rock ant Temnothorax
rugatulus_ provided by the National Science Foundation (NSF grant PHY-1505048).

## Copyright and Licensing ##
Copyright © 2017-2018 Gabriele Valentini and Douglas G. Moore, Arizona State University.
Free use of this software is granted under the terms of the MIT License. See the
[LICENSE](https://github.com/elife-asu/rinform/blob/master/LICENSE) file for details.


