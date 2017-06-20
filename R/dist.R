################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Construct a distribution
#'
#' If the parameter \code{n} is an integer, the distribution is constructed
#' with a zeroed support of size \code{n}. If \code{n} is a vector of integer
#' values, the sequence is treated as the underlying support. On the other hand,
#' if \code{n} is a vector of floating point values, it is treated as a
#' probability distribution and must sum to unity. Note, if a probability
#' distribution is given as the underlying support, it will first be converted
#' to a histogram with a precision of 9 significant figures.
#'
#' @param n Vector or matrix specifying one or more time series.
#'
#' @return An initialized object of class Dist.
#'
#' @example inst/examples/ex_dist.R
#'
#' @export
#'
#' @useDynLib rinform r_dist_
################################################################################
Dist <- function(n) {
  Dist <- NULL
  rval <- NULL
  err  <- 0
  
  if (!is.numeric(n)) stop("<n> must be numeric")
  if (!is.vector(n))  stop("<n> support is multidimensional")

  # Check if it is a vecotor or a scalar
  if (length(n) > 1) {
    # Check if it is a probability distribution
    if (sum(n >= 0 & n <= 1.0) == length(n) & isTRUE(all.equal(sum(n), 1.0))) {
      n    <- round(n, digits=9) * 1e9
      rval <- .C("r_dist_",
                 histogram  = as.integer(n),
	         size       = as.integer(length(n)),
	         counts     = as.integer(0),
	         err        = as.integer(err))
			  
    # Check if it is an array of integer values
    } else if (isTRUE(all(n == floor(n)))) {
      rval <- .C("r_dist_",
                 histogram  = as.integer(n),
	         size       = as.integer(length(n)),
	         counts     = as.integer(0),
	         err        = as.integer(err))			  
    } else {
      stop("<n> is not a probability distribution nor a valid support")
    }

  } else {
    if (n <= 0) stop("<n> support is zero or negative")

    rval <- .C("r_dist_",
               histogram  = as.integer(rep(0, n)),
	       size       = as.integer(n),
	       counts     = as.integer(0),
	       err        = as.integer(err))
  }

  if (err) stop("infrom lib memory allocation error")
  Dist        <- list(histogram = rval$histogram,
                      size      = rval$size,
	              counts    = rval$counts)    
  class(Dist) <- "Dist"
  
  Dist
}

################################################################################
#' Validity of the Dist object
#'
#' Checks if the object \code{d} is not corrupted.
#'
#' @param d Dist object representing the distribution.
#'
#' @return Logical signifying that the object is not corrupted.
#'
#' @example inst/examples/ex_dist_is_not_corrupted.R
#'
#' @keywords internal
################################################################################
is_not_corrupted <- function(d) {
  rval <- TRUE

  if (!is(d, "Dist")) {
    rval <- FALSE
    warning("<d> is not of class Dist")
  } else if (!is.integer(d$histogram)) {
    rval <- FALSE  
    warning("<d> object corrupted, histogram field is not integer")
  } else if (!is.integer(d$size)) {
    rval <- FALSE
    warning("<d> object corrupted, size field is not integer")
  } else if (!is.integer(d$counts)) {
    rval <- FALSE
    warning("<d> object corrupted, counts field is not integer")
  } else if (d$size != length(d$histogram)){
    rval <- FALSE
    warning("<d> object corrupted, histogram lenght is different from support size")
  }

  rval
}

################################################################################
#' Length
#'
#' Method giving the size of the support of the distribution.
#'
#' @param d Dist object representing the distribution.
#'
#' @return Numeric giving the size of the support.
#'
#' @example inst/examples/ex_dist_length.R
#'
#' @export
#'
#' @useDynLib rinform r_length_
################################################################################
length.Dist <- function(d) {
  rval <- NULL
  
  if(is_not_corrupted(d)) {
    rval <- .C("r_length_",
               histogram  = d$histogram,
	       size       = d$size,
	       counts     = d$counts,
	       rval       = as.integer(0))
  } else {
    stop("<d> object corrupted")
  }

  rval$rval
}

################################################################################
#' Get Item
#'
#' Generic function giving the number of observations made of \code{event}.
#'
#' @param d Dist object representing the distribution.
#' @param event Numeric representing the observed event.
#'
#' @return Numeric giving the number of observation of \code{event}.
#'
#' @example inst/examples/ex_dist_get_item.R
#'
#' @export
################################################################################
get_item <- function(d, event) UseMethod("get_item")

################################################################################
#' @useDynLib rinform r_get_item_
################################################################################
get_item.Dist <- function(d, event) {
  rval <- NULL
  
  if(is_not_corrupted(d)) {
    if (event > 0 & event <= length(d)) {
      rval <- .C("r_get_item_",
                 histogram  = d$histogram,
	         size       = d$size,
	         counts     = d$counts,
	         event      = as.integer(event - 1),
	         rval       = as.integer(0))
    } else {
      stop("<event> out of bound")
    }
  } else {
    stop("<d> object corrupted")
  }

  rval$rval
}

################################################################################
#' Set Item
#'
#' Generic function setting the number of observations made of \code{event}.
#'
#' @param d Dist object representing the distribution.
#' @param event Numeric representing the observed event.
#' @param value Numeric representing the number of observations.
#'
#' @example inst/examples/ex_dist_set_item.R
#'
#' @export
################################################################################
set_item <- function(d, event, value) UseMethod("set_item")

################################################################################
#' @useDynLib rinform r_set_item_
################################################################################
set_item.Dist <- function(d, event, value) {
  
  if(is_not_corrupted(d)) {
    if (event > 0 & event <= length(d)) {
      value <- max(0, value)
      rval  <- .C("r_set_item_",
                  histogram  = d$histogram,
	          size       = d$size,
	          counts     = d$counts,
	          event      = as.integer(event - 1),
	          value      = as.integer(value))
      d$histogram <- rval$histogram
      d$counts    <- rval$counts

    } else {
      stop("<event> out of bound")
    }
  } else {
    stop("<d> object corrupted")
  }
  d
}