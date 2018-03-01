################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Partitioning Time Series
#'
#' Description..
#'
#'
#' @param size Numeric specifying the number of items to partition.
#'
#' @return List of all possible partitionings of `size` items into different
#' subsets.
#'
#' @example inst/examples/ex_partitioning_series.R
#'
#' @export
#'
#' @useDynLib rinform r_partitioning_series_
################################################################################
partitioning_series <- function(size) {
  stop("This function is not yet wrapped!")

  if (!is.numeric(size)) {
    stop("<size> is not numeric!")
  }

  if (size %% 1 != 0) {
    stop("<size> is not a natural number!")
  }

  # Allocate memory..
  n <- .bell(size)

  x   <- .C("r_partitioning_series_",
	     size    = as.integer(size),
	     err     = as.integer(err))

  if (.check_inform_error(x$err) == 0) {
  
  }

}

.bell <- function(n) {
  stopifnot(is.numeric(n), length(n) == 1)
  if (n < 0 || floor(n) != ceiling(n)) 
      stop("Argument 'n' must be a whole number greater or equal zero.")
  if (n == 0 || n == 1) 
      return(1)
  B <- Bneu <- numeric(n)
  B[1] <- 1
  for (i in 1:(n - 1)) {
    Bneu[1] <- B[i]
    for (j in 2:(i + 1)) {
      Bneu[j] <- B[j - 1] + Bneu[j - 1]
    }
    B <- Bneu
  }
  Bneu[i + 1]
}