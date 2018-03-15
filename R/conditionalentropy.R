################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################



################################################################################
#' Conditional Entropy
#'
#' Compute the average or the local conditional entropy between two time series.
#' This function expects the \strong{condition} to be the first argument.
#'
#' @param xs Vector specifying a time series drawn from
#'        the conditional distribution.
#' @param ys Vector specifying a time series drawn from
#'        the target distribution.
#' @param local Boolean specifying whether to compute the local conditional
#'        entropy.
#'
#' @return Numeric giving the average conditional entropy or a vector giving the
#'         local conditional entropy.
#'
#' @example inst/examples/ex_conditionalentropy.R
#'
#' @export
#'
#' @useDynLib rinform r_conditional_entropy_
#' @useDynLib rinform r_local_conditional_entropy_
################################################################################
conditional_entropy <- function(xs, ys, local = FALSE) {
  n   <- 0
  ce  <- 0
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
  bx <- max(2, max(xs) + 1)

  # Compute the value of <by>
  by <- max(2, max(ys) + 1)

  if (!local) {
    x <- .C("r_conditional_entropy_",
            ys      = as.integer(xs),
	    xs      = as.integer(ys),
	    n       = as.integer(n),
	    bx      = as.integer(bx),
	    by      = as.integer(by),
	    rval    = as.double(ce),
	    err     = as.integer(err))
	    
    if (.check_inform_error(x$err) == 0) {
      ce <- x$rval
    }
  } else {
    ce <- rep(0, n)
    x <- .C("r_local_conditional_entropy_",
            ys      = as.integer(xs),
            xs      = as.integer(ys),
	    n       = as.integer(n),
	    bx      = as.integer(bx),
	    by      = as.integer(by),
	    rval    = as.double(ce),
	    err     = as.integer(err))
    if (.check_inform_error(x$err) == 0) {
      ce <- x$rval
    }    
  }

  ce
}