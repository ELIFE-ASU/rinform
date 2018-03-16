################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################
library(rinform)
context("Entropy Rate")

test_that("entropy_rate checks parameters", {
  xs <- sample(0:1, 10, T)
  expect_error(entropy_rate("series", k = 1, local = !T))
  expect_error(entropy_rate(NULL,     k = 1, local = !T))
  expect_error(entropy_rate(NA,       k = 1, local = !T))
  
  expect_error(entropy_rate(xs, k = "k",  local = !T))
  expect_error(entropy_rate(xs, k = NULL, local = !T))
  expect_error(entropy_rate(xs, k = NA,   local = !T))  
  expect_error(entropy_rate(xs, k = 0,    local = !T))
  expect_error(entropy_rate(xs, k = -1,   local = !T))
  
  expect_error(entropy_rate(xs, k = 1, local = "TRUE"))
  expect_error(entropy_rate(xs, k = 1, local = NULL))
  expect_error(entropy_rate(xs, k = 1, local = NA))  
})

test_that("entropy_rate on single series", {
  expect_equal(entropy_rate(c(1, 1, 0, 0, 1, 0, 0, 1),
                           k = 2, local = !T), 0.000000, tolerance = 1e-6)
  expect_equal(entropy_rate(c(1, 0, 0, 0, 0, 0, 0, 0, 0),
                           k = 2, local = !T), 0.000000, tolerance = 1e-6)
  expect_equal(entropy_rate(c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                           k = 2, local = !T), 0.679270, tolerance = 1e-6)
  expect_equal(entropy_rate(c(1, 0, 0, 0, 0, 0, 0, 1, 1),
                           k = 2, local = !T), 0.515663, tolerance = 1e-6)
  expect_equal(entropy_rate(c(3, 3, 3, 2, 1, 0, 0, 0, 1),
                           k = 2, local = !T), 0.571428, tolerance = 1e-6)
  expect_equal(entropy_rate(c(2, 2, 3, 3, 3, 3, 2, 1, 0),
                           k = 2, local = !T), 0.393556, tolerance = 1e-6)
  expect_equal(entropy_rate(c(2, 2, 2, 2, 2, 2, 1, 1, 1),
                           k = 2, local = !T), 0.515662, tolerance = 1e-6)			   
})

test_that("entropy_rate on ensamble of series", {
  series      <- matrix(0, nrow = 8, ncol = 2)
  series[, 1] <- c(1, 1, 0, 0, 1, 0, 0, 1)
  series[, 2] <- c(0, 0, 0, 1, 0, 0, 0, 1)
  expect_equal(entropy_rate(series, k = 2, local = !T), 0.459148, tolerance = 1e-6)

  series      <- matrix(0, nrow = 9, ncol = 9)
  series[, 1] <- c(1, 0, 0, 0, 0, 0, 0, 0, 0)
  series[, 2] <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
  series[, 3] <- c(1, 0, 0, 0, 0, 0, 0, 1, 1)
  series[, 4] <- c(1, 0, 0, 0, 0, 0, 0, 1, 1)
  series[, 5] <- c(0, 0, 0, 0, 0, 1, 1, 0, 0)
  series[, 6] <- c(0, 0, 0, 0, 1, 1, 0, 0, 0)
  series[, 7] <- c(1, 1, 1, 0, 0, 0, 0, 1, 1)
  series[, 8] <- c(0, 0, 0, 1, 1, 1, 1, 0, 0)
  series[, 9] <- c(0, 0, 0, 0, 0, 0, 1, 1, 0)  
  expect_equal(entropy_rate(series, k = 2, local = !T),
               0.610249, tolerance = 1e-6)

  series      <- matrix(0, nrow = 9, ncol = 4)
  series[, 1] <- c(3, 3, 3, 2, 1, 0, 0, 0, 1)
  series[, 2] <- c(2, 2, 3, 3, 3, 3, 2, 1, 0)
  series[, 3] <- c(0, 0, 0, 0, 1, 1, 0, 0, 0)
  series[, 4] <- c(1, 1, 0, 0, 0, 1, 1, 2, 2)
  expect_equal(entropy_rate(series, k = 2, local = !T), 0.544468, tolerance = 1e-6)
})

test_that("entropy_rate local on single series", {
  expect_equal(mean(entropy_rate(c(1, 0, 0, 0, 0, 0, 0, 0, 0),
                           k = 2, local = T)), 0.000000, tolerance = 1e-6)
  expect_equal(mean(entropy_rate(c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                           k = 2, local = T)), 0.679270, tolerance = 1e-6)
  expect_equal(mean(entropy_rate(c(1, 0, 0, 0, 0, 0, 0, 1, 1),
                           k = 2, local = T)), 0.515663, tolerance = 1e-6)
  expect_equal(mean(entropy_rate(c(3, 3, 3, 2, 1, 0, 0, 0, 1),
                           k = 2, local = T)), 0.571428, tolerance = 1e-6)
  expect_equal(mean(entropy_rate(c(2, 2, 3, 3, 3, 3, 2, 1, 0),
                           k = 2, local = T)), 0.393556, tolerance = 1e-6)
  expect_equal(mean(entropy_rate(c(2, 2, 2, 2, 2, 2, 1, 1, 1),
                           k = 2, local = T)), 0.515662, tolerance = 1e-6)   
})

test_that("entropy_rate local on ensamble of series", {
  series      <- matrix(0, nrow = 8, ncol = 2)
  series[, 1] <- c(1, 1, 0, 0, 1, 0, 0, 1)
  series[, 2] <- c(0, 0, 0, 1, 0, 0, 0, 1)
  expect_equal(mean(entropy_rate(series, k = 2, local = T)),
               0.459148, tolerance = 1e-6)

  series      <- matrix(0, nrow = 9, ncol = 9)
  series[, 1] <- c(1, 0, 0, 0, 0, 0, 0, 0, 0)
  series[, 2] <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
  series[, 3] <- c(1, 0, 0, 0, 0, 0, 0, 1, 1)
  series[, 4] <- c(1, 0, 0, 0, 0, 0, 0, 1, 1)
  series[, 5] <- c(0, 0, 0, 0, 0, 1, 1, 0, 0)
  series[, 6] <- c(0, 0, 0, 0, 1, 1, 0, 0, 0)
  series[, 7] <- c(1, 1, 1, 0, 0, 0, 0, 1, 1)
  series[, 8] <- c(0, 0, 0, 1, 1, 1, 1, 0, 0)
  series[, 9] <- c(0, 0, 0, 0, 0, 0, 1, 1, 0)  
  expect_equal(mean(entropy_rate(series, k = 2, local = T)),
               0.610249, tolerance = 1e-6)

  series      <- matrix(0, nrow = 9, ncol = 4)
  series[, 1] <- c(3, 3, 3, 2, 1, 0, 0, 0, 1)
  series[, 2] <- c(2, 2, 3, 3, 3, 3, 2, 1, 0)
  series[, 3] <- c(0, 0, 0, 0, 1, 1, 0, 0, 0)
  series[, 4] <- c(1, 1, 0, 0, 0, 1, 1, 2, 2)
  expect_equal(mean(entropy_rate(series, k = 2, local = T)),
               0.544468, tolerance = 1e-6)
})
