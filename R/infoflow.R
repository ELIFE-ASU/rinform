################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################



################################################################################
#' Information Flow
#'
#' Compute the information flow from \code{lsrc} time series \code{src} to
#' another \code{ldst} time series \code{dst}. Optionally, the user can specify
#' \code{lback} background time series \code{back} to conditioning probabilities.
#'
#' @param src Vector or matrix specifying one or more source time series.
#' @param dst Vector or matrix specifying one or more destination time series.
#' @param back Vector or matrix specifying one or more background time series.
#' @param lsrc Integer giving the number of sources.
#' @param ldst Integer giving the number of destinations.
#' @param lback Integer giving the number of backgrounds.
#'
#' @return Numeric giving the value of information flow.
#'
#' @example inst/examples/ex_info_flow.R
#'
#' @export
#'
#' @useDynLib rinform r_info_flow_
#' @useDynLib rinform r_info_flow_back_
################################################################################
info_flow <- function(src, dst, back = NULL, lsrc, ldst, lback = 0) {
  n   <- 0
  m   <- 0
  IF  <- 0
  err <- 0

  .check_series(src)
  .check_series(dst)
  .check_positive_integer(lsrc)
  .check_positive_integer(ldst)
  if(!is.null(back)) {
    .check_series(back)
    .check_positive_integer(lback)
  }

  # Extract number of series and length
  if (is.vector(src)) {
    if (lsrc != 1) {
      stop("<src> has a different number of time series than what specified by <lsrc>!")
    }
    n <- 1
    m <- length(src)
  } else if (is.matrix(src)) {
    if (dim(src)[2] %% lsrc != 0) {
      stop("All <lsrc> time series must have the same number of initial conditions!")
    }
    n <- dim(src)[2] / lsrc
    m <- dim(src)[1]
  }

  # Check that <src> and <dst> have the same number of initial
  # conditions and time steps
  if (is.vector(dst)) {
    if (ldst != 1) {
      stop("<dst> has a different number of time series than what specified by <ldst>!")
    }
    if(length(dst) != m) {
      stop("<src>, <dst> and <back> must have the same number of time steps!")
    }
    if(n > 1) {
      stop("<src>, <dst> and <back> must have the same number of initial conditions!")
    }        
  } else if (is.matrix(dst)) {
    if (dim(dst)[2] %% ldst != 0) {
      stop("All <ldst> time series must have the same number of initial conditions!")
    }
    if(dim(dst)[1] != m) {
      stop("<src>, <dst> and <back> must have the same number of time steps!")
    }    
    if(dim(dst)[2] / ldst != n) {
      stop("<src>, <dst> and <back> must have the same number of initial conditions!")
    }    
  }

  if(!is.null(back)) {
    # Check that <src> and <back> have the same number of initial
    # conditions and time steps
    if (is.vector(back)) {
      if (lback != 1) {
        stop("<back> has a different number of time series than what specified by <lback>!")
      }
      if(length(back) != m) {
        stop("<src>, <dst> and <back> must have the same number of time steps!")
      }
      if(n > 1) {
        stop("<src>, <dst> and <back> must have the same number of initial conditions!")
      }        
    } else if (is.matrix(back)) {
      if (dim(back)[2] %% lback != 0) {
        stop("All <lback> time series must have the same number of initial conditions!")
      }
      if(dim(back)[1] != m) {
        stop("<src>, <dst> and <back> must have the same number of time steps!")
      }    
      if(dim(back)[2] / lback != n) {
        stop("<src>, <dst> and <back> must have the same number of initial conditions!")
      }
    }
  }

  # Compute the value of <b>
  if(is.null(back)) {  b <- max(2, max(src) + 1, max(dst) + 1) }
  else              {  b <- max(2, max(src) + 1, max(dst) + 1, max(back) + 1) }
  
  if (is.null(back)) {
    x <- .C("r_info_flow_",
            src      = as.integer(src),
            dst      = as.integer(dst),
            lsrc     = as.integer(lsrc),
            ldst     = as.integer(ldst),
	    n        = as.integer(n),
	    m        = as.integer(m),
	    b        = as.integer(b),
	    rval     = as.double(IF),
	    err      = as.integer(err))
  } else {
    x <- .C("r_info_flow_back_",
            src      = as.integer(src),
            dst      = as.integer(dst),
            back     = as.integer(back),
            lsrc     = as.integer(lsrc),
            ldst     = as.integer(ldst),
            lback    = as.integer(lback),
	    n        = as.integer(n),
	    m        = as.integer(m),
	    b        = as.integer(b),
	    rval     = as.double(IF),
	    err      = as.integer(err))
  }

  if (.check_inform_error(x$err) == 0) {
    IF <- x$rval
  }

  IF
}