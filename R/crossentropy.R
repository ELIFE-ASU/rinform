################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################



################################################################################
#' Cross Entropy
#'
#' Compute the cross entropy between the "true" and "unnatural" distributions
#' \code{p} and \code{q} from associated time series \code{ps} and \code{qs},
#' respectively. Cross entropy’s local variant is equivalent to the
#' self-information of \code{q}, and as such is implemented by the local block
#' entropy.
#'
#' @param ps Vector specifying a time series drawn from
#'        the true distribution.
#' @param qs Vector specifying a time series drawn from
#'        the unnatural distribution.
#'
#' @return Numeric giving the cross entropy.
#'
#' @example inst/examples/ex_crossentropy.R
#'
#' @export
#'
#' @useDynLib rinform r_cross_entropy_
################################################################################
cross_entropy <- function(ps, qs) {
  n   <- 0
  ce  <- 0
  err <- 0

  .check_series(ps)
  .check_series(qs)
  .check_series_vector(ps)
  .check_series_vector(qs)

  # Extract number of series and length
  if (length(ps) != length(qs)) {
    stop("<", deparse(substitute(ps)), "> and <", deparse(substitute(qs)), "> differ in length")
  }
  n <- length(qs)

  # Convert to integer vector suitable for C
  ps <- as.integer(ps)
  qs <- as.integer(qs)

  # Compute the value of <b>
  b <- max(2, max(ps) + 1, max(qs) + 1)

  x <- .C("r_cross_entropy_",
           ps      = as.integer(ps),
           qs      = as.integer(qs),
	   n       = as.integer(n),
	   b       = as.integer(b),
	   rval    = as.double(ce),
	   err     = as.integer(err))
	    
  if (.check_inform_error(x$err) == 0) {
    ce <- x$rval
  }

  ce
}