################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Encode
#'
#' Encode a base-\code{b} array of integers into a single integer. This function
#' uses a big-endian encoding scheme. That is, the most significant bits of the
#' encoded integer are determined by the left-most end of the unencoded state.
#'     
#' @param state Vector of the state to encode.
#' @param b Numeric giving the base in which to encode.
#'
#' @return Numeric giving the encoded state.
#'
#' @example inst/examples/ex_encoding_encode.R
#'
#' @export
#'
#' @useDynLib rinform r_encode_
################################################################################
encode <- function(state, b = NA) {
  err     <- 0
  encoded <- 0

  if (!is.numeric(state)) {
    stop("<state> is not numeric")
  }

  if (is.matrix(state)) {
    stop("<state> is a matrix")
  }

  # Extract length of series
  n <- length(state)

  if (n == 0) {
    stop("cannot encode an empty array")
  }

  if (is.na(b)) {
    b <- max(2, max(state) + 1)
  }

  # Convert to integer vector suitable for C
  xs <- as.integer(state)

  x    <- .C("r_encode_",
             state   = xs,
	     n       = as.integer(n),
	     b       = as.integer(b),
	     encoded = as.integer(encoded),
	     err     = as.integer(err))
	    
  if (x$err == 0) {
    encoded <- x$encoded
  } else {
    stop("inform lib error (", x$err, ")")
  }

  encoded
}