################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################
library(rinform)
context("Predictive Information")

test_that("predictive_info checks parameters", {
  xs <- sample(0:1, 10, T)
  expect_error(predictive_info("series", kpast = 1, kfuture = 1, local = !T))
  expect_error(predictive_info(NULL,     kpast = 1, kfuture = 1, local = !T))
  expect_error(predictive_info(NA,       kpast = 1, kfuture = 1, local = !T))
  
  expect_error(predictive_info(xs, kpast = "k",  kfuture = 1, local = !T))
  expect_error(predictive_info(xs, kpast = NULL, kfuture = 1, local = !T))
  expect_error(predictive_info(xs, kpast = NA,   kfuture = 1, local = !T))  
  expect_error(predictive_info(xs, kpast = 0,    kfuture = 1, local = !T))
  expect_error(predictive_info(xs, kpast = -1,   kfuture = 1, local = !T))

  expect_error(predictive_info(xs, kpast = 1, kfuture = "k",  local = !T))
  expect_error(predictive_info(xs, kpast = 1, kfuture = NULL, local = !T))
  expect_error(predictive_info(xs, kpast = 1, kfuture = NA,   local = !T))  
  expect_error(predictive_info(xs, kpast = 1, kfuture = 0,    local = !T))
  expect_error(predictive_info(xs, kpast = 1, kfuture = -1,   local = !T))

  expect_error(predictive_info(xs, kpast = 1, kfuture = 1, local = "TRUE"))
  expect_error(predictive_info(xs, kpast = 1, kfuture = 1, local = NULL))
  expect_error(predictive_info(xs, kpast = 1, kfuture = 1, local = NA))  
})

test_that("predictive_info on single series", {  
  expect_equal(predictive_info(c(1, 1, 0, 0, 1, 0, 0, 1),
                               kpast = 2, kfuture = 1, local = !T),
	       0.918296, tolerance = 1e-6)
  expect_equal(predictive_info(c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                               kpast = 2, kfuture = 1, local = !T),
	       0.305958, tolerance = 1e-6)

  expect_equal(predictive_info(c(1, 1, 0, 0, 1, 0, 0, 1),
                               kpast = 2, kfuture = 2, local = !T),
	       1.521928, tolerance = 1e-6)
  expect_equal(predictive_info(c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                               kpast = 2, kfuture = 2, local = !T),
	       0.666667, tolerance = 1e-6)

  expect_equal(predictive_info(c(1, 1, 0, 0, 1, 0, 0, 1),
                               kpast = 2, kfuture = 3, local = !T),
	       1.500000, tolerance = 1e-6)
  expect_equal(predictive_info(c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                               kpast = 2, kfuture = 3, local = !T),
	       0.970951, tolerance = 1e-6)

  expect_equal(predictive_info(c(1, 1, 0, 0, 1, 0, 0, 1),
                               kpast = 1, kfuture = 2, local = !T),
	       0.666667, tolerance = 1e-6)
  expect_equal(predictive_info(c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                               kpast = 1, kfuture = 2, local = !T),
	       0.305958, tolerance = 1e-6)

  expect_equal(predictive_info(c(1, 1, 0, 0, 1, 0, 0, 1),
                               kpast = 3, kfuture = 3, local = !T),
	       1.584963, tolerance = 1e-6)
  expect_equal(predictive_info(c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                               kpast = 3, kfuture = 3, local = !T),
	       1.500000, tolerance = 1e-6)

  expect_equal(predictive_info(c(3, 3, 3, 2, 1, 0, 0, 0, 1),
                               kpast = 2, kfuture = 1, local = !T),
	       1.270942, tolerance = 1e-6)
  expect_equal(predictive_info(c(2, 2, 2, 2, 2, 2, 1, 1, 1),
                               kpast = 2, kfuture = 1, local = !T),
	       0.469566, tolerance = 1e-6)

  expect_equal(predictive_info(c(3, 3, 3, 2, 1, 0, 0, 0, 1),
                               kpast = 2, kfuture = 2, local = !T),
	       1.918296, tolerance = 1e-6)
  expect_equal(predictive_info(c(2, 2, 2, 2, 2, 2, 1, 1, 1),
                               kpast = 2, kfuture = 2, local = !T),
	       0.316689, tolerance = 1e-6)

})

test_that("predictive_info on ensemble of series", {
  series      <- matrix(0, nrow = 8, ncol = 2)
  series[, 1] <- c(1, 1, 0, 0, 1, 0, 0, 1)
  series[, 2] <- c(0, 0, 0, 1, 0, 0, 0, 1)
  expect_equal(predictive_info(series, kpast = 2, kfuture = 1, local = !T),
               0.459148, tolerance = 1e-6)
  expect_equal(predictive_info(series, kpast = 2, kfuture = 3, local = !T),
               1.061278, tolerance = 1e-6)

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
  expect_equal(predictive_info(series, kpast = 2, kfuture = 1, local = !T),
               0.3080467, tolerance = 1e-6)
  expect_equal(predictive_info(series, kpast = 2, kfuture = 3, local = !T),
               0.628720, tolerance = 1e-6)

  series      <- matrix(0, nrow = 9, ncol = 4)
  series[, 1] <- c(3, 3, 3, 2, 1, 0, 0, 0, 1)
  series[, 2] <- c(2, 2, 3, 3, 3, 3, 2, 1, 0)
  series[, 3] <- c(0, 0, 0, 0, 1, 1, 0, 0, 0)
  series[, 4] <- c(1, 1, 0, 0, 0, 1, 1, 2, 2)
  expect_equal(predictive_info(series, kpast = 2, kfuture = 1, local = !T),
               1.324292, tolerance = 1e-6)
  expect_equal(predictive_info(series, kpast = 2, kfuture = 3, local = !T),
               2.385475, tolerance = 1e-6)

})

test_that("predictive_info local on single series", {  
  expect_equal(mean(predictive_info(c(1, 1, 0, 0, 1, 0, 0, 1),
                               kpast = 2, kfuture = 1, local = T)),
	       0.918296, tolerance = 1e-6)
  expect_equal(mean(predictive_info(c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                               kpast = 2, kfuture = 1, local = T)),
	       0.305958, tolerance = 1e-6)

  expect_equal(mean(predictive_info(c(1, 1, 0, 0, 1, 0, 0, 1),
                               kpast = 2, kfuture = 2, local = T)),
	       1.521928, tolerance = 1e-6)
  expect_equal(mean(predictive_info(c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                               kpast = 2, kfuture = 2, local = T)),
	       0.666667, tolerance = 1e-6)

  expect_equal(mean(predictive_info(c(1, 1, 0, 0, 1, 0, 0, 1),
                               kpast = 2, kfuture = 3, local = T)),
	       1.500000, tolerance = 1e-6)
  expect_equal(mean(predictive_info(c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                               kpast = 2, kfuture = 3, local = T)),
	       0.970951, tolerance = 1e-6)

  expect_equal(mean(predictive_info(c(1, 1, 0, 0, 1, 0, 0, 1),
                               kpast = 1, kfuture = 2, local = T)),
	       0.666667, tolerance = 1e-6)
  expect_equal(mean(predictive_info(c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                               kpast = 1, kfuture = 2, local = T)),
	       0.305958, tolerance = 1e-6)

  expect_equal(mean(predictive_info(c(1, 1, 0, 0, 1, 0, 0, 1),
                               kpast = 3, kfuture = 3, local = T)),
	       1.584963, tolerance = 1e-6)
  expect_equal(mean(predictive_info(c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                               kpast = 3, kfuture = 3, local = T)),
	       1.500000, tolerance = 1e-6)

  expect_equal(mean(predictive_info(c(3, 3, 3, 2, 1, 0, 0, 0, 1),
                               kpast = 2, kfuture = 1, local = T)),
	       1.270942, tolerance = 1e-6)
  expect_equal(mean(predictive_info(c(2, 2, 2, 2, 2, 2, 1, 1, 1),
                               kpast = 2, kfuture = 1, local = T)),
	       0.469566, tolerance = 1e-6)

  expect_equal(mean(predictive_info(c(3, 3, 3, 2, 1, 0, 0, 0, 1),
                               kpast = 2, kfuture = 2, local = T)),
	       1.918296, tolerance = 1e-6)
  expect_equal(mean(predictive_info(c(2, 2, 2, 2, 2, 2, 1, 1, 1),
                               kpast = 2, kfuture = 2, local = T)),
	       0.316689, tolerance = 1e-6)
})

test_that("predictive_info local on ensemble of series", {
  series      <- matrix(0, nrow = 8, ncol = 2)
  series[, 1] <- c(1, 1, 0, 0, 1, 0, 0, 1)
  series[, 2] <- c(0, 0, 0, 1, 0, 0, 0, 1)
  expect_equal(mean(predictive_info(series, kpast = 2, kfuture = 1, local = T)),
               0.459148, tolerance = 1e-6)
  expect_equal(mean(predictive_info(series, kpast = 2, kfuture = 3, local = T)),
               1.061278, tolerance = 1e-6)

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
  expect_equal(mean(predictive_info(series, kpast = 2, kfuture = 1, local = T)),
               0.3080467, tolerance = 1e-6)
  expect_equal(mean(predictive_info(series, kpast = 2, kfuture = 3, local = T)),
               0.628720, tolerance = 1e-6)

  series      <- matrix(0, nrow = 9, ncol = 4)
  series[, 1] <- c(3, 3, 3, 2, 1, 0, 0, 0, 1)
  series[, 2] <- c(2, 2, 3, 3, 3, 3, 2, 1, 0)
  series[, 3] <- c(0, 0, 0, 0, 1, 1, 0, 0, 0)
  series[, 4] <- c(1, 1, 0, 0, 0, 1, 1, 2, 2)
  expect_equal(mean(predictive_info(series, kpast = 2, kfuture = 1, local = T)),
               1.324292, tolerance = 1e-6)
  expect_equal(mean(predictive_info(series, kpast = 2, kfuture = 3, local = T)),
               2.385475, tolerance = 1e-6)
})
