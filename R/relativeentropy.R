################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Relative Entropy
#'
#' Compute the average or local relative entropy between two time series
#' treating each as observations from a distribution. The base \code{b} is
#' inferred from the time series if it is not provided (or is 0). The minimum
#' value is 2. This function explicitly takes the logarithmic base \code{base}
#' as an argument.
#'
#' @param xs Vector or matrix specifying one or more time series.
#' @param ys Vector or matrix specifying one or more time series.
#' @param bx Integer giving the base of the \code{xs} time series.
#' @param by Integer giving the base of the \code{ys} time series.
#' @param b Double giving the base of the logarithm.
#' @param local Boolean specifying whether to compute the local relative
#'        entropy.
#'
#' @return Numeric giving the average relative entropy or a vector giving the
#'         local relative entropy.
#'
#' @example inst/examples/ex_relativeentropy.R
#'
#' @export
#'
#' @useDynLib rinform r_relative_entropy_
#' @useDynLib rinform r_local_relative_entropy_
################################################################################
relative_entropy <- function(xs, ys, k, b = 0, base = 2.0, local = FALSE) {
  n   <- 0
  m   <- 0  
  re  <- 0
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
  if (b == 0) {
    bx <- max(2, max(xs) + 1)
    by <- max(2, max(xs) + 1)

    if (bx != by) {
      stop("<xs> and <ys> have different bases")
    }
    b <- bx
  }

  if (!local) {
    x <- .C("r_relative_entropy_",
            ys      = as.integer(xs),
	    xs      = as.integer(ys),
	    n       = as.integer(n * m),
	    b       = as.integer(b),
	    base    = as.double(base),	    
	    rval    = as.double(re),
	    err     = as.integer(err))
	    
    if (x$err == 0) {
      re <- x$rval
    } else {
      stop("inform lib error (", x$err, ")")
    }
    
  } else {
    re <- rep(0, n * m)
    x <- .C("r_local_relative_entropy_",
            ys      = as.integer(xs),
            xs      = as.integer(ys),
	    n       = as.integer(n * m),
	    b       = as.integer(b),
	    base    = as.double(base),	    
	    rval    = as.double(re),
	    err     = as.integer(err))
	    
    if (x$err == 0) {
      re <- matrix(x$rval, nrow = n, ncol = m, byrow = TRUE)    
    } else {
      stop("inform lib error (", x$err, ")")
    }
    
  }

  re
}