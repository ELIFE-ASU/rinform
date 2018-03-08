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
                 histogram = as.integer(n),
	         size      = as.integer(length(n)),
	         counts    = as.integer(0),
	         err       = as.integer(err))
			  
    # Check if it is an array of integer values
    } else if (isTRUE(all(n == floor(n)))) {
      rval <- .C("r_dist_",
                 histogram = as.integer(n),
	         size      = as.integer(length(n)),
	         counts    = as.integer(0),
	         err       = as.integer(err))			  
    } else {
      stop("<n> is not a probability distribution nor a valid support")
    }

  } else {
    if (n <= 0) stop("<n> support is zero or negative")

    rval <- .C("r_dist_",
               histogram = as.integer(rep(0, n)),
	       size      = as.integer(n),
	       counts    = as.integer(0),
	       err       = as.integer(err))
  }

  if (err) stop("inform error - memory allocation error")
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
#' @importFrom methods is
#'
#' @keywords internal
################################################################################
is_not_corrupted <- function(d) {
  rval <- TRUE

  if (!is(d, "Dist")) {
    rval <- FALSE
    message("<d> is not of class Dist")
  } else if (!is.integer(d$histogram)) {
    rval <- FALSE  
    message("<d> object corrupted, histogram field is not integer")
  } else if (!is.integer(d$size)) {
    rval <- FALSE
    message("<d> object corrupted, size field is not integer")
  } else if (!is.integer(d$counts)) {
    rval <- FALSE
    message("<d> object corrupted, counts field is not integer")
  } else if (d$size != length(d$histogram)){
    rval <- FALSE
    message("<d> object corrupted, histogram lenght is different from support size")
  }

  rval
}

################################################################################
#' Length
#'
#' Method giving the size of the support of the distribution.
#'
#' @param x Dist object representing the distribution.
#'
#' @return Numeric giving the size of the support.
#'
#' @example inst/examples/ex_dist_length.R
#'
#' @export
#'
#' @useDynLib rinform r_length_
################################################################################
length.Dist <- function(x) {
  rval <- NULL
  err  <- 0

  if(.check_is_not_corrupted(x)) {
    rval <- .C("r_length_",
               histogram = x$histogram,
	       size      = x$size,
	       counts    = x$counts,
	       rval      = as.integer(0),
	       err       = as.integer(err))
    if (err) stop("inform lib memory allocation error")	       
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
#' @export 
################################################################################
get_item.Dist <- function(d, event) {
  rval <- NULL
  err  <- 0

  .check_is_not_corrupted(d)
  .check_event(event, length(d))
  
  rval <- .C("r_get_item_",
             histogram = d$histogram,
             size      = d$size,
             counts    = d$counts,
             event     = as.integer(event - 1),
             rval      = as.integer(0),
             err       =as.integer(err))
  if (err) stop("inform lib memory allocation error")		  		 

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
#' @return Dist giving the modified distribution.
#'
#' @example inst/examples/ex_dist_set_item.R
#'
#' @export
################################################################################
set_item <- function(d, event, value) UseMethod("set_item")

################################################################################
#' @useDynLib rinform r_set_item_
#' @export
################################################################################
set_item.Dist <- function(d, event, value) {
  err <- 0

  .check_is_not_corrupted(d)
  .check_event(event, length(d))
  
  value <- max(0, value)
  rval  <- .C("r_set_item_",
               histogram = d$histogram,
               size      = d$size,
	       counts    = d$counts,
	       event     = as.integer(event - 1),
	       value     = as.integer(value),
	       err       = as.integer(err))
		  
  if (err) stop("inform lib memory allocation error")
  
  d$histogram <- rval$histogram
  d$counts    <- rval$counts
  d
}

################################################################################
#' Resize
#'
#' Generic function to resize the support of the distribution in place. If the
#' distribution shrinks, the last \code{lenght(Dist) - n} elements are lost,
#' the rest are preserved. If it grows, the last \code{n - lenght(Dist)}
#' elements are zeroed.
#'
#' @param d Dist object representing the distribution.
#' @param n Numeric representing the desired size of the support.
#'
#' @return Dist giving the resized distribution.
#'
#' @example inst/examples/ex_dist_resize.R
#'
#' @export
################################################################################
resize <- function(d, n) UseMethod("resize")

################################################################################
#' @useDynLib rinform r_resize_
#' @export
################################################################################
resize.Dist <- function(d, n) {
  err <- 0
  
  if(.check_is_not_corrupted(d)) {
    if (is.numeric(n) & n > 0) {
      nhistogram <- rep(0, n)
      rval <- .C("r_resize_",
                 histogram  = d$histogram,
	         size       = d$size,
	         counts     = d$counts,
                 nhistogram = as.integer(nhistogram),
	         n          = as.integer(n),
	         err        = as.integer(err))

      if (err) stop("inform lib memory allocation error")

      d$histogram <- rval$nhistogram
      d$size      <- rval$size
      d$counts    <- rval$counts

    } else {
      stop("specified support size is not valid")
    }
  }
  d
}

################################################################################
#' Copy
#'
#' Generic function to perform a deep copy of the distribution.
#'
#' @param d Dist object representing the distribution to be copied.
#'
#' @return Dist giving the copy of the distribution.
#'
#' @example inst/examples/ex_dist_copy.R
#'
#' @export
################################################################################
copy <- function(d) UseMethod("copy")

################################################################################
#' @useDynLib rinform r_copy_
#' @export
################################################################################
copy.Dist <- function(d) {
  err    <- 0
  d_copy <- NULL
  
  if(.check_is_not_corrupted(d)) {
    rval <- .C("r_copy_",
                histogram  = d$histogram,
	        size       = d$size,
                chistogram = as.integer(rep(0, d$size)),
	        csize      = as.integer(0),
	        ccounts    = as.integer(0),
	        err        = as.integer(err))

    if (err) stop("inform lib memory allocation error")

    d_copy$histogram <- rval$chistogram
    d_copy$size      <- rval$csize
    d_copy$counts    <- rval$ccounts
    class(d_copy)    <- "Dist"

  }
  d_copy
}

################################################################################
#' Infer
#'
#' Infer a distribution from a collection of observed events.
#'
#' @param events Numeric giving a collection of observed events.
#'
#' @return Dist object inferred from \code{events}.
#'
#' @example inst/examples/ex_dist_infer.R
#'
#' @export
################################################################################
infer <- function(events) {
  err <- 0

  .check_series(events)

  events    <- as.integer(events)
  n         <- as.integer(length(events))
  histogram <- rep(0, max(max(events) + 1, 2))
  
  rval <- .C("r_infer_",
              n         = n,
	      events    = events,
	      histogram = as.integer(histogram),
	      err       = as.integer(err))

  if (err) stop("inform lib memory allocation error")

  d <- Dist(rval$histogram)
  d
}

################################################################################
#' Approximate
#'
#' Approximate a given probability distribution \code{probs} to a given
#' tolerance \code{tol}.
#'
#' @param probs Numeric vector giving a probability distribution.
#' @param tol Numeric giving the tolerance. 
#'
#' @return Dist object approximate from \code{probs} with tolerance \code{tol}.
#'
#' @example inst/examples/ex_dist_approximate.R
#'
#' @export
################################################################################
approximate <- function(probs, tol) {
  err <- 0

  .check_probability_vector(probs)

  if (!is.numeric(tol) | tol <= 0.0) {
    stop("parameter <tol> is invalid!")
  }

  probs <- as.double(probs)
  n     <- as.integer(length(probs))
  tol   <- as.double(tol)
  histogram <- rep(0, n)
  
  rval <- .C("r_approximate_",
             probs     = probs,
             n         = n,
	     tol       = tol,
	     histogram = as.integer(histogram),
	     err       = as.integer(err))

  if (err) stop("inform lib memory allocation error")

  d <- Dist(rval$histogram)
  d
}


################################################################################
#' Uniform
#'
#' Create a uniform distribution of a given size \code{n}.
#'
#' @param n Numeric giving the size of the support of the distribution.
#'
#' @return Dist object with support size \code{n}.
#'
#' @example inst/examples/ex_dist_uniform.R
#'
#' @export
################################################################################
uniform <- function(n) {
  err <- 0
  d   <- Dist(n)
  
  if(n > 0) {
    rval <- .C("r_uniform_",
                n          = as.integer(n),
                histogram  = d$histogram,
	        size       = d$size,
	        counts    = as.integer(0),
	        err        = as.integer(err))

    if (err) stop("inform lib memory allocation error")

    d$histogram <- rval$histogram
    d$size      <- rval$size
    d$counts    <- rval$counts
    class(d)    <- "Dist"
  } else {
    stop("Invalid support size")
  }
  d
}

################################################################################
#' Counts
#'
#' Generic function to return the number of observations made thus far.
#'
#' @param d Dist object representing the distribution.
#'
#' @return Numeric giving the number of observations.
#'
#' @example inst/examples/ex_dist_counts.R
#'
#' @export
################################################################################
counts <- function(d) UseMethod("counts")

################################################################################
#' @useDynLib rinform r_counts_
#' @export 
################################################################################
counts.Dist <- function(d) {
  err     <- 0
  rcounts <- 0
  
  .check_is_not_corrupted(d)
  
  rval <- .C("r_counts_",
             histogram = d$histogram,
             size      = d$size,
             rcounts   = as.integer(rcounts),
             err       = as.integer(err))

  if (err) stop("inform lib memory allocation error")
  
  rcounts <- rval$rcounts
  rcounts
}

################################################################################
#' Valid
#'
#' Generic function to determine if the distribution is a valid probability
#' distribution, i.e. if the support is not empty and at least one observation
#' has been made.
#'
#' @param d Dist object representing the distribution.
#'
#' @return Logical representing the validity of the distribution.
#'
#' @example inst/examples/ex_dist_valid.R
#'
#' @export
################################################################################
valid <- function(d) UseMethod("valid")

################################################################################
#' @useDynLib rinform r_valid_
#' @export
################################################################################
valid.Dist <- function(d) {
  err     <- 0
  isvalid <- FALSE
  
  if (.check_is_not_corrupted(d, only_warning = T)) {
    rval  <- .C("r_valid_",
                histogram = d$histogram,
                size      = d$size,
                isvalid   = as.integer(isvalid),
                err       = as.integer(err))
		
    if (err) stop("inform lib memory allocation error")
  
    if (rval$isvalid) isvalid <- TRUE
    else              isvalid <- FALSE  		
  }

  isvalid
}

################################################################################
#' Tick
#'
#' Generic function to make a single observation of \code{event}, and return
#' the a modified distribution with the updated number of observations of said
#' \code{event}.
#'
#' @param d Dist object representing the distribution.
#' @param event Numeric representing the observed event.
#'
#' @return Dist giving the updated distribution.
#'
#' @example inst/examples/ex_dist_tick.R
#'
#' @export
################################################################################
tick <- function(d, event) UseMethod("tick")

################################################################################
#' @useDynLib rinform r_tick_
#' @export
################################################################################
tick.Dist <- function(d, event) {
  err <- 0

  .check_is_not_corrupted(d)
  .check_event(event, length(d))
  
  rval  <- .C("r_tick_",
              histogram = d$histogram,
	      size      = d$size,
	      counts    = d$counts,
	      event     = as.integer(event - 1),
	      err       = as.integer(err))

  if (err) stop("inform lib memory allocation error")

  d$histogram <- rval$histogram
  d$size      <- rval$size
  d$counts    <- rval$counts
  
  d
}


################################################################################
#' Accumulate
#'
#' Generic function to make accumulate observations from a series. If an invalid
#' distribution is provided, no events will be observed. If an invalid event is
#' provided, then the number of valid events to that point will be added to the
#' distribution and a warning will be raised.
#'
#' @param d Dist object representing the distribution.
#' @param events Numeric representing the observed events.
#'
#' @return Dist giving the updated distribution.
#'
#' @example inst/examples/ex_dist_accumulate.R
#'
#' @export
################################################################################
accumulate <- function(d, events) UseMethod("accumulate")

################################################################################
#' @useDynLib rinform r_accumulate_
#' @export
################################################################################
accumulate.Dist <- function(d, events) {
  err <- 0

  .check_is_not_corrupted(d)

  events <- as.integer(events)
  n      <- as.integer(length(events))
  
  rval  <- .C("r_accumulate_",
              histogram = d$histogram,
	      size      = d$size,
	      counts    = d$counts,
	      n         = n,
	      events    = events,
	      err       = as.integer(err))

  if (err) stop("inform lib memory allocation error")

  d$histogram <- rval$histogram
  d$size      <- rval$size
  d$counts    <- rval$counts

  if (rval$n < n) { warning(rval$n, " events added!\n") }
  d
}

################################################################################
#' Probability
#'
#' Generic function to compute the empirical probability of an \code{event}.
#'
#' @param d Dist object representing the distribution.
#' @param event Numeric representing the observed event.
#'
#' @return Numerical giving the empirical probability of \code{event}.
#'
#' @example inst/examples/ex_dist_probability.R
#'
#' @export
################################################################################
probability <- function(d, event) UseMethod("probability")

################################################################################
#' @useDynLib rinform r_probability_
#' @export
################################################################################
probability.Dist <- function(d, event) {
  err  <- 0
  prob <- 0

  .check_is_not_corrupted(d)
  .check_event(event, length(d))
  
  if(!valid(d)) {
    stop("invalid distribution")
  }
  
  rval <- .C("r_probability_",
             histogram = d$histogram,
             size      = d$size,
             event     = as.integer(event - 1),
             prob      = as.double(prob),
             err       = as.integer(err))

  if (err) stop("inform lib memory allocation error")

  prob <- rval$prob
  prob
}

################################################################################
#' Dump
#'
#' Generic function to compute the empirical probability of each observable
#' event and return the result as an array.
#'
#' @param d Dist object representing the distribution.
#'
#' @return Vector giving the empirical probabilities of all events.
#'
#' @example inst/examples/ex_dist_dump.R
#'
#' @export
################################################################################
dump <- function(d) UseMethod("dump")

################################################################################
#' @useDynLib rinform r_probability_
#' @export
################################################################################
dump.Dist <- function(d) {
  err  <- 0
  prob <- 0
  
  .check_is_not_corrupted(d)
  if(!valid(d)) {
    stop("invalid distribution")
  }  
  prob <- rep(0.0, length(d))
  rval <- .C("r_dump_",
              histogram = d$histogram,
              size      = d$size,
	      prob      = as.double(prob),
	      err       = as.integer(err))

  if (err) stop("inform lib memory allocation error")
  
  prob <- rval$prob
  prob
}
