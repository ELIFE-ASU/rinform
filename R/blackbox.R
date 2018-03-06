################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Black Box
#'
#' Black-box time series from a collection of \code{l} sources where each
#' series has the same number of time steps, same number of initial conditions,
#' and possibly different bases into a single time series. The base of the
#' resulting time series is given by the product of the bases of each time
#' series in the collection. Black-boxing can be performed in time by
#' providing history lengths \code{r} and future lengths through \code{s}.
#'     
#' @param series Vector or Matrix of the time series to black-box.
#' @param l Numeric giving the number of sources in the collection.
#' @param r Vector giving the history lengths.
#' @param s Vector giving the future lengths.
#'
#' @return Vector giving the black-boxed time series.
#'
#' @example inst/examples/ex_black_box.R
#'
#' @export
#'
#' @useDynLib rinform r_black_box_
################################################################################
black_box <- function(series, l, r = NULL, s = NULL) {
  err      <- 0
  rNull    <- 1
  sNull    <- 1

  .check_series(series)
  .check_positive_integer(l)

  if (!is.null(r)) {
    .check_series(r)
    if (length(r) != l) {
      stop("<r> has length different from <l>!")
    }
    rNull <- 0
  } else { r <- 0 }
  
  if (!is.null(s)) {
    .check_series(s)
    if (length(s) != l) {
      stop("<s> has length different from <l>!")
    }
    sNull <- 0
  } else { s <- 0 }

  # Extract number of initial conditions and time steps
  if (is.vector(series)) {
    if (l != 1) {
      stop("<series> is a vector but the number <l> of time series is not 1!")
    }
  
    n <- 1
    m <- length(series)
    b <- max(2, max(series) + 1)    
  } else if (is.matrix(series)) {
    if (dim(series)[2] %% l != 0) {
      stop("The number of time series in <series> is not a multiple of <l>!")
    }
    
    n <- dim(series)[2] / l
    m <- dim(series)[1]
    b <- rep(0, l)
    for (i in 1:l) {
      b[i] <- max(2, max(series[, 1:n + n * (i - 1)]) + 1)        
    }
  }

  if      (max(r) > 0  & max(s) == 0) { box <- rep(-1, n  * (m - max(r) + 1)) }
  else if (max(r) == 0 & max(s) > 0)  { box <- rep(-1, n  * (m - max(s))) }
  else if (max(r) > 0  & max(s) > 0)  { box <- rep(-1, n  * (m - max(r) - max(s) + 1)) }
  else if (max(r) == 0 & max(s) == 0) { box <- rep(-1, n  * m) }
  
  x    <- .C("r_black_box_",
             series  = as.integer(series),
	     l       = as.integer(l),
	     n       = as.integer(n),
	     m       = as.integer(m),
	     b       = as.integer(b),
	     r       = as.integer(r),
	     rNull   = as.integer(rNull),
	     s       = as.integer(s),
	     sNull   = as.integer(sNull),
	     box     = as.integer(box),
	     err     = as.integer(err))

  if (.check_inform_error(x$err) == 0) {
    box <- x$box
    if (n > 1) { dim(box) <- c(length(box) / n, n) }
  }

  box
}