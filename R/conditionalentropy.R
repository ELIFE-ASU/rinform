################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Conditional Entropy
#'
#' Compute the average or the local conditional entropy between two time series.
#' This function expects the \strong{condition} to be the first argument.
#' The bases \code{bx} and \code{by} are inferred from their respective time
#' series if they are not provided (or are 0). The minimum value in both cases
#' is 2. This function explicitly takes the logarithmic base \code{b} as an
#' argument.
#'
#' @param xs Vector or matrix specifying one or more time series drawn from
#'        the conditional distribution.
#' @param ys Vector or matrix specifying one or more time series drawn from
#'        the target distribution.
#' @param bx Integer giving the base of the conditional time series.
#' @param by Integer giving the base of the target time series.
#' @param b Double giving the base of the logarithm.
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
conditional_entropy <- function(xs, ys, k, bx = 0, by = 0, b = 2.0, local = FALSE) {
  n   <- 0
  m   <- 0  
  ce  <- 0
  err <- 0
  
  if (!is.numeric(xs)) {
    stop("<xs> is not numeric")
  }

  if (!is.numeric(ys)) {
    stop("<ys> is not numeric")
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

  # Compute the value of <bx>
  if (bx == 0) {
    bx <- max(2, max(xs) + 1)
  }

  # Compute the value of <by>
  if (by == 0) {
    by <- max(2, max(ys) + 1)
  }

  if (!local) {
    x <- .C("r_conditional_entropy_",
            ys      = as.integer(xs),
	    xs      = as.integer(ys),
	    n       = as.integer(n * m),
	    bx      = as.integer(bx),
	    by      = as.integer(by),
	    b       = as.double(b),	    
	    rval    = as.double(ce),
	    err     = as.integer(err))
	    
    if (x$err == 0) {
      ce <- x$rval
    } else {
      stop("inform lib error (", x$err, ")")
    }
    
  } else {
    ce <- rep(0, n * m)
    x <- .C("r_local_conditional_entropy_",
            ys      = as.integer(xs),
            xs      = as.integer(ys),
	    n       = as.integer(n * m),
	    bx      = as.integer(bx),
	    by      = as.integer(by),
	    b       = as.double(b),	    
	    rval    = as.double(te),
	    err     = as.integer(err))
	    
    if (x$err == 0) {
      ce <- x$rval
      ce <- matrix(x$rval, nrow = n, ncol = m, byrow = TRUE)
    } else {
      stop("inform lib error (", x$err, ")")
    }
    
  }

  ce
}