################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################
library(rinform)
context("Relative Entropy")

test_that("relative_entropy checks parameters", {
  xs <- sample(0:1, 10, T)
  ys <- sample(0:1, 10, T)
  
  expect_error(relative_entropy("series", ys, local = !T))
  expect_error(relative_entropy(NULL,     ys, local = !T))
  expect_error(relative_entropy(NA,       ys, local = !T))
  expect_error(relative_entropy(xs, "series", local = !T))
  expect_error(relative_entropy(xs, NULL,     local = !T))
  expect_error(relative_entropy(xs, NA,       local = !T))
  
  expect_error(relative_entropy(xs, ys, local = "TRUE"))
  expect_error(relative_entropy(xs, ys, local = NULL))
  expect_error(relative_entropy(xs, ys, local = NA))  
})

test_that("relative_entropy on single series", {
  expect_equal(relative_entropy(c(0, 0, 1, 1, 1, 1, 0, 0, 0), c(1, 0, 0, 1, 0, 0, 1, 0, 0),
                                local = !T), 0.038330, tolerance = 1e-6)
  expect_equal(relative_entropy(c(1, 0, 0, 1, 0, 0, 1, 0, 0), c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                                local = !T), 0.037010, tolerance = 1e-6)
  expect_equal(relative_entropy(c(0, 0, 0, 0, 1, 1, 1, 1), c(1, 1, 1, 1, 0, 0, 0, 0),
                                local = !T), 0.000000, tolerance = 1e-6)
  expect_equal(relative_entropy(c(1, 1, 0, 1, 0, 1, 1, 1, 0), c(1, 1, 0, 0, 0, 1, 0, 1, 1),
                                local = !T), 0.037010, tolerance = 1e-6)
  expect_equal(relative_entropy(c(1, 1, 0, 0, 1, 1, 0, 0, 1), c(1, 1, 1, 0, 0, 0, 1, 1, 1),
                                local = !T), 0.038331, tolerance = 1e-6)
  expect_equal(relative_entropy(c(0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1),
                                c(0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2),
                                local = !T), 0.584963, tolerance = 1e-6)
  expect_equal(relative_entropy(c(1, 0, 0, 1, 0, 0, 1, 0), c(2, 0, 1, 2, 0, 1, 2, 0),
                                local = !T), 0.679964, tolerance = 1e-6)
})

test_that("block_entropy local on single series", {
  expect_equal(relative_entropy(c(0, 0, 1, 1, 1, 1, 0, 0, 0), c(1, 0, 0, 1, 0, 0, 1, 0, 0),
                                local = T), c(-0.263034, 0.415037), tolerance = 1e-6)
  expect_equal(relative_entropy(c(1, 0, 0, 1, 0, 0, 1, 0, 0), c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                                local = T), c(0.263034, -0.415037), tolerance = 1e-6)
  expect_equal(relative_entropy(c(0, 0, 0, 0, 1, 1, 1, 1), c(1, 1, 1, 1, 0, 0, 0, 0),
                                local = T), c(0.000000, 0.000000), tolerance = 1e-6)
  expect_equal(relative_entropy(c(1, 1, 0, 1, 0, 1, 1, 1, 0), c(1, 1, 0, 0, 0, 1, 0, 1, 1),
                                local = T), c(-0.415037, 0.263034), tolerance = 1e-6)
  expect_equal(relative_entropy(c(1, 1, 0, 0, 1, 1, 0, 0, 1), c(1, 1, 1, 0, 0, 0, 1, 1, 1),
                                local = T), c(0.415037, -0.263034), tolerance = 1e-6)
  expect_equal(relative_entropy(c(0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1),
                                c(0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2),
                                local = T), c(0.584963, 0.584963, -Inf), tolerance = 1e-6)
  expect_equal(relative_entropy(c(1, 0, 0, 1, 0, 0, 1, 0), c(2, 0, 1, 2, 0, 1, 2, 0),
                                local = T), c(0.736966, 0.584963, -Inf), tolerance = 1e-6)
})
