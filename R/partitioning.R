################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Partitioning
#'
#' Partition a number \code{n} of items into all possible different subsets.
#' The number of partitions is given by the Bell number `B_n'.
#'
#' @param n Numeric specifying the number of items of the set to partition.
#'
#' @return Matrix giving all possible partitioning schemata.
#'
#' @example inst/examples/ex_partitioning.R
#'
#' @export
#'
#' @useDynLib rinform r_partitioning_
################################################################################
partitioning <- function(n) {
  Bn  <- 0
  err <- 0

  if (!is.numeric(n)) {
    stop("<n> is not numeric!")
  }

  if (length(n) != 1) {
    stop("<n> has length greater than 1!")
  }

  n  <- as.integer(n)
  Bn <- .bell_number(n)
  P  <- as.integer(rep(0, Bn * n))
  
  x      <- .C("r_partitioning_", n = n, P = P)
  P      <- x$P
  dim(P) <- c(n, Bn)

  P + 1
}

.bell_number <- function (n) {
  Bn <- 0
  
  if (n == 0 | n == 1) {
    Bn <- 1
  } else {
    B1 <- rep(0, n)    
    B2 <- rep(0, n)
    B1[1] <- 1
    for (i in 1:(n - 1)) {
      B2[1] <- B1[i]
      for (j in 2:(i + 1)) {
        B2[j] <- B1[j - 1] + B2[j - 1]
      }
      B1 <- B2
    }
    Bn <- B2[i + 1]
  }
  Bn
}