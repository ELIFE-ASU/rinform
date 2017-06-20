################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Series Range
#'
#' Compute the range of a continuously-valued time series.
#'
#' @param series Vector of the time series to bin.
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

  if (!is.numeric(series)) {
    stop("<series> is not numeric")
  }

  if (is.matrix(series)) {
    stop("<series> is a matrix")
  }

  x <- .C("r_series_range_",
           series  = as.double(series),
	   n       = as.integer(length(series)),	   
	   srange  = as.double(rval$srange),
	   smin    = as.double(rval$smin),
	   smax    = as.double(rval$smax),
	   err     = as.integer(err))
	    
  if (x$err == 0) {
    rval$srange <- x$srange
    rval$smin   <- x$smin
    rval$smax   <- x$smax
  } else {
    stop("inform lib error (", x$err, ")")
  }
        
  rval
}

################################################################################
#' State Binning
#'
#' Bin a continously-valued times series. The binning can be performed in any
#' one of three ways. The first is binning the time series into \code{b}
#' uniform bins (with \code{b} an integer). The second type of binning produces
#' bins of a specific size \code{step}. The third type of binning is breaks the
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
## @useDynLib rinform r_bin_series_bin_
## @useDynLib rinform r_bin_series_step_
## @useDynLib rinform r_bin_series_bounds_
################################################################################
bin_series <- function(series, b = NA, step = NA, bounds = NA) {
  rval <- list(binned = 0.0, b = 0.0, spec = 0.0)
  err  <- 0

  if (!is.numeric(series)) {
    stop("<series> is not numeric")
  }

  if (is.matrix(series)) {
    stop("<series> is a matrix")
  }

  if (is.na(b) & is.na(step) & is.na(bounds)) {
    stop("must provide either number of bins, step size, or bin boundaries")
  } else if (!is.na(b) & !is.na(step)) {
    stop("cannot provide both number of bins and step size")
  } else if (!is.na(b) & !is.na(bounds)) {
    stop("cannot provide both number of bins and bin boundaries")
  } else if (!is.na(step) & !is.na(bounds)) {
    stop("cannot provide both step size and bin boundaries")
  }

  if (is.na(b)) {
    x <- .C("r_series_range_",
             series  = as.double(series),
             n       = as.integer(length(series)),	   
             b       = as.integer(b),
             err     = as.integer(err))
  } else if (is.na(step)) {

#        spec = step
#        b = _inform_bin_step(data, c_ulong(xs.size), c_double(step), out, byref(e))

  } else if (is.na(bounds)) {


#        boundaries = np.ascontiguousarray(bounds, dtype=np.float64)
#        bnds = boundaries.ctypes.data_as(POINTER(c_double))
#        spec = bounds
#        b = _inform_bin_bounds(data, c_ulong(xs.size), bnds, c_ulong(boundaries.size), out, byref(e))
  }

#    return binned, b, spec
  
	    
  if (x$err == 0) {
#    rval$srange <- x$srange
#    rval$smin   <- x$smin
#    rval$smax   <- x$smax
  } else {
    stop("inform lib error (", x$err, ")")
  }
        
  rval
}