################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Active Information
#'
#' Compute the average or local active information of a timeseries with history
#' length \code{k}. If the base \code{b} is not specified (or is 0), then it is
#' inferred from the time series with 2 as a minimum. \code{b} must be at least
#' the base of the time series and is used as the base of the logarithm.
#'
#' @param series Vector or matrix specifying one or more time series.
#' @param k Integer giving the history length.
#' @param b Integer giving the base of the time series and logarithm.
#' @param local Boolean specifying whether to compute the local active
#'        information.
#' @param mwindow .oolean specifying whether to compute the local active
#'        information using a moving window of size \code{k}.
#'
#' @return Numeric giving the average active information or a vector giving the
#'         local active information.
#'
#' @example inst/examples/ex_activeinfo.R
#'
#' @export
#'
#' @useDynLib rinform r_active_info_
#' @useDynLib rinform r_local_active_info_
################################################################################
active_info <- function(series, k, b = 0, local = FALSE, mwindow = FALSE) {
  n   <- 0
  m   <- 0
  ai  <- 0
  err <- 0

  if (!is.numeric(series)) {
    stop("<series> is not numeric")
  }

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
  if (b == 0) {
    b <- max(2, max(xs) + 1)
  }

  if (!local) {
    x <- .C("r_active_info_",
            series  = as.integer(xs),
	    n       = as.integer(n),
	    m       = as.integer(m),
	    b       = as.integer(b),
	    k       = as.integer(k),
	    rval    = as.double(ai),
	    err     = as.integer(err))
	    
    if (x$err == 0) {
      ai <- x$rval
    } else {
      stop("inform lib error (", x$err, ")")
    }
    
  } else {
    ai <- rep(0, (m - k) * n)
    x <- .C("r_local_active_info_",
            series  = as.integer(xs),
	    n       = as.integer(n),
	    m       = as.integer(m),
	    b       = as.integer(b),
	    k       = as.integer(k),
	    mwindow = as.integer(mwindow),
	    rval    = as.double(ai),
	    err     = as.integer(err))
	    
    if (x$err == 0) {
      ai      <- x$rval
      dim(ai) <- c(m - k, n)
    } else {
      stop("inform lib error (", x$err, ")")
    }
    
  }

  ai
}