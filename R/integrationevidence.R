################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################



################################################################################
#' Evidence of Integration
#'
#' Given a sequence of `n` observed states of `l` random variables (\code{series}),
#' compute the evidence of integration for each partitioning of the `l`
#' variables, and return the minimum and maximum evidence for each observation.
#' If the number of variables `l` is large, the user can test a small subset of
#' the partitioning schemata by providing a partitioning \code{parts} to increase
#' confidence that the system is integrated. In this case, the function computes
#' and returns the evidence of integration for each observation with respect to
#' the partitioning \code{parts}.
#'
#' @param series Matrix specifying two or more time series.
#' @param parts Vector giving a specific partitioning to use.
#'
#' @return A list containing minimum, \code{min}, and maximum, \code{max},
#'         values of integration for each observation and logicals indicating if
#' 	   the system is \code{integrated} or, if \code{parts} is provided,
#' 	   returns a vector giving the evidence of integration for each
#'         observations.
#'
#' @example inst/examples/ex_integration_evidence.R
#'
#' @export
#'
#' @useDynLib rinform r_integration_evidence_
#' @useDynLib rinform r_integration_evidence_parts_
################################################################################
integration_evidence <- function(series, parts = NULL) {
  l   <- 0
  n   <- 0
  eoi <- 0
  err <- 0

  .check_series(series)
  if(!is.null(parts)) {
    .check_series(parts)
    # Convert from R indexes to C indexes
    parts  <- parts - 1
    nparts <- max(parts) + 1
  }

  # Extract number of series and length
  if (is.matrix(series)) {
    l <- dim(series)[2]
    n <- dim(series)[1]
    b <- numeric(l)
    for (i in 1:l) b[i] <- max(2, max(series[, i]) + 1)    
  } else { stop("<series> is not a matrix!") }

  if (!is.null(parts)) {
    eoi <- numeric(n)
    x   <- .C("r_integration_evidence_parts_",
              series   = as.integer(series),
	      l        = as.integer(l),
	      n        = as.integer(n),
	      b        = as.integer(b),
	      parts    = as.integer(parts),
	      nparts   = as.integer(nparts),
	      evidence = as.double(eoi),
	      err      = as.integer(err))
	    
    if (.check_inform_error(x$err) == 0) {
      eoi <- as.numeric(x$evidence)
    }
  } else {
    eoi <- numeric(2 * n)
    x   <- .C("r_integration_evidence_",
              series   = as.integer(series),
	      l        = as.integer(l),
	      n        = as.integer(n),
	      b        = as.integer(b),
	      evidence = as.double(eoi),
	      err      = as.integer(err))
	    
    if (.check_inform_error(x$err) == 0) {
      eoi <- list(min        = as.numeric(x$evidence[1:n]),
                  max        = as.numeric(x$evidence[(n + 1):(2 * n)]),
		  integrated = x$evidence[1:n] > 0 & x$evidence[(n + 1):(2 * n)] > 0)
    }
  }

  eoi
}