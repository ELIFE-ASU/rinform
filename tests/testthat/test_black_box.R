################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################
library(rinform)
context("Black Box")

test_that("black_box checks parameters", {
  expect_error(black_box("series", l = 1, r = NULL, s = NULL))
  expect_error(black_box(NULL,     l = 1, r = NULL, s = NULL))
  expect_error(black_box(NA,       l = 1, r = NULL, s = NULL))

  xs <- sample(0:1, 10, T)
  expect_error(black_box(xs, l = "l",  r = NULL, s = NULL))
  expect_error(black_box(xs, l = NULL, r = NULL, s = NULL))
  expect_error(black_box(xs, l = NA,   r = NULL, s = NULL))
  expect_error(black_box(xs, l = 0,    r = NULL, s = NULL))
  expect_error(black_box(xs, l = -1,   r = NULL, s = NULL))
  expect_error(black_box(xs, l = 3,    r = NULL, s = NULL))

  expect_error(black_box(xs,                   l = 1, r = "r",     s = NULL))
  expect_error(black_box(xs,                   l = 1, r = NA,     s = NULL))
  expect_error(black_box(xs,                   l = 1, r = -1,     s = NULL))
  expect_error(black_box(matrix(xs, ncol = 2), l = 2, r = c(3),   s = NULL))

  expect_error(black_box(xs,                   l = 1, r = NULL, s = "s"))
  expect_error(black_box(xs,                   l = 1, r = NULL, s = NA))
  expect_error(black_box(xs,                   l = 1, r = NULL, s = -1))
  expect_error(black_box(matrix(xs, ncol = 2), l = 2, r = NULL, s = c(3)))
})

test_that("black_box on single series", {
  series <- c(0, 1, 1, 0, 1, 1, 0, 0)
  expect <- series
  box    <- black_box(series, l = 1)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:8) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- series
  box    <- black_box(series, l = 1, r = 1)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:8) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(1, 3, 2, 1, 3, 2, 0)
  box    <- black_box(series, l = 1, r = 2)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:7) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(3, 6, 5, 3, 6, 4)
  box    <- black_box(series, l = 1, r = 3)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:6) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(1, 3, 2, 1, 3, 2, 0)
  box    <- black_box(series, l = 1, s = 1)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:7) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(1, 3, 2, 1, 3, 2, 0)
  box    <- black_box(series, l = 1, r = 1, s = 1)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:7) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(3, 6, 5, 3, 6, 4)
  box    <- black_box(series, l = 1, s = 2)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:6) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(3, 6, 5, 3, 6, 4)
  box    <- black_box(series, l = 1, r = 1, s = 2)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:6) expect_equal(box[i], expect[i], tolerance = 1e-6)

  series <- c(0, 1, 2, 0, 1, 1, 0, 2)
  expect <- c(5, 15, 19, 4, 12, 11)
  box    <- black_box(series, l = 1, r = 1, s = 2)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:6) expect_equal(box[i], expect[i], tolerance = 1e-6)
})

test_that("black_box on ensemble of series", {
  series <- matrix(c(0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1), ncol = 2)
  expect <- c(series)
  box    <- black_box(series, l = 1)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:16) expect_equal(box[i], expect[i], tolerance = 1e-6)

  box    <- black_box(series, l = 1, r = 1)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:16) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(1, 3, 2, 1, 3, 2, 0, 0, 1, 3, 2, 1, 2, 1)
  box    <- black_box(series, l = 1, r = 2)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:14) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(3, 6, 5, 3, 6, 4, 1, 3, 6, 5, 2, 5)
  box    <- black_box(series, l = 1, r = 3)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:12) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(1, 3, 2, 1, 3, 2, 0, 0, 1, 3, 2, 1, 2, 1)
  box    <- black_box(series, l = 1, s = 1)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:14) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(1, 3, 2, 1, 3, 2, 0, 0, 1, 3, 2, 1, 2, 1)
  box    <- black_box(series, l = 1, r = 1, s = 1)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:14) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(3, 6, 5, 3, 6, 4, 1, 3, 6, 5, 2, 5)
  box    <- black_box(series, l = 1, s = 2)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:6) expect_equal(box[i], expect[i], tolerance = 1e-6)

  series <- matrix(c(0, 1, 2, 0, 1, 1, 0, 2, 2, 1, 1, 2, 0, 0, 1, 2), ncol = 2)
  expect <- c(5, 15, 19, 4, 12, 11, 22, 14, 15, 18, 1, 5)
  box    <- black_box(series, l = 1, r = 1, s = 2)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:12) expect_equal(box[i], expect[i], tolerance = 1e-6)
})

test_that("black_box on multiple series", {
  series <- matrix(c(0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1), ncol = 2)
  expect <- c(0, 2, 3, 1, 2, 3, 0, 1)
  box    <- black_box(series, l = 2)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:8) expect_equal(box[i], expect[i], tolerance = 1e-6)

  box    <- black_box(series, l = 2, r = c(1, 1))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:8) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(2, 7, 5, 2, 7, 4, 1)
  box    <- black_box(series, l = 2, r = c(2, 1))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:7) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(4, 5, 3, 6, 5, 2, 1)
  box    <- black_box(series, l = 2, r = c(1, 2))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:7) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(4, 13, 11, 6, 13, 10, 1)
  box    <- black_box(series, l = 2, r = c(2, 2))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:7) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(2, 6, 5, 3, 6, 5, 0)
  box    <- black_box(series, l = 2, s = c(1, 0))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:7) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(4, 13, 11, 6, 13, 10, 1)
  box    <- black_box(series, l = 2, s = c(1, 1))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:7) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(0, 5, 7, 2, 5, 6, 1)
  box    <- black_box(series, l = 2, s = c(0, 1))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:7) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(6, 13, 11, 6, 13, 8)
  box    <- black_box(series, l = 2, r = c(2, 1), s = c(1, 0))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:6) expect_equal(box[i], expect[i], tolerance = 1e-6)

  series <- matrix(c(0, 1, 2, 0, 1, 1, 0, 2, 0, 0, 1, 1, 0, 1, 0, 1), ncol = 2)
  expect <- c(10, 31, 39, 8, 25, 22)
  box    <- black_box(series, l = 2, r = c(2, 1), s = c(1, 0))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:6) expect_equal(box[i], expect[i], tolerance = 1e-6)

  series <- matrix(c(0, 1, 1, 0, 1, 1, 0, 0, 0, 2, 1, 1, 0, 2, 0, 1), ncol = 2)
  expect <- c(11, 19, 16, 9, 20, 12)
  box    <- black_box(series, l = 2, r = c(2, 1), s = c(1, 0))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:6) expect_equal(box[i], expect[i], tolerance = 1e-6)

  series <- matrix(c(0, 3, 1, 0, 1, 1, 2, 0, 0, 1, 1, 1, 0, 1, 0, 1), ncol = 2)
  expect <- c(27, 105, 35, 10, 45, 48)
  box    <- black_box(series, l = 2, r = c(2, 1), s = c(1, 0))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:6) expect_equal(box[i], expect[i], tolerance = 1e-6)

  series <- matrix(c(0, 1, 1, 1, 0, 1, 0, 1, 0, 3, 1, 0, 1, 1, 2, 0), ncol = 2)
  expect <- c(15, 29, 24, 21, 9, 22)
  box    <- black_box(series, l = 2, r = c(2, 1), s = c(1, 0))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:6) expect_equal(box[i], expect[i], tolerance = 1e-6)
})

test_that("black_box on ensemble of multiple series", {
  series      <- matrix(0, nrow = 8, ncol = 4)
  series[, 1] <- c(0, 1, 1, 0, 1, 1, 0, 0)
  series[, 2] <- c(0, 0, 1, 1, 0, 1, 0, 1)
  series[, 3] <- c(1, 1, 0, 1, 0, 0, 1, 0)
  series[, 4] <- c(0, 0, 0, 1, 0, 0, 1, 0)
  expect <- c(1, 3, 2, 1, 2, 2, 1, 0, 0, 0, 2, 3, 0, 2, 1, 2)
  box    <- black_box(series, l = 2)
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:length(expect)) expect_equal(box[i], expect[i], tolerance = 1e-6)

  box    <- black_box(series, l = 2, r = c(1, 1))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:length(expect)) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(3, 6, 5, 2, 6, 5, 0, 0, 2, 7, 4, 2, 5, 2)
  box    <- black_box(series, l = 2, r = c(2, 1))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:length(expect)) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(7, 6, 1, 6, 4, 1, 2, 0, 4, 5, 2, 4, 1, 6)
  box    <- black_box(series, l = 2, r = c(1, 2))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:length(expect)) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(7, 14, 9, 6, 12, 9, 2, 0, 4, 13, 10, 4, 9, 6)
  box    <- black_box(series, l = 2, r = c(2, 2))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:length(expect)) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(3, 7, 4, 3, 6, 4, 1, 0, 2, 6, 5, 2, 4, 3)
  box    <- black_box(series, l = 2, s = c(1, 0))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:length(expect)) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(7, 14, 9, 6, 12, 9, 2, 0, 4, 13, 10, 4, 9, 6)
  box    <- black_box(series, l = 2, s = c(1, 1))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:length(expect)) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(3, 6, 5, 2, 4, 5, 2, 0, 0, 5, 6, 0, 5, 2)
  box    <- black_box(series, l = 2, s = c(0, 1))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:length(expect)) expect_equal(box[i], expect[i], tolerance = 1e-6)

  expect <- c(7, 12, 11, 6, 12, 9, 2, 6, 13, 10, 4, 11)
  box    <- black_box(series, l = 2, r = c(2, 1), s = c(1, 0))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:length(expect)) expect_equal(box[i], expect[i], tolerance = 1e-6)

  series[, 1] <- c(0, 1, 2, 0, 1, 1, 0, 2)
  series[, 2] <- c(0, 0, 1, 1, 0, 1, 0, 1)
  series[, 3] <- c(1, 0, 1, 1, 0, 1, 0, 0)
  series[, 4] <- c(1, 1, 0, 1, 0, 0, 1, 0)
  expect <- c(10, 31, 39, 8, 25, 22, 3, 8, 25, 20, 6, 21)
  box    <- black_box(series, l = 2, r = c(2, 1), s = c(1, 0))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:length(expect)) expect_equal(box[i], expect[i], tolerance = 1e-6)

  series[, 1] <- c(0, 3, 1, 0, 1, 1, 2, 0)
  series[, 2] <- c(0, 1, 2, 1, 0, 1, 3, 1)
  series[, 3] <- c(0, 1, 1, 0, 1, 0, 1, 1)
  series[, 4] <- c(0, 0, 1, 1, 0, 1, 0, 0)
  expect <- c(27, 105, 34, 11, 44, 49, 12, 51, 73, 34, 15, 58)
  box    <- black_box(series, l = 2, r = c(2, 1), s = c(1, 0))
  expect_equal(length(box), length(expect), tolerance = 1e-6)
  for (i in 1:length(expect)) expect_equal(box[i], expect[i], tolerance = 1e-6)
})