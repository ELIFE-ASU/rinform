################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################



################################################################################
#' Predictive Information
#'
#' Compute the predictive information from a time series with history length
#' \code{kpast} and future length \code{kfuture}.
#'
#' @param series Vector or matrix specifying one or more time series.
#' @param kpast Integer giving the history length.
#' @param kfuture Integer giving the future length.
#' @param local Boolean specifying whether to compute the local predictive
#'        information.
#'
#' @return Numeric giving the average predictive information or a vector giving
#'         the local predictive information.
#'
#' @example inst/examples/ex_predictiveinfo.R
#'
#' @export
#'
#' @useDynLib rinform r_predictive_info_
#' @useDynLib rinform r_local_predictive_info_
################################################################################
predictive_info <- function(series, kpast, kfuture, local = FALSE) {
  n   <- 0
  m   <- 0
  pi  <- 0
  err <- 0

  .check_series(series)
  .check_history(kpast)
  .check_history(kfuture)
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
    x <- .C("r_predictive_info_",
            series  = xs,
	    n       = as.integer(n),
	    m       = as.integer(m),
	    b       = as.integer(b),
	    kpast   = as.integer(kpast),
	    kfuture = as.integer(kfuture),
	    rval    = as.double(pi),
	    err     = as.integer(err))
	    
    if (.check_inform_error(x$err) == 0) {
      pi <- x$rval
    }
  } else {
    pi <- rep(0, (m - kpast - kfuture + 1) * n)
    x <- .C("r_local_predictive_info_",
            series  = xs,
	    n       = as.integer(n),
	    m       = as.integer(m),
	    b       = as.integer(b),
	    kpast   = as.integer(kpast),
	    kfuture = as.integer(kfuture),
	    rval    = as.double(pi),
	    err     = as.integer(err))

    if (.check_inform_error(x$err) == 0) {
      pi      <- x$rval
      dim(pi) <- c(m - kpast - kfuture + 1, n)
    }
  }

  pi
}