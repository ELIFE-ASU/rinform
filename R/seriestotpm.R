################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Time Series to TPM
#'
#' Estimate the one-time-step transition probability matrix `A` from a time
#' series. The element `A_{ji}` is the probability of transitioning to state
#' `j` in the next time step given the system is in state `i` (note the
#' column-major convention).
#'
#' @param series Vector or matrix specifying one or more time series.
#'
#' @return Matrix giving the corresponding transition probability matrix.
#'
#' @example inst/examples/ex_series_to_tpm.R
#'
#' @export
#'
#' @useDynLib rinform r_series_to_tpm_
################################################################################
series_to_tpm <- function(series) {
  n   <- 0
  m   <- 0
  err <- 0

  .check_series(series)

  # Extract number of series and length
  if (is.vector(series)) {
    n <- 1
    m <- length(series)
  } else if (is.matrix(series)) {
    n <- dim(series)[2]
    m <- dim(series)[1]
  }

  # Compute the value of <b>
  b <- max(2, max(series) + 1)

  tpm <- rep(0.0, b * b)
  x   <- .C("r_series_to_tpm_",
             series  = as.integer(series),
	     n       = as.integer(n),
	     m       = as.integer(m),
	     b       = as.integer(b),
	     tpm     = as.double(tpm),
	     err     = as.integer(err))

  if (.check_inform_error(x$err) == 0) {
    tpm      <- x$tpm
    dim(tpm) <- c(b, b)
  }

  tpm
}