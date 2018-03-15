################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################
library(rinform)
context("Active Information")

test_that("active_info checks parameters", {
  xs <- sample(0:1, 10, T)
  expect_error(active_info("series", k = 1, local = !T))
  expect_error(active_info(NULL,     k = 1, local = !T))
  expect_error(active_info(NA,       k = 1, local = !T))
  
  expect_error(active_info(xs, k = "k",  local = !T))
  expect_error(active_info(xs, k = NULL, local = !T))
  expect_error(active_info(xs, k = NA,   local = !T))  
  expect_error(active_info(xs, k = 0,    local = !T))
  expect_error(active_info(xs, k = -1,   local = !T))
  
  expect_error(active_info(xs, k = 1, local = "TRUE"))
  expect_error(active_info(xs, k = 1, local = NULL))
  expect_error(active_info(xs, k = 1, local = NA))  
})

test_that("active_info on single series", {
  expect_equal(active_info(c(1, 1, 0, 0, 1, 0, 0, 1),
                           k = 2, local = !T), 0.918296, tolerance = 1e-6)
  expect_equal(active_info(c(1, 0, 0, 0, 0, 0, 0, 0, 0),
                           k = 2, local = !T), 0.000000, tolerance = 1e-6)
  expect_equal(active_info(c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                           k = 2, local = !T), 0.305958, tolerance = 1e-6)
  expect_equal(active_info(c(1, 0, 0, 0, 0, 0, 0, 1, 1),
                           k = 2, local = !T), 0.347458, tolerance = 1e-6)
  expect_equal(active_info(c(3, 3, 3, 2, 1, 0, 0, 0, 1),
                           k = 2, local = !T), 1.270942, tolerance = 1e-6)
  expect_equal(active_info(c(2, 2, 3, 3, 3, 3, 2, 1, 0),
                           k = 2, local = !T), 1.270942, tolerance = 1e-6)
  expect_equal(active_info(c(2, 2, 2, 2, 2, 2, 1, 1, 1),
                           k = 2, local = !T), 0.469566, tolerance = 1e-6)			   
})

test_that("active_info on ensemble of series", {
  series      <- matrix(0, nrow = 8, ncol = 2)
  series[, 1] <- c(1, 1, 0, 0, 1, 0, 0, 1)
  series[, 2] <- c(0, 0, 0, 1, 0, 0, 0, 1)
  expect_equal(active_info(series, k = 2, local = !T), 0.459148, tolerance = 1e-6)

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
  expect_equal(active_info(series, k = 2, local = !T),
               0.3080467, tolerance = 1e-6)

  series      <- matrix(0, nrow = 9, ncol = 4)
  series[, 1] <- c(3, 3, 3, 2, 1, 0, 0, 0, 1)
  series[, 2] <- c(2, 2, 3, 3, 3, 3, 2, 1, 0)
  series[, 3] <- c(0, 0, 0, 0, 1, 1, 0, 0, 0)
  series[, 4] <- c(1, 1, 0, 0, 0, 1, 1, 2, 2)
  expect_equal(active_info(series, k = 2, local = !T), 1.324292, tolerance = 1e-6)
})

test_that("active_info local on single series", {
  expect_equal(mean(active_info(c(1, 0, 0, 0, 0, 0, 0, 0, 0),
                           k = 2, local = T)), 0.000000, tolerance = 1e-6)
  expect_equal(mean(active_info(c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                           k = 2, local = T)), 0.305958, tolerance = 1e-6)
  expect_equal(mean(active_info(c(1, 0, 0, 0, 0, 0, 0, 1, 1),
                           k = 2, local = T)), 0.347458, tolerance = 1e-6)
  expect_equal(mean(active_info(c(3, 3, 3, 2, 1, 0, 0, 0, 1),
                           k = 2, local = T)), 1.270942, tolerance = 1e-6)
  expect_equal(mean(active_info(c(2, 2, 3, 3, 3, 3, 2, 1, 0),
                           k = 2, local = T)), 1.270942, tolerance = 1e-6)
  expect_equal(mean(active_info(c(2, 2, 2, 2, 2, 2, 1, 1, 1),
                           k = 2, local = T)), 0.469566, tolerance = 1e-6)   
})

test_that("active_info local on ensemble of series", {
  series      <- matrix(0, nrow = 8, ncol = 2)
  series[, 1] <- c(1, 1, 0, 0, 1, 0, 0, 1)
  series[, 2] <- c(0, 0, 0, 1, 0, 0, 0, 1)
  expect_equal(mean(active_info(series, k = 2, local = T)),
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
  expect_equal(mean(active_info(series, k = 2, local = T)),
               0.3080467, tolerance = 1e-6)

  series      <- matrix(0, nrow = 9, ncol = 4)
  series[, 1] <- c(3, 3, 3, 2, 1, 0, 0, 0, 1)
  series[, 2] <- c(2, 2, 3, 3, 3, 3, 2, 1, 0)
  series[, 3] <- c(0, 0, 0, 0, 1, 1, 0, 0, 0)
  series[, 4] <- c(1, 1, 0, 0, 0, 1, 1, 2, 2)
  expect_equal(mean(active_info(series, k = 2, local = T)),
               1.324292, tolerance = 1e-6)
})
