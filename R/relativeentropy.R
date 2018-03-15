################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################



################################################################################
#' Relative Entropy
#'
#' Compute the average or local relative entropy between two time series
#' treating each as observations from a distribution. 
#'
#' @param xs Vector or matrix specifying one or more time series.
#' @param ys Vector or matrix specifying one or more time series.
#' @param local Boolean specifying whether to compute the local relative
#'        entropy.
#'
#' @return Numeric giving the average relative entropy or a vector giving the
#'         local relative entropy.
#'
#' @example inst/examples/ex_relativeentropy.R
#'
#' @export
#'
#' @useDynLib rinform r_relative_entropy_
#' @useDynLib rinform r_local_relative_entropy_
################################################################################
relative_entropy <- function(xs, ys, local = FALSE) {
  n   <- 0
  m   <- 0  
  re  <- 0
  err <- 0

  .check_series(xs)
  .check_series(ys)
  .check_local(local)

  # Extract number of series and length
  if (is.vector(xs) & is.vector(ys)) {
    if (length(xs) != length(ys)) {
      stop("<", deparse(substitute(xs)), "> and <", deparse(substitute(ys)), "> differ in length")
    }
    n <- length(xs)
  } else {
    stop("<", deparse(substitute(xs)), "> or/and <", deparse(substitute(ys)), "> are not vectors")
  }

  # Convert to integer vector suitable for C
  xs <- as.integer(xs)
  ys <- as.integer(ys)

  # Compute the value of <bx>
  b <- max(2, max(xs) + 1, max(ys) + 1)

  if (!local) {
    x <- .C("r_relative_entropy_",
            ys      = as.integer(xs),
	    xs      = as.integer(ys),
	    n       = as.integer(n),
	    b       = as.integer(b),
	    rval    = as.double(re),
	    err     = as.integer(err))

    if (.check_inform_error(x$err) == 0) {
      re <- x$rval
    }
  } else {
    re <- rep(0, b)
    x <- .C("r_local_relative_entropy_",
            ys      = as.integer(xs),
            xs      = as.integer(ys),
	    n       = as.integer(n),
	    b       = as.integer(b),
	    rval    = as.double(re),
	    err     = as.integer(err))
	    
    if (.check_inform_error(x$err) == 0) {
      re <- x$rval
    }	    
  }

  re
}