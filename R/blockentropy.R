################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################



################################################################################
#' Block Entropy
#' 
#' Compute the average or local block entropy of a time series with block size
#' \code{k}.
#'
#' @param series Vector or matrix specifying one or more time series.
#' @param k Integer giving the history length.
#' @param local Boolean specifying whether to compute the local block entropy.
#'
#' @return Numeric giving the average block entropy or a vector giving the
#'         local block entropy.
#'
#' @example inst/examples/ex_blockentropy.R
#'
#' @export
#'
#' @useDynLib rinform r_block_entropy_
#' @useDynLib rinform r_local_block_entropy_
################################################################################
block_entropy <- function(series, k, local = FALSE) {
  n   <- 0
  m   <- 0
  be  <- 0
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
  b <- max(max(xs) + 1)

  if (!local) {
    x <- .C("r_block_entropy_",
            series  = as.integer(xs),
	    n       = as.integer(n),
	    m       = as.integer(m),
	    b       = as.integer(b),
	    k       = as.integer(k),
	    rval    = as.double(be),
	    err     = as.integer(err))

    if (.check_inform_error(x$err) == 0) {
      be <- x$rval
    }
  } else {
    be <- rep(0, (m - k + 1) * n)
    x <- .C("r_local_block_entropy_",
            series  = as.integer(xs),
	    n       = as.integer(n),
	    m       = as.integer(m),
	    b       = as.integer(b),
	    k       = as.integer(k),
	    rval    = as.double(be),
	    err     = as.integer(err))
    if (.check_inform_error(x$err) == 0) {
      be      <- x$rval
      dim(be) <- c(m - k + 1, n)
    }
  }

  be
}