################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################



################################################################################
#' Entropy Rate
#'
#' Compute the average or local entropy rate of a time series with history
#' length \code{k}.
#'
#' @param series Vector or matrix specifying one or more time series.
#' @param k Integer giving the history length.
#' @param local Boolean specifying whether to compute the local entropy rate.
#'
#' @return Numeric giving the average entropy rate or a vector giving the
#'         local entropy rate.
#'
#' @example inst/examples/ex_entropyrate.R
#'
#' @export
#'
#' @useDynLib rinform r_entropy_rate_
#' @useDynLib rinform r_local_entropy_rate_
################################################################################
entropy_rate <- function(series, k, local = FALSE) {
  n   <- 0
  m   <- 0
  er  <- 0
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
  b = max(2, max(xs) + 1)

  if (!local) {
    x <- .C("r_entropy_rate_",
            series  = as.integer(xs),
	    n       = as.integer(n),
	    m       = as.integer(m),
	    b       = as.integer(b),
	    k       = as.integer(k),
	    rval    = as.double(er),
	    err     = as.integer(err))
    if (.check_inform_error(x$err) == 0) {
      er <- x$rval
    }
  } else {
    er <- rep(0, (m - k) * n)
    x <- .C("r_local_entropy_rate_",
            series  = as.integer(xs),
	    n       = as.integer(n),
	    m       = as.integer(m),
	    b       = as.integer(b),
	    k       = as.integer(k),
	    rval    = as.double(er),
	    err     = as.integer(err))
	    
    if (.check_inform_error(x$err) == 0) {
      er      <- x$rval
      dim(er) <- c(m - k, n)
    }
  }

  er
}