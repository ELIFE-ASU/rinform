################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Coalesce
#'
#' Coalesce a time series into as few contiguous states as possible. The magic
#' of information measures is that the actual values of a time series
#' are irrelevant. For example, \code{[0, 1, 0, 1, 1]} has the same entropy as
#' \code{[2, 9, 2, 9, 9} (possibly up to a rescaling). This give us the freedom
#' to shift around the values of a time series as long as we do not change the
#' relative number of states. This function thus provides a way of "compressing"
#' a time series into as small a base as possible. Many of the measures use the
#' base of the time series to determine how much memory to allocate; the larger
#' the base, the higher the memory usage. It also affects the overall
#' performance as the combinatorics climb exponentially with the base. The two
#' standard usage cases for this function are to reduce the base of a time
#' series or ensure that the states are non-negative. Notice that the encoding
#' that is used ensures that the ordering of the states stays the same.
#'     
#' @param series Vector of the time series to coalesce.
#'
#' @return List giving the coalesced time series and its base.
#'
#' @example inst/examples/ex_coalesce.R
#'
#' @export
#'
#' @useDynLib rinform r_coalesce_
################################################################################
coalesce <- function(series) {
  err <- 0
  b   <- 0

  .check_series(series)
  .check_series_vector(series)

  # Extract length of series
  n <- length(series)

  # Convert to integer vector suitable for C
  xs <- as.integer(series)

  coal <- rep(0, n)
  x    <- .C("r_coalesce_",
             series  = xs,
	     n       = as.integer(n),
	     coal    = as.integer(coal),
	     b       = as.integer(b),
	     err     = as.integer(err))

  if (.check_inform_error(x$err) == 0) {
    coal <- x$coal
    b    <- x$b
  }

  list(series = coal, b = b)
}