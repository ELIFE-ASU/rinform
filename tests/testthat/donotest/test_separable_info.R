################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################
library(rinform)
context("Separable Information")

test_that("separable_info checks parameters", {
  srcs <- sample(0:1, 10, T)
  dest <- sample(0:1, 10, T)
  
  expect_error(separable_info("srcs", dest, k = 1, local = !T))
  expect_error(separable_info(NULL,   dest, k = 1, local = !T))
  expect_error(separable_info(NA,     dest, k = 1, local = !T))
  
  expect_error(separable_info(srcs, "dest", k = 1, local = !T))
  expect_error(separable_info(srcs, NULL,   k = 1, local = !T))
  expect_error(separable_info(srcs, NA,     k = 1, local = !T))

  srcs <- matrix(sample(0:1, 20, T), ncol = 2)
  dest <- matrix(sample(0:1, 30, T), ncol = 3)
  expect_error(separable_info(srcs, dest, k = 1,  local = !T))

  srcs <- sample(0:1, 20, T)
  dest <- matrix(sample(0:1, 30, T), ncol = 2)
  expect_error(separable_info(srcs, dest, k = 1,  local = !T))

  expect_error(separable_info(srcs, dest, k = "k",  local = !T))
  expect_error(separable_info(srcs, dest, k = NULL, local = !T))
  expect_error(separable_info(srcs, dest, k = NA,   local = !T))
  expect_error(separable_info(srcs, dest, k = 0,    local = !T))
  expect_error(separable_info(srcs, dest, k = -1,   local = !T))

  expect_error(separable_info(srcs, dest, k = 1, local = "TRUE"))
  expect_error(separable_info(srcs, dest, k = 1, local = NULL))
  expect_error(separable_info(srcs, dest, k = 1, local = NA))
})

test_that("separable_info on single series", {
  xs <- c(1, 1, 1, 0, 0)
  ys <- c(1, 1, 0, 0, 1)
  expect_equal(separable_info(xs, xs, k = 2, local = !T), 0.251629, tolerance = 1e-6)
  expect_equal(separable_info(ys, xs, k = 2, local = !T), 0.918296, tolerance = 1e-6)
  expect_equal(separable_info(xs, ys, k = 2, local = !T), 0.918296, tolerance = 1e-6)
  expect_equal(separable_info(ys, ys, k = 2, local = !T), 0.918296, tolerance = 1e-6)

  xs <- c(0, 0, 1, 1, 1, 0, 0, 0, 0, 1)
  ys <- c(1, 1, 0, 0, 0, 0, 0, 0, 1, 1)
  expect_equal(separable_info(xs, xs, k = 2, local = !T), 0.250000, tolerance = 1e-6)
  expect_equal(separable_info(ys, xs, k = 2, local = !T), 0.750000, tolerance = 1e-6)
  expect_equal(separable_info(xs, ys, k = 2, local = !T), 0.466917, tolerance = 1e-6)
  expect_equal(separable_info(ys, ys, k = 2, local = !T), 0.360073, tolerance = 1e-6)

  xs <- c(0, 1, 0, 1, 0, 0, 1, 1, 0, 0)
  ys <- c(0, 0, 1, 0, 1, 1, 1, 0, 1, 1)
  expect_equal(separable_info(xs, xs, k = 2, local = !T), 0.265712, tolerance = 1e-6)
  expect_equal(separable_info(ys, xs, k = 2, local = !T), 0.610073, tolerance = 1e-6)
  expect_equal(separable_info(xs, ys, k = 2, local = !T), 0.466917, tolerance = 1e-6)
  expect_equal(separable_info(ys, ys, k = 2, local = !T), 0.216917, tolerance = 1e-6)
})

test_that("separable_info on ensemble of series", {
  xs      <- matrix(0, nrow = 5, ncol = 3)
  xs[, 1] <- c(1, 1, 1, 0, 0)
  xs[, 2] <- c(1, 1, 0, 0, 1)
  xs[, 3] <- c(0, 0, 1, 1, 1)
  expect_equal(separable_info(xs[, 1:2], xs[, 3], k = 2, local = !T),
               0.000000, tolerance = 1e-6)
  expect_equal(separable_info(xs[, 2:3], xs[, 1], k = 2, local = !T),
               1.584962, tolerance = 1e-6)

  xs      <- matrix(0, nrow = 10, ncol = 3)
  xs[, 1] <- c(0, 0, 1, 1, 1, 0, 0, 0, 0, 1)
  xs[, 2] <- c(1, 1, 0, 0, 0, 0, 0, 0, 1, 1)
  xs[, 3] <- c(0, 0, 1, 0, 1, 1, 1, 0, 1, 1)
  expect_equal(separable_info(xs[, 1:2], xs[, 3], k = 2, local = !T),
               0.405639, tolerance = 1e-6)
  expect_equal(separable_info(xs[, 2:3], xs[, 1], k = 2, local = !T),
               1.000000, tolerance = 1e-6)

  xs      <- matrix(0, nrow = 10, ncol = 3)
  xs[, 1] <- c(0, 1, 0, 1, 0, 0, 1, 1, 0, 0)
  xs[, 2] <- c(0, 0, 1, 0, 1, 1, 1, 0, 1, 1)
  xs[, 3] <- c(1, 1, 0, 0, 0, 0, 0, 0, 1, 1)
  expect_equal(separable_info(xs[, 1:2], xs[, 3], k = 2, local = !T),
               0.668122, tolerance = 1e-6)
  expect_equal(separable_info(xs[, 2:3], xs[, 1], k = 2, local = !T),
               0.798795, tolerance = 1e-6)
})

test_that("separable_info local on single series", {
  xs <- c(1, 1, 1, 0, 0)
  ys <- c(1, 1, 0, 0, 1)
  expect_equal(mean(separable_info(xs, xs, k = 2, local = T)), 0.251629, tolerance = 1e-6)
  expect_equal(mean(separable_info(ys, xs, k = 2, local = T)), 0.918296, tolerance = 1e-6)
  expect_equal(mean(separable_info(xs, ys, k = 2, local = T)), 0.918296, tolerance = 1e-6)
  expect_equal(mean(separable_info(ys, ys, k = 2, local = T)), 0.918296, tolerance = 1e-6)

  xs <- c(0, 0, 1, 1, 1, 0, 0, 0, 0, 1)
  ys <- c(1, 1, 0, 0, 0, 0, 0, 0, 1, 1)
  expect_equal(mean(separable_info(xs, xs, k = 2, local = T)), 0.250000, tolerance = 1e-6)
  expect_equal(mean(separable_info(ys, xs, k = 2, local = T)), 0.750000, tolerance = 1e-6)
  expect_equal(mean(separable_info(xs, ys, k = 2, local = T)), 0.466917, tolerance = 1e-6)
  expect_equal(mean(separable_info(ys, ys, k = 2, local = T)), 0.360073, tolerance = 1e-6)

  xs <- c(0, 1, 0, 1, 0, 0, 1, 1, 0, 0)
  ys <- c(0, 0, 1, 0, 1, 1, 1, 0, 1, 1)
  expect_equal(mean(separable_info(xs, xs, k = 2, local = T)), 0.265712, tolerance = 1e-6)
  expect_equal(mean(separable_info(ys, xs, k = 2, local = T)), 0.610073, tolerance = 1e-6)
  expect_equal(mean(separable_info(xs, ys, k = 2, local = T)), 0.466917, tolerance = 1e-6)
  expect_equal(mean(separable_info(ys, ys, k = 2, local = T)), 0.216917, tolerance = 1e-6)
})

test_that("separable_info local on ensemble of series", {
  xs      <- matrix(0, nrow = 5, ncol = 3)
  xs[, 1] <- c(1, 1, 1, 0, 0)
  xs[, 2] <- c(1, 1, 0, 0, 1)
  xs[, 3] <- c(0, 0, 1, 1, 1)
  expect_equal(mean(separable_info(xs[, 1:2], xs[, 3], k = 2, local = T)),
               0.000000, tolerance = 1e-6)
  expect_equal(mean(separable_info(xs[, 2:3], xs[, 1], k = 2, local = T)),
               1.584962, tolerance = 1e-6)

  xs      <- matrix(0, nrow = 10, ncol = 3)
  xs[, 1] <- c(0, 0, 1, 1, 1, 0, 0, 0, 0, 1)
  xs[, 2] <- c(1, 1, 0, 0, 0, 0, 0, 0, 1, 1)
  xs[, 3] <- c(0, 0, 1, 0, 1, 1, 1, 0, 1, 1)
  expect_equal(mean(separable_info(xs[, 1:2], xs[, 3], k = 2, local = T)),
               0.405639, tolerance = 1e-6)
  expect_equal(mean(separable_info(xs[, 2:3], xs[, 1], k = 2, local = T)),
               1.000000, tolerance = 1e-6)

  xs      <- matrix(0, nrow = 10, ncol = 3)
  xs[, 1] <- c(0, 1, 0, 1, 0, 0, 1, 1, 0, 0)
  xs[, 2] <- c(0, 0, 1, 0, 1, 1, 1, 0, 1, 1)
  xs[, 3] <- c(1, 1, 0, 0, 0, 0, 0, 0, 1, 1)
  expect_equal(mean(separable_info(xs[, 1:2], xs[, 3], k = 2, local = T)),
               0.668122, tolerance = 1e-6)
  expect_equal(mean(separable_info(xs[, 2:3], xs[, 1], k = 2, local = T)),
               0.798795, tolerance = 1e-6)
})
