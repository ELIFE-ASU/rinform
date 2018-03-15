################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################



################################################################################
#' Transfer Entropy
#'
#' Compute the local or average transfer entropy from one time series \code{ys}
#' to another \code{xs} with target history length \code{k} conditioned on the
#' background \code{ws}.
#'
#' @param ys Vector or matrix specifying one or more source time series.
#' @param xs Vector or matrix specifying one or more destination time series.
#' @param ws Vector or matrix specifying one or more background time series.
#' @param k Integer giving the history length.
#' @param local Boolean specifying whether to compute the local transfer
#'        entropy.
#'
#' @return Numeric giving the average transfer entropy or a vector giving the
#'         local transfer entropy.
#'
#' @example inst/examples/ex_transferentropy.R
#'
#' @export
#'
#' @useDynLib rinform r_transfer_entropy_
#' @useDynLib rinform r_complete_transfer_entropy_
#' @useDynLib rinform r_local_transfer_entropy_
#' @useDynLib rinform r_local_complete_transfer_entropy_
################################################################################
transfer_entropy <- function(ys, xs, ws = NULL, k, local = FALSE) {
  l   <- 0
  n   <- 0
  m   <- 0
  te  <- 0
  err <- 0

  .check_series(ys)
  .check_series(xs)
  if(!is.null(ws)) .check_series(ws)
  .check_history(k)
  .check_local(local)

  # Extract number of series and length
  if (is.vector(xs) & is.vector(ys)) {
    if (length(xs) != length(ys)) {
      stop("<xs> and <ys> differ in length!")
    }
    n <- 1
    m <- length(xs)
  } else if (is.matrix(xs) & is.matrix(ys)) {
    if (dim(xs)[1] != dim(ys)[1] | dim(xs)[2] != dim(ys)[2]) {
      stop("<xs> and <ys> have different dimensions!")
    }
    n <- dim(xs)[2]
    m <- dim(xs)[1]
  }

  # Convert to integer vector suitable for C
  xs <- as.integer(xs)
  ys <- as.integer(ys)

  # Compute the value of <b>
  b <- max(2, max(xs) + 1, max(ys) + 1)

  # Extract number of series and length of the background
  if (!is.null(ws)) {
    if (is.vector(ws)) {
      if (length(ws) != m) {
        stop("<ws> differ in number of time steps!")
      }
      if (n != 1) {
        stop("<ws> differ in number of time series!")
      }
      l <- 1
    } else if (is.matrix(ws)) {
      if (dim(ws)[1] != m) {
        stop("<ws> differ in number of time steps!")
      }
      if (dim(ws)[2] %% n != 0) {
        stop("<ws> differ in number of time series!")
      }
      l <- dim(ws)[2] / n
    } else { stop("<ws> is not a vector or a matrix!") }

    # Convert to integer vector suitable for C
    ws <- as.integer(ws)

    # Compute the value of <b>
    b <- max(2, max(xs) + 1, max(ys) + 1, max(ws) + 1)
  }

  if (!local) {
    if (l == 0) {
      x <- .C("r_transfer_entropy_",
              ys      = ys,
	      xs      = xs,
	      n       = as.integer(n),
	      m       = as.integer(m),
	      b       = as.integer(b),
	      k       = as.integer(k),
	      rval    = as.double(te),
	      err     = as.integer(err))
    } else {
      x <- .C("r_complete_transfer_entropy_",
              ys      = ys,
	      xs      = xs,
	      ws      = ws,
	      l       = as.integer(l),
	      n       = as.integer(n),
	      m       = as.integer(m),
	      b       = as.integer(b),
	      k       = as.integer(k),
	      rval    = as.double(te),
	      err     = as.integer(err))
    }
	    
    if (.check_inform_error(x$err) == 0) {
      te <- x$rval
    }
  } else {
    te <- rep(0, (m - k) * n)
    if (l == 0) {
      x <- .C("r_local_transfer_entropy_",
              ys      = ys,
	      xs      = xs,
	      n       = as.integer(n),
	      m       = as.integer(m),
	      b       = as.integer(b),
	      k       = as.integer(k),
	      rval    = as.double(te),
	      err     = as.integer(err))
    } else{
      x <- .C("r_local_complete_transfer_entropy_",
              ys      = ys,
	      xs      = xs,
	      ws      = ws,
	      l       = as.integer(l),
	      n       = as.integer(n),
	      m       = as.integer(m),
	      b       = as.integer(b),
	      k       = as.integer(k),
	      rval    = as.double(te),
	      err     = as.integer(err))
    }
    
    if (.check_inform_error(x$err) == 0) {
      te      <- x$rval
      dim(te) <- c(m - k, n)
    }
  }

  te
}