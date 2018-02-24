################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Mutual Information
#'
#' Compute the average or the local mutual information between two or more time series.
#' Each variable can have a different base.
#'
#' @param series Matrix specifying a set of time series.
#' @param local Boolean specifying whether to compute the local mutual
#'        information.
#'
#' @return Numeric giving the average mutual information or a vector giving the
#'         local mutual information.
#'
#' @example inst/examples/ex_mutualinfo.R
#'
#' @export
#'
#' @useDynLib rinform r_mutual_info_
#' @useDynLib rinform r_local_mutual_info_
################################################################################
mutual_info <- function(series, local = FALSE) {
  n   <- 0
  l   <- 0  
  mi  <- 0
  err <- 0

  .check_series(series)
  .check_series_num_variables(series)
  .check_local(local)

  n <- dim(series)[1]
  l <- dim(series)[2]

  # Compute the value of <b>
  b        <- apply(series, 2, max) + 1
  b[b < 2] <- 2  

  if (!local) {
    x <- .C("r_mutual_info_",
            series  = as.integer(series),
	    l       = as.integer(l),
	    n       = as.integer(n),
	    b       = as.integer(b),
	    rval    = as.double(mi),
	    err     = as.integer(err))

    if (.check_inform_error(x$err) == 0) {
      mi <- x$rval
    }
  } else {
    mi <- rep(0, n)
    x <- .C("r_local_mutual_info_",
            series  = as.integer(series),
	    l       = as.integer(l),
	    n       = as.integer(n),
	    b       = as.integer(b),
	    rval    = as.double(mi),
	    err     = as.integer(err))
	    
    if (.check_inform_error(x$err) == 0) {
      mi <- x$rval
    }    
  }

  mi
}