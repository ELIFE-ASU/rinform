################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################
library(rinform)
context("Conditional Entropy")

test_that("conditional_entropy checks parameters", {
  xs <- sample(0:1, 10, T)
  ys <- sample(0:1, 10, T)
  
  expect_error(conditional_entropy("series", ys, local = !T))
  expect_error(conditional_entropy(NULL,     ys, local = !T))
  expect_error(conditional_entropy(NA,       ys, local = !T))
  expect_error(conditional_entropy(xs, "series", local = !T))
  expect_error(conditional_entropy(xs, NULL,     local = !T))
  expect_error(conditional_entropy(xs, NA,       local = !T))
    
  expect_error(conditional_entropy(xs, ys, local = "TRUE"))
  expect_error(conditional_entropy(xs, ys, local = NULL))
  expect_error(conditional_entropy(xs, ys, local = NA))  
})

test_that("conditional_entropy on single series", {
  expect_equal(conditional_entropy(c(1, 0, 0, 1, 0, 0, 1, 0, 0), c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                           local = !T), 0.972765, tolerance = 1e-6)
  expect_equal(conditional_entropy(c(0, 0, 1, 1, 1, 1, 0, 0, 0), c(1, 1, 0, 0, 0, 0, 1, 1, 1),
                           local = !T), 0.000000, tolerance = 1e-6)
  expect_equal(conditional_entropy(c(0, 0, 0, 0, 0, 0, 0, 0, 0), c(1, 1, 1, 0, 0, 0, 1, 1, 1),
                           local = !T), 0.918296, tolerance = 1e-6)
  expect_equal(conditional_entropy(c(1, 1, 1, 1, 0, 0, 0, 0, 1), c(1, 1, 1, 0, 0, 0, 1, 1, 1),
                           local = !T), 0.845516, tolerance = 1e-6)
  expect_equal(conditional_entropy(c(1, 1, 0, 0, 1, 1, 0, 0, 1), c(1, 1, 1, 0, 0, 0, 1, 1, 1),
                           local = !T), 0.899985, tolerance = 1e-6)
  expect_equal(conditional_entropy(c(0, 0, 1, 1, 2, 1, 1, 0, 0), c(0, 0, 0, 1, 1, 1, 0, 0, 0),
                           local = !T), 0.444444, tolerance = 1e-6)
})

test_that("conditional_entropy local on single series", {
  expect_equal(mean(conditional_entropy(c(0, 0, 1, 1, 1, 1, 0, 0, 0), c(1, 0, 0, 1, 0, 0, 1, 0, 0),
                           local = T)), 0.899985, tolerance = 1e-6)
  expect_equal(mean(conditional_entropy(c(1, 0, 0, 1, 0, 0, 1, 0, 0), c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                           local = T)), 0.972765, tolerance = 1e-6)
  expect_equal(mean(conditional_entropy(c(0, 0, 0, 0, 1, 1, 1, 1), c(1, 1, 1, 1, 0, 0, 0, 0),
                           local = T)), 0.000000, tolerance = 1e-6)
  expect_equal(mean(conditional_entropy(c(0, 0, 0, 0, 0, 0, 0, 0, 0), c(1, 1, 1, 0, 0, 0, 1, 1, 1),
                           local = T)), 0.918296, tolerance = 1e-6)
  expect_equal(mean(conditional_entropy(c(0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1),
                           c(0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2),
                           local = T)), 0.918296, tolerance = 1e-6)
  expect_equal(mean(conditional_entropy(c(0, 0, 1, 1, 2, 1, 1, 0, 0), c(0, 0, 0, 1, 1, 1, 0, 0, 0),
                           local = T)), 0.444444, tolerance = 1e-6)
})