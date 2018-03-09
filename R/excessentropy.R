################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Excess Entropy
#'
#' Compute the average or local excess entropy of a time series with block
#' size \code{k}.
#'
#' @param series Vector or matrix specifying one or more time series.
#' @param k Integer giving the block size.
#' @param local Boolean specifying whether to compute the local excess entropy.
#'
#' @return Numeric giving the average excess entropy or a vector giving the
#'         local excess entropy.
#'
#' @example inst/examples/ex_excessentropy.R
#'
#' @export
#'
#' @useDynLib rinform r_excess_entropy_
#' @useDynLib rinform r_local_excess_entropy_
################################################################################
excess_entropy <- function(series, k, local = FALSE) {
  n   <- 0
  m   <- 0
  ee  <- 0
  err <- 0

  .check_series(series)
  .check_history(k)
  .check_local(local)

  # Extract number of series and length
  if (is.vector(series)) {
    n <- 1
    m <- length(series)
  } else if (is.matrix(series)) {
    n <- dim(series)[2]
    m <- dim(series)[1]
  }

  # Convert to integer vector suitable for C
  xs <- as.integer(series)

  # Compute the value of <b>
  b <- max(2, max(xs) + 1)

  if (!local) {
    x <- .C("r_excess_entropy_",
            series  = xs,
	    n       = as.integer(n),
	    m       = as.integer(m),
	    b       = as.integer(b),
	    k       = as.integer(k),
	    rval    = as.double(ee),
	    err     = as.integer(err))
	    
    if (.check_inform_error(x$err) == 0) {
      ee <- x$rval
    }
  } else {
    ee <- rep(0, (m - 2 * k + 1) * n)
    x <- .C("r_local_excess_entropy_",
            series  = xs,
	    n       = as.integer(n),
	    m       = as.integer(m),
	    b       = as.integer(b),
	    k       = as.integer(k),
	    rval    = as.double(ee),
	    err     = as.integer(err))

    if (.check_inform_error(x$err) == 0) {
      ee      <- x$rval
      dim(ee) <- c(m - 2 * k + 1, n)
    }
  }

  ee
}