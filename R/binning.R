################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Series Range
#'
#' Compute the range, minimum and maximum values in a floating-point time
#' series \code{series}.
#'
#' @param series Vector giving the time series.
#'
#' @return List giving the range, the minimum and the maximum value of the
#'         series.
#'
#' @example inst/examples/ex_binning_series_range.R
#'
#' @export
#'
#' @useDynLib rinform r_series_range_
################################################################################
series_range <- function(series) {
  rval <- list(srange = 0.0, smin = 0.0, smax = 0.0)
  err  <- 0

  .check_series(series)
  .check_series_vector(series)
  
  x <- .C("r_series_range_",
           series  = as.double(series),
	   n       = as.integer(length(series)),	   
	   srange  = as.double(rval$srange),
	   smin    = as.double(rval$smin),
	   smax    = as.double(rval$smax),
	   err     = as.integer(err))

  if (.check_inform_error(x$err) == 0) {
    rval$srange <- x$srange
    rval$smin   <- x$smin
    rval$smax   <- x$smax
  }
  
  rval
}

################################################################################
#' State Binning
#'
#' Bin a continuously-valued times series. The binning can be performed in any
#' one of three ways. The first is binning the time series into \code{b}
#' uniform bins (with \code{b} an integer). The second type of binning produces
#' bins of a specific size \code{step}. The third type of binning breaks the
#' real number line into segments with specified boundaries or thresholds, and
#' the time series is binned according to this partitioning. The bounds are
#' expected to be provided in ascending order.
#'
#' @param series Vector of the continuously-valued time series to bin.
#' @param b Numeric giving the desired number of uniform bins.
#' @param step Numeric giving the desired size of each uniform bin.
#' @param bounds Vector of the finite bounds of each bin.
#'
#' @return List giving the binned sequence, the number of bins and either the
#'         bin sizes or bin bounds.
#'
#' @example inst/examples/ex_binning_bin_series.R
#'
#' @export
#'
#' @useDynLib rinform r_bin_series_bin_
#' @useDynLib rinform r_bin_series_step_
#' @useDynLib rinform r_bin_series_bounds_
################################################################################
bin_series <- function(series, b = NA, step = NA, bounds = NA) {
  rval <- list(binned = 0.0, b = 0.0, spec = 0.0)
  err  <- 0
  x    <- list()

  .check_series(series)
  .check_series_vector(series)

  if (is.na(b) & is.na(step) & anyNA(bounds)) {
    stop("must provide either number of bins, step size, or bin boundaries")
  } else if (!is.na(b) & !is.na(step)) {
    stop("cannot provide both number of bins and step size")
  } else if (!is.na(b) & !anyNA(bounds)) {
    stop("cannot provide both number of bins and bin boundaries")
  } else if (!is.na(step) & !anyNA(bounds)) {
    stop("cannot provide both step size and bin boundaries")
  }

  out  <- as.integer(rep(0, length(series)))
  spec <- as.double(0)

  if (!is.na(b)) {
    x <- .C("r_bin_series_bin_",
             series  = as.double(series),
             n       = as.integer(length(series)),	   
             b       = as.integer(b),
             out     = as.integer(out),
	     spec    = spec,
             err     = as.integer(err))	 	     
  } else if (!is.na(step)) {
    b    <- 0
    spec <- as.double(step)
    
    x <- .C("r_bin_series_step_",
             series  = as.double(series),
             n       = as.integer(length(series)),	   
             b       = as.integer(b),
             out     = as.integer(out),
	     spec    = spec,
             err     = as.integer(err))
  } else if (!anyNA(bounds)) {
    b <- 0
    x <- .C("r_bin_series_bounds_",
             series  = as.double(series),
             n       = as.integer(length(series)),
             b       = as.integer(b),	     
             bounds  = as.double(bounds),
             m       = as.integer(length(bounds)),
             out     = as.integer(out),
             err     = as.integer(err))
  }

  if (.check_inform_error(x$err) == 0) {
    rval$binned <- x$out
    rval$b      <- x$b
    if (!anyNA(bounds)) { rval$spec <- bounds }
    else                { rval$spec <- x$spec }
  }
  
  rval
}