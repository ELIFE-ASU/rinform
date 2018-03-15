################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################
library(rinform)
context("Mutual Information")

test_that("mutual_info checks parameters", {
  xs      <- matrix(0, nrow = 10, ncol = 2)
  xs[, 1] <- sample(0:1, 10, T)
  xs[, 2] <- sample(0:1, 10, T)
  
  expect_error(mutual_info("series", local = !T))
  expect_error(mutual_info(NULL,     local = !T))
  expect_error(mutual_info(NA,       local = !T))
  expect_error(mutual_info(1,        local = !T))
  expect_error(mutual_info(1:10,     local = !T))

  expect_error(mutual_info(xs, local = "TRUE"))
  expect_error(mutual_info(xs, local = NULL))
  expect_error(mutual_info(xs, local = NA))  
})

test_that("mutual_info on multiple series", {
  series <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0), ncol = 2)
  expect_equal(mutual_info(series, local = !T), 1.000000, tolerance = 1e-6)
  series <- matrix(c(0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1), ncol = 2)
  expect_equal(mutual_info(series, local = !T), 0.991076, tolerance = 1e-6)  
  series <- matrix(c(1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1), ncol = 2)
  expect_equal(mutual_info(series, local = !T), 0.072780, tolerance = 1e-6)
  series <- matrix(c(0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1), ncol = 2)
  expect_equal(mutual_info(series, local = !T), 0.000000, tolerance = 1e-6)
  series <- matrix(c(0, 1, 0, 1, 0, 1, 0, 1, 0, 2, 0, 2, 0, 2, 0, 2), ncol = 2)
  expect_equal(mutual_info(series, local = !T), 1.000000, tolerance = 1e-6)
  series <- matrix(c(0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
                     0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2), ncol = 2)
  expect_equal(mutual_info(series, local = !T), 0.666667, tolerance = 1e-6)
  series <- matrix(c(0, 0, 1, 1, 2, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0), ncol = 2)
  expect_equal(mutual_info(series, local = !T), 0.473851, tolerance = 1e-6)
  series <- matrix(c(1, 0, 0, 1, 0, 0, 1, 0, 2, 0, 1, 2, 0, 1, 2, 0), ncol = 2)
  expect_equal(mutual_info(series, local = !T), 0.954434, tolerance = 1e-6)  
  series <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
                     1, 1, 1, 1, 0, 0, 0, 0,
                     0, 0, 1, 1, 1, 1, 0, 0), ncol = 3)
  expect_equal(mutual_info(series, local = !T), 1.000000, tolerance = 1e-6)
  series <- matrix(c(0, 0, 1, 1, 1, 1, 0, 0, 0,
                     1, 1, 0, 0, 0, 0, 1, 1, 1,
                     0, 0, 1, 1, 0, 0, 1, 1, 0), ncol = 3)
  expect_equal(mutual_info(series, local = !T), 0.998291, tolerance = 1e-6)
  series <- matrix(c(1, 1, 1, 1, 0, 0, 0, 0, 1,
                     1, 1, 1, 0, 0, 0, 1, 1, 1,
                     0, 0, 1, 1, 0, 0, 1, 1, 0), ncol = 3)
  expect_equal(mutual_info(series, local = !T), 0.703288, tolerance = 1e-6)
  series <- matrix(c(2, 0, 1, 1, 0, 2, 1, 0,
                     2, 0, 1, 2, 0, 1, 2, 0,
                     2, 0, 1, 0, 1, 0, 2, 0), ncol = 3)
  expect_equal(mutual_info(series, local = !T), 1.872556, tolerance = 1e-6)
  
})

test_that("mutual_info local on multiple series", {
  series <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0), ncol = 2)
  expect_equal(mean(mutual_info(series, local = T)), 1.000000, tolerance = 1e-6)
  series <- matrix(c(0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1), ncol = 2)
  expect_equal(mean(mutual_info(series, local = T)), 0.991076, tolerance = 1e-6)  
  series <- matrix(c(1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1), ncol = 2)
  expect_equal(mean(mutual_info(series, local = T)), 0.072780, tolerance = 1e-6)
  series <- matrix(c(0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1), ncol = 2)
  expect_equal(mean(mutual_info(series, local = T)), 0.000000, tolerance = 1e-6)
  series <- matrix(c(0, 1, 0, 1, 0, 1, 0, 1, 0, 2, 0, 2, 0, 2, 0, 2), ncol = 2)
  expect_equal(mean(mutual_info(series, local = T)), 1.000000, tolerance = 1e-6)
  series <- matrix(c(0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
                     0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2), ncol = 2)
  expect_equal(mean(mutual_info(series, local = T)), 0.666667, tolerance = 1e-6)
  series <- matrix(c(0, 0, 1, 1, 2, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0), ncol = 2)
  expect_equal(mean(mutual_info(series, local = T)), 0.473851, tolerance = 1e-6)
  series <- matrix(c(1, 0, 0, 1, 0, 0, 1, 0, 2, 0, 1, 2, 0, 1, 2, 0), ncol = 2)
  expect_equal(mean(mutual_info(series, local = T)), 0.954434, tolerance = 1e-6)  
  series <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
                     1, 1, 1, 1, 0, 0, 0, 0,
                     0, 0, 1, 1, 1, 1, 0, 0), ncol = 3)
  expect_equal(mean(mutual_info(series, local = T)), 1.000000, tolerance = 1e-6)
  series <- matrix(c(0, 0, 1, 1, 1, 1, 0, 0, 0,
                     1, 1, 0, 0, 0, 0, 1, 1, 1,
                     0, 0, 1, 1, 0, 0, 1, 1, 0), ncol = 3)
  expect_equal(mean(mutual_info(series, local = T)), 0.998291, tolerance = 1e-6)
  series <- matrix(c(1, 1, 1, 1, 0, 0, 0, 0, 1,
                     1, 1, 1, 0, 0, 0, 1, 1, 1,
                     0, 0, 1, 1, 0, 0, 1, 1, 0), ncol = 3)
  expect_equal(mean(mutual_info(series, local = T)), 0.703288, tolerance = 1e-6)
  series <- matrix(c(2, 0, 1, 1, 0, 2, 1, 0,
                     2, 0, 1, 2, 0, 1, 2, 0,
                     2, 0, 1, 0, 1, 0, 2, 0), ncol = 3)
  expect_equal(mean(mutual_info(series, local = T)), 1.872556, tolerance = 1e-6)
  
})
