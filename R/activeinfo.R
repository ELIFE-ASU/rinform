################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Active Information
#'
#' Compute the average or local active information of a time series with history
#' length \code{k}.
#'
#' @param series Vector or matrix specifying one or more time series.
#' @param k Integer giving the history length.
#' @param local Boolean specifying whether to compute the local active
#'        information.
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
active_info <- function(series, k, local = FALSE) {
  n   <- 0
  m   <- 0
  ai  <- 0
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
    x <- .C("r_active_info_",
            series  = xs,
	    n       = as.integer(n),
	    m       = as.integer(m),
	    b       = as.integer(b),
	    k       = as.integer(k),
	    rval    = as.double(ai),
	    err     = as.integer(err))
	    
    if (.check_inform_error(x$err) == 0) {
      ai <- x$rval
    }
  } else {
    ai <- rep(0, (m - k) * n)
    x <- .C("r_local_active_info_",
            series  = xs,
	    n       = as.integer(n),
	    m       = as.integer(m),
	    b       = as.integer(b),
	    k       = as.integer(k),
	    rval    = as.double(ai),
	    err     = as.integer(err))

    if (.check_inform_error(x$err) == 0) {
      ai      <- x$rval
      dim(ai) <- c(m - k, n)
    }
  }

  ai
}