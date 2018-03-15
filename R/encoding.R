################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
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

  .check_series(state)
  .check_series_vector(state)

  # Extract length of <state>
  n <- length(state)

  if (n == 0) {
    stop("<", deparse(substitute(state)), "> is an empty array!")
  }

  if (is.na(b)) {
    b <- max(2, max(state) + 1)
  } else {
    .check_base(b)
  }

  # Convert to integer vector suitable for C
  xs <- as.integer(state)

  x  <- .C("r_encode_",
            state   = xs,
	    n       = as.integer(n),
	    b       = as.integer(b),
	    encoded = as.integer(encoded),
            err     = as.integer(err))
	    
  if (.check_inform_error(x$err) == 0) {
    encoded <- x$encoded
  }

  encoded
}

################################################################################
#' Decode
#'
#' Decode an integer into a base-\code{b} array with \code{n} digits. Note that
#' the base \code{b} must be provided, but the number of digits \code{n} is
#' optional. If it is provided then the decoded state will have exactly that
#' many elements. If \code{n} is not provided, the length of the decoded state
#' is as small as possible.
#'     
#' @param encoding Numeric of the encoded state.
#' @param b Numeric giving the desired base.
#' @param n Numeric giving the desired number of digits.
#'
#' @return Vector giving the decoded state.
#'
#' @example inst/examples/ex_encoding_decode.R
#'
#' @export
#'
#' @useDynLib rinform r_decode_
################################################################################
decode <- function(encoding, b, n = NA) {
  err   <- 0
  state <- 0

  .check_series(encoding)
  .check_series_vector(encoding)  
  .check_base(b)
  
  # Extract length of encoding
  en <- length(encoding)

  if (en == 0) {
    stop("<", deparse(substitute(encoding)), "> is an empty encoding!")
  }

  if (en > 1) {
    stop("<", deparse(substitute(encoding)), "> is an array of encodings!")
  }
  
  b <- max(2, b)

  if (is.na(n)) {
    state <- rep(0, times = 32)
  } else {
    state <- rep(0, times = n)
  }

  x <- .C("r_decode_",
          encoding = as.integer(encoding),
	  b        = as.integer(b),
	  state    = as.integer(state),
	  n        = as.integer(length(state)),
	  err      = as.integer(err))

  if (.check_inform_error(x$err) == 0) {
    if (!is.na(n)) {
      state <- x$state
    } else {
      # Remove leading zeros
      state <- x$state[min(which(x$state != 0)):length(x$state)]
    }
  }

  state
}