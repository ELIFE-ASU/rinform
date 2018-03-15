################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################



################################################################################
#' Effective Information
#'
#' Compute the effective information from an n by n transition probability
#' matrix \code{tpm} given an intervention distribution \code{inter}.
#' If \code{inter} is \code{NULL}, then the uniform distribution over the n
#' states is used.
#'
#' @param tpm Matrix specifying the transition probability matrix.
#' @param inter Vector specifying the intervention distribution.
#'
#' @return Numeric giving the effective information.
#'
#' @example inst/examples/ex_effectiveinfo.R
#'
#' @export
#'
#' @useDynLib rinform r_effective_info_
#' @useDynLib rinform r_effective_info_uniform_
################################################################################
effective_info <- function(tpm, inter = NULL) {
  n   <- 0
  ei  <- 0
  err <- 0

  .check_tpm(tpm)
  if(!is.null(inter)) .check_probability_vector(inter)

  # Extract number of states
  n <- dim(tpm)[1]

  # Convert to integer vector suitable for C
  tpm <- as.double(tpm)

  if (is.null(inter)) {
    x <- .C("r_effective_info_uniform_",
            tpm     = tpm,
	    n       = as.integer(n),
	    rval    = as.double(ei),
	    err     = as.integer(err))	    
  } else {
    x <- .C("r_effective_info_",
            tpm     = tpm,
	    inter   = as.double(inter),
	    n       = as.integer(n),
	    rval    = as.double(ei),
	    err     = as.integer(err))
  }

  if (.check_inform_error(x$err) == 0) {
    ei <- x$rval
  }

  ei
}