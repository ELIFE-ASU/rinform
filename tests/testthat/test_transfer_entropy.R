################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################
library(rinform)
context("Transfer Entropy")

test_that("transfer_entropy checks parameters", {
  xs <- sample(0:1, 10, T)
  ys <- sample(0:1, 10, T)
  
  expect_error(transfer_entropy("series", ys, ws = NULL, k = 1, local = !T))
  expect_error(transfer_entropy(NULL,     ys, ws = NULL, k = 1, local = !T))
  expect_error(transfer_entropy(NA,       ys, ws = NULL, k = 1, local = !T))
  
  expect_error(transfer_entropy(xs, "series", ws = NULL, k = 1, local = !T))
  expect_error(transfer_entropy(xs, NULL,     ws = NULL, k = 1, local = !T))
  expect_error(transfer_entropy(xs, NA,       ws = NULL, k = 1, local = !T))

  expect_error(transfer_entropy(xs, ys, ws = NULL, k = "k", local = !T))
  expect_error(transfer_entropy(xs, ys, ws = NULL, k = NULL, local = !T))
  expect_error(transfer_entropy(xs, ys, ws = NULL, k = NA, local = !T))
  expect_error(transfer_entropy(xs, ys, ws = NULL, k = 0, local = !T))
  expect_error(transfer_entropy(xs, ys, ws = NULL, k = -1, local = !T))

  expect_error(transfer_entropy(xs, ys, ws = NULL, k = 1, local = "TRUE"))
  expect_error(transfer_entropy(xs, ys, ws = NULL, k = 1, local = NULL))
  expect_error(transfer_entropy(xs, ys, ws = NULL, k = 1, local = NA))
})

test_that("transfer_entropy on single series", {
  xs <- c(1, 1, 1, 0, 0); ys <- c(1, 1, 0, 0, 1)
  expect_equal(transfer_entropy(xs, xs, NULL, k = 2, local = !T),
               0.000000, tolerance = 1e-6)
  expect_equal(transfer_entropy(ys, xs, NULL, k = 2, local = !T),
               0.666666, tolerance = 1e-6)
  expect_equal(transfer_entropy(xs, ys, NULL, k = 2, local = !T),
               0.000000, tolerance = 1e-6)
  expect_equal(transfer_entropy(ys, ys, NULL, k = 2, local = !T),
               0.000000, tolerance = 1e-6)

  xs <- c(0, 0, 1, 1, 1, 0, 0, 0, 0, 1); ys <- c(1, 1, 0, 0, 0, 0, 0, 0, 1, 1)
  expect_equal(transfer_entropy(xs, xs, NULL, k = 2, local = !T),
               0.000000, tolerance = 1e-6)
  expect_equal(transfer_entropy(ys, xs, NULL, k = 2, local = !T),
               0.500000, tolerance = 1e-6)
  expect_equal(transfer_entropy(xs, ys, NULL, k = 2, local = !T),
               0.106844, tolerance = 1e-6)
  expect_equal(transfer_entropy(ys, ys, NULL, k = 2, local = !T),
               0.000000, tolerance = 1e-6)

  xs <- c(0, 1, 0, 1, 0, 0, 1, 1, 0, 0); ys <- c(0, 0, 1, 0, 1, 1, 1, 0, 1, 1)
  expect_equal(transfer_entropy(xs, xs, NULL, k = 2, local = !T),
               0.000000, tolerance = 1e-6)
  expect_equal(transfer_entropy(ys, xs, NULL, k = 2, local = !T),
               0.344361, tolerance = 1e-6)
  expect_equal(transfer_entropy(xs, ys, NULL, k = 2, local = !T),
               0.250000, tolerance = 1e-6)
  expect_equal(transfer_entropy(ys, ys, NULL, k = 2, local = !T),
               0.000000, tolerance = 1e-6)
})

test_that("transfer_entropy on ensemble of series", {
  xs      <- matrix(0, nrow = 10, ncol = 5)
  xs[, 1] <- c(1, 1, 1, 0, 0, 1, 1, 0, 1, 0)
  xs[, 2] <- c(0, 1, 0, 1, 1, 1, 0, 0, 0, 0)
  xs[, 3] <- c(0, 0, 0, 1, 0, 0, 0, 1, 0, 0)
  xs[, 4] <- c(0, 0, 1, 0, 0, 0, 1, 0, 0, 1)
  xs[, 5] <- c(0, 0, 1, 1, 1, 1, 1, 0, 0, 0)
  
  ys      <- matrix(0, nrow = 10, ncol = 5)
  ys[, 1] <- c(0, 1, 0, 0, 0, 1, 0, 1, 1, 0)
  ys[, 2] <- c(0, 0, 0, 1, 1, 1, 0, 1, 0, 0)
  ys[, 3] <- c(1, 0, 1, 0, 1, 0, 0, 0, 1, 0)
  ys[, 4] <- c(0, 1, 1, 0, 1, 1, 1, 1, 1, 1)
  ys[, 5] <- c(0, 0, 1, 1, 0, 0, 0, 0, 0, 1)

  expect_equal(transfer_entropy(xs, xs, NULL, k = 2, local = !T),
               0.000000, tolerance = 1e-6)
  expect_equal(transfer_entropy(ys, xs, NULL, k = 2, local = !T),
               0.091141, tolerance = 1e-6)
  expect_equal(transfer_entropy(xs, ys, NULL, k = 2, local = !T),
               0.107630, tolerance = 1e-6)
  expect_equal(transfer_entropy(ys, ys, NULL, k = 2, local = !T),
               0.000000, tolerance = 1e-6)

  xs <- xs[, 1:4]; ys <- ys[, 1:4]
  expect_equal(transfer_entropy(xs, xs, NULL, k = 2, local = !T),
               0.000000, tolerance = 1e-6)
  expect_equal(transfer_entropy(ys, xs, NULL, k = 2, local = !T),
               0.134536, tolerance = 1e-6)
  expect_equal(transfer_entropy(xs, ys, NULL, k = 2, local = !T),
               0.089517, tolerance = 1e-6)
  expect_equal(transfer_entropy(ys, ys, NULL, k = 2, local = !T),
               0.000000, tolerance = 1e-6)

})

test_that("transfer_entropy complete", {
  xs   <- c(0, 0, 1, 1, 1, 0, 1, 1, 0)
  ys   <- c(1, 0, 1, 1, 0, 1, 0, 1, 1)
  back <- matrix(c(0, 0, 1, 1, 0, 0, 0, 1, 0,
                   0, 1, 1, 0, 0, 1, 0, 0, 1), ncol = 2)
  expect_equal(transfer_entropy(ys, xs, back, k = 2, local = !T),
               0.000000, tolerance = 1e-6)
  expect_equal(transfer_entropy(xs, ys, back, k = 2, local = !T),
               0.000000, tolerance = 1e-6)

  xs   <- c(0, 0, 0, 1, 1, 1, 0, 0, 0)
  ys   <- c(0, 0, 1, 1, 1, 0, 0, 0, 1)
  back <- c(0, 0, 1, 0, 1, 1, 0, 1, 0)
  expect_equal(transfer_entropy(ys, xs, back, k = 2, local = !T),
               0.571429, tolerance = 1e-6)
  expect_equal(transfer_entropy(xs, ys, back, k = 2, local = !T),
               0.000000, tolerance = 1e-6)

  xs   <- c(0, 0, 0, 1, 1, 1, 0, 0, 0)
  ys   <- c(0, 0, 1, 1, 1, 0, 0, 0, 1)
  back <- matrix(c(0, 0, 1, 0, 1, 1, 0, 1, 0,
                   0, 0, 0, 1, 1, 0, 1, 0, 0), ncol = 2)
  expect_equal(transfer_entropy(ys, xs, back, k = 2, local = !T),
               0.285714, tolerance = 1e-6)
  expect_equal(transfer_entropy(xs, ys, back, k = 2, local = !T),
               0.000000, tolerance = 1e-6)

  xs   <- c(0, 0, 0, 1, 1, 1, 0, 0, 0)
  ys   <- c(0, 0, 1, 1, 1, 0, 0, 0, 1)
  back <- matrix(c(0, 0, 1, 0, 1, 1, 0, 1, 0,
                  1, 1, 0, 1, 0, 0, 1, 0, 1), ncol = 2)
  expect_equal(transfer_entropy(ys, xs, back, k = 2, local = !T),
               0.571429, tolerance = 1e-6)
  expect_equal(transfer_entropy(xs, ys, back, k = 2, local = !T),
               0.000000, tolerance = 1e-6)

})

test_that("transfer_entropy local on single series", {
  xs <- c(1, 1, 1, 0, 0); ys <- c(1, 1, 0, 0, 1)
  expect_equal(mean(transfer_entropy(xs, xs, NULL, k = 2, local = T)),
               0.000000, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(ys, xs, NULL, k = 2, local = T)),
               0.666666, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(xs, ys, NULL, k = 2, local = T)),
               0.000000, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(ys, ys, NULL, k = 2, local = T)),
               0.000000, tolerance = 1e-6)

  xs <- c(0, 0, 1, 1, 1, 0, 0, 0, 0, 1); ys <- c(1, 1, 0, 0, 0, 0, 0, 0, 1, 1)
  expect_equal(mean(transfer_entropy(xs, xs, NULL, k = 2, local = T)),
               0.000000, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(ys, xs, NULL, k = 2, local = T)),
               0.500000, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(xs, ys, NULL, k = 2, local = T)),
               0.106844, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(ys, ys, NULL, k = 2, local = T)),
               0.000000, tolerance = 1e-6)

  xs <- c(0, 1, 0, 1, 0, 0, 1, 1, 0, 0); ys <- c(0, 0, 1, 0, 1, 1, 1, 0, 1, 1)
  expect_equal(mean(transfer_entropy(xs, xs, NULL, k = 2, local = T)),
               0.000000, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(ys, xs, NULL, k = 2, local = T)),
               0.344361, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(xs, ys, NULL, k = 2, local = T)),
               0.250000, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(ys, ys, NULL, k = 2, local = T)),
               0.000000, tolerance = 1e-6)
})

test_that("transfer_entropy local on ensemble of series", {
  xs      <- matrix(0, nrow = 10, ncol = 5)
  xs[, 1] <- c(1, 1, 1, 0, 0, 1, 1, 0, 1, 0)
  xs[, 2] <- c(0, 1, 0, 1, 1, 1, 0, 0, 0, 0)
  xs[, 3] <- c(0, 0, 0, 1, 0, 0, 0, 1, 0, 0)
  xs[, 4] <- c(0, 0, 1, 0, 0, 0, 1, 0, 0, 1)
  xs[, 5] <- c(0, 0, 1, 1, 1, 1, 1, 0, 0, 0)
  
  ys      <- matrix(0, nrow = 10, ncol = 5)
  ys[, 1] <- c(0, 1, 0, 0, 0, 1, 0, 1, 1, 0)
  ys[, 2] <- c(0, 0, 0, 1, 1, 1, 0, 1, 0, 0)
  ys[, 3] <- c(1, 0, 1, 0, 1, 0, 0, 0, 1, 0)
  ys[, 4] <- c(0, 1, 1, 0, 1, 1, 1, 1, 1, 1)
  ys[, 5] <- c(0, 0, 1, 1, 0, 0, 0, 0, 0, 1)

  expect_equal(mean(transfer_entropy(xs, xs, NULL, k = 2, local = T)),
               0.000000, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(ys, xs, NULL, k = 2, local = T)),
               0.091141, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(xs, ys, NULL, k = 2, local = T)),
               0.107630, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(ys, ys, NULL, k = 2, local = T)),
               0.000000, tolerance = 1e-6)

  xs <- xs[, 1:4]; ys <- ys[, 1:4]
  expect_equal(mean(transfer_entropy(xs, xs, NULL, k = 2, local = T)),
               0.000000, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(ys, xs, NULL, k = 2, local = T)),
               0.134536, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(xs, ys, NULL, k = 2, local = T)),
               0.089517, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(ys, ys, NULL, k = 2, local = T)),
               0.000000, tolerance = 1e-6)

})

test_that("transfer_entropy local complete", {
  xs   <- c(0, 0, 1, 1, 1, 0, 1, 1, 0)
  ys   <- c(1, 0, 1, 1, 0, 1, 0, 1, 1)
  back <- matrix(c(0, 0, 1, 1, 0, 0, 0, 1, 0,
                   0, 1, 1, 0, 0, 1, 0, 0, 1), ncol = 2)
  expect_equal(mean(transfer_entropy(ys, xs, back, k = 2, local = T)),
               0.000000, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(xs, ys, back, k = 2, local = T)),
               0.000000, tolerance = 1e-6)

  xs   <- c(0, 0, 0, 1, 1, 1, 0, 0, 0)
  ys   <- c(0, 0, 1, 1, 1, 0, 0, 0, 1)
  back <- c(0, 0, 1, 0, 1, 1, 0, 1, 0)
  expect_equal(mean(transfer_entropy(ys, xs, back, k = 2, local = T)),
               0.571429, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(xs, ys, back, k = 2, local = T)),
               0.000000, tolerance = 1e-6)

  xs   <- c(0, 0, 0, 1, 1, 1, 0, 0, 0)
  ys   <- c(0, 0, 1, 1, 1, 0, 0, 0, 1)
  back <- matrix(c(0, 0, 1, 0, 1, 1, 0, 1, 0,
                  0, 0, 0, 1, 1, 0, 1, 0, 0), ncol = 2)
  expect_equal(mean(transfer_entropy(ys, xs, back, k = 2, local = T)),
               0.285714, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(xs, ys, back, k = 2, local = T)),
               0.000000, tolerance = 1e-6)
	       
  xs   <- c(0, 0, 0, 1, 1, 1, 0, 0, 0)
  ys   <- c(0, 0, 1, 1, 1, 0, 0, 0, 1)
  back <- matrix(c(0, 0, 1, 0, 1, 1, 0, 1, 0,
                  1, 1, 0, 1, 0, 0, 1, 0, 1), ncol = 2)
  expect_equal(mean(transfer_entropy(ys, xs, back, k = 2, local = T)),
               0.571429, tolerance = 1e-6)
  expect_equal(mean(transfer_entropy(xs, ys, back, k = 2, local = T)),
               0.000000, tolerance = 1e-6)
})
