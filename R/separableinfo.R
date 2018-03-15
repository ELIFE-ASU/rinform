################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################



################################################################################
#' Separable Information
#'
#' Compute the average or local separable information of \code{dest} given a
#' set of sources \code{srcs} and history length \code{k}.
#'
#' @param srcs Vector or matrix specifying one or more sources.
#' @param dest Vector or matrix specifying one destination.
#' @param k Integer giving the history length.
#' @param local Boolean specifying whether to compute the local or average
#'        separable information.
#'
#' @return Numeric giving the average separable information or a vector giving
#'         the local separable information.
#'
#' @example inst/examples/ex_separable_info.R
#'
#' @export
#'
#' @useDynLib rinform r_separable_info_
#' @useDynLib rinform r_local_separable_info_
################################################################################
separable_info <- function(srcs, dest, k, local = FALSE) {
  l   <- 0
  n   <- 0
  m   <- 0
  si  <- 0
  err <- 0

  .check_series(srcs)
  .check_series(dest)
  .check_history(k)
  .check_local(local)

  # Extract number of initial conditions and time steps
  if (is.vector(dest)) {
    n <- 1
    m <- length(dest)
  } else if (is.matrix(dest)) {
    n <- dim(dest)[2]
    m <- dim(dest)[1]
  } else { stop("<dest> is not a vector or a matrix!") }

  # Extract number of sources
  if (is.vector(srcs)) {
    if (length(srcs) != m) {
      stop("<srcs> and <dest> differ in number of time steps!")
    }
    if (n != 1) {
      stop("<srcs> define insufficient number of initial conditions!")
    }
    l <- 1
  } else if (is.matrix(srcs)) {
    if (dim(srcs)[1] != m) {
      stop("<srcs> and <dest> differ in number of time steps!")
    }
    if (dim(srcs)[2] %% n != 0) {
      stop("<srcs> define insufficient number of initial conditions!")
    }
    l <- dim(srcs)[2] / n
  } else { stop("<srcs> is not a vector or a matrix!") }

  # Compute the value of <b>
  b <- max(2, max(dest) + 1, max(srcs) + 1)

  if (!local) {
    x <- .C("r_separable_info_",
            srcs      = as.integer(srcs),
            dest      = as.integer(dest),
            l         = as.integer(l),
	    n         = as.integer(n),
	    m         = as.integer(m),
	    b         = as.integer(b),
	    k         = as.integer(k),
	    rval      = as.double(si),
	    err       = as.integer(err))
	    
    if (.check_inform_error(x$err) == 0) {
      si <- x$rval
    }
    
  } else {
    si <- rep(0, (m - k) * n)
    x <- .C("r_local_separable_info_",
            srcs      = as.integer(srcs),
            dest      = as.integer(dest),
            l         = as.integer(l),
	    n         = as.integer(n),
	    m         = as.integer(m),
	    b         = as.integer(b),
	    k         = as.integer(k),
	    rval      = as.double(si),
	    err       = as.integer(err))
    
    if (.check_inform_error(x$err) == 0) {
      si      <- x$rval
      dim(si) <- c(m - k, n)
    }
  }

  si
}