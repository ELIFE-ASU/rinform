################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Transfer Entropy
#'
#' Compute the local or average transfer entropy from one time series \code{ys}
#' to another \code{xs} with target history length \code{k}. If the base 
#' \code{b} is not specified (or is 0), then it is inferred from the time series
#' with 2 as a minimum. \code{b} must be at least the base of the time series
#' and is used as the base of the logarithm.
#'
#' @param ys Vector or matrix specifying one or more source time series.
#' @param xs Vector or matrix specifying one or more target time series.
#' @param k Integer giving the history length.
#' @param b Integer giving the base of the time series and logarithm.
#' @param local Boolean specifying whether to compute the local transfer
#'        entropy.
#' @param mwindow Boolean specifying whether to compute the local transfer
#'        entropy using a moving window of size \code{k}.
#'
#' @return Numeric giving the average transfer entropy or a vector giving the
#'         local transfer entropy.
#'
#' @example inst/examples/ex_transferentropy.R
#'
#' @export
#'
#' @useDynLib rinform r_transfer_entropy_
#' @useDynLib rinform r_local_transfer_entropy_
################################################################################
transfer_entropy <- function(ys, xs, k, b = 0, local = FALSE, mwindow = FALSE) {
  n   <- 0
  m   <- 0
  te  <- 0
  err <- 0

  if (!is.numeric(ys)) {
    stop("<ys> is not numeric")
  }

  if (!is.numeric(xs)) {
    stop("<xs> is not numeric")
  }

  # Extract number of series and length
  if (is.vector(xs) & is.vector(ys)) {
    if (length(xs) != length(ys)) {
      stop("<xs> and <ys> differ in length")
    }
    n <- 1
    m <- length(xs)
  } else if (is.matrix(xs) & is.matrix(ys)) {
    if (dim(xs)[1] != dim(ys)[1] | dim(xs)[2] != dim(ys)[2]) {
      stop("<xs> and <ys> have different dimensions")
    }
    n <- dim(xs)[1]
    m <- dim(xs)[2]
  }

  # Convert to integer vector suitable for C
  xs <- as.integer(xs)
  ys <- as.integer(ys)

  # Compute the value of <b>
  if (b == 0) {
    b = max(2, max(xs) + 1)
  }

  if (!local) {
    x <- .C("r_transfer_entropy_",
            ys      = as.integer(ys),
	    xs      = as.integer(xs),
	    n       = as.integer(n),
	    m       = as.integer(m),
	    b       = as.integer(b),
	    k       = as.integer(k),
	    rval    = as.double(te),
	    err     = as.integer(err))
	    
    if (x$err == 0) {
      te <- x$rval
    } else {
      stop("inform lib error (", x$err, ")")
    }
    
  } else {
    te <- rep(0, (m - k) * n)
    x <- .C("r_local_transfer_entropy_",
            ys      = as.integer(ys),
            xs      = as.integer(xs),
	    n       = as.integer(n),
	    m       = as.integer(m),
	    b       = as.integer(b),
	    k       = as.integer(k),
	    mwindow = as.integer(mwindow),
	    rval    = as.double(te),
	    err     = as.integer(err))
	    
    if (x$err == 0) {
      te <- matrix(x$rval, nrow = n, ncol = m - k, byrow = TRUE)
    } else {
      stop("inform lib error (", x$err, ")")
    }
    
  }

  te
}