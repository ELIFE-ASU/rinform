################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################
library(rinform)
context("Shannon Information Measures")

test_that("shannon_entropy checks parameters and functionality", {
  expect_error(shannon_entropy(Dist("1"),             b = 2))
  expect_error(shannon_entropy(Dist(NULL),            b = 2))
  expect_error(shannon_entropy(Dist(NA),              b = 2))
  expect_error(shannon_entropy(Dist(matrix(1, 2, 2)), b = 2))
  expect_error(shannon_entropy(Dist(0),               b = 2))
  expect_error(shannon_entropy(Dist(-1),              b = 2))

  expect_error(shannon_entropy(Dist(c(1, 1, 2, 1, 2)), b = "B"))
  expect_error(shannon_entropy(Dist(c(1, 1, 2, 1, 2)), b = NULL))
  expect_error(shannon_entropy(Dist(c(1, 1, 2, 1, 2)), b = NA))
  expect_error(shannon_entropy(Dist(c(1, 1, 2, 1, 2)), b = -1))

  expect_equal(shannon_entropy(Dist(c(0, 1, 0, 0, 0)), b = 0.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_entropy(Dist(c(0, 1, 0, 0, 0)), b = 0.5), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_entropy(Dist(c(0, 1, 0, 0, 0)), b = 1.5), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_entropy(Dist(c(0, 1, 0, 0, 0)), b = 2.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_entropy(Dist(c(0, 1, 0, 0, 0)), b = 3.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_entropy(Dist(c(0, 1, 0, 0, 0)), b = 4.0), 0.000000, tolerance = 1e-6)

  expect_equal(shannon_entropy(Dist(c(1, 1, 1, 1, 1)), b = 0.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_entropy(Dist(c(1, 1, 1, 1, 1)), b = .5), -2.321928, tolerance = 1e-6)
  expect_equal(shannon_entropy(Dist(c(1, 1, 1, 1, 1)), b = 1.5), 3.969362, tolerance = 1e-6)
  expect_equal(shannon_entropy(Dist(c(1, 1, 1, 1, 1)), b = 2.0), 2.321928, tolerance = 1e-6)
  expect_equal(shannon_entropy(Dist(c(1, 1, 1, 1, 1)), b = 3.0), 1.464973, tolerance = 1e-6)
  expect_equal(shannon_entropy(Dist(c(1, 1, 1, 1, 1)), b = 4.0), 1.160964, tolerance = 1e-6)

  expect_equal(shannon_entropy(Dist(c(2, 2, 1)), b = 0.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_entropy(Dist(c(2, 2, 1)), b = 0.5), -1.521928, tolerance = 1e-6)
  expect_equal(shannon_entropy(Dist(c(2, 2, 1)), b = 1.5), 2.601753, tolerance = 1e-6)
  expect_equal(shannon_entropy(Dist(c(2, 2, 1)), b = 2.0), 1.521928, tolerance = 1e-6)
  expect_equal(shannon_entropy(Dist(c(2, 2, 1)), b = 3.0), 0.960230, tolerance = 1e-6)
  expect_equal(shannon_entropy(Dist(c(2, 2, 1)), b = 4.0), 0.760964, tolerance = 1e-6)
})

test_that("shannon_mutual_info checks parameters and functionality", {
  x <- Dist(c(5, 1)); y <- Dist(c(2, 3)); xy <- Dist(c(5, 3));
  expect_error(shannon_mutual_info(Dist("1"),             x, y, b = 2))
  expect_error(shannon_mutual_info(Dist(NULL),            x, y, b = 2))
  expect_error(shannon_mutual_info(Dist(NA),              x, y, b = 2))
  expect_error(shannon_mutual_info(Dist(matrix(1, 2, 2)), x, y, b = 2))
  expect_error(shannon_mutual_info(Dist(0),               x, y, b = 2))
  expect_error(shannon_mutual_info(Dist(-1),              x, y, b = 2))

  expect_error(shannon_mutual_info(xy, Dist("1"),             y, b = 2))
  expect_error(shannon_mutual_info(xy, Dist(NULL),            y, b = 2))
  expect_error(shannon_mutual_info(xy, Dist(NA),              y, b = 2))
  expect_error(shannon_mutual_info(xy, Dist(matrix(1, 2, 2)), y, b = 2))
  expect_error(shannon_mutual_info(xy, Dist(0),               y, b = 2))
  expect_error(shannon_mutual_info(xy, Dist(-1),              y, b = 2))

  expect_error(shannon_mutual_info(xy, x, Dist("1"),             b = 2))
  expect_error(shannon_mutual_info(xy, x, Dist(NULL),            b = 2))
  expect_error(shannon_mutual_info(xy, x, Dist(NA),              b = 2))
  expect_error(shannon_mutual_info(xy, x, Dist(matrix(1, 2, 2)), b = 2))
  expect_error(shannon_mutual_info(xy, x, Dist(0),               b = 2))
  expect_error(shannon_mutual_info(xy, x, Dist(-1),              b = 2))

  expect_error(shannon_mutual_info(xy, x, y, b = "b"))
  expect_error(shannon_mutual_info(xy, x, y, b = NULL))
  expect_error(shannon_mutual_info(xy, x, y, b = NA))
  expect_error(shannon_mutual_info(xy, x, y, b = -1))

  x  <- Dist(c(5, 2, 3, 5, 1, 4, 6, 2, 1, 4, 2, 4))
  y  <- Dist(c(2, 4, 5, 2, 7, 3, 9, 8, 8, 7, 2, 3))
  xy <- Dist(12 * 12)
  for (i in 1:12) {
    for (j in 1:12) xy <- set_item(xy, j + (i - 1) * 12, get_item(x, i) * get_item(y, j))
  }
  expect_equal(shannon_mutual_info(xy, x, y, b = 0.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_mutual_info(xy, x, y, b = 0.5), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_mutual_info(xy, x, y, b = 1.5), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_mutual_info(xy, x, y, b = 2.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_mutual_info(xy, x, y, b = 3.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_mutual_info(xy, x, y, b = 4.0), 0.000000, tolerance = 1e-6)

  x  <- Dist(c(80, 20))
  y  <- Dist(c(25, 75))
  xy <- Dist(c(10, 70, 15, 5))
  expect_equal(shannon_mutual_info(xy, x, y, b = 0.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_mutual_info(xy, x, y, b = 0.5), -0.214171, tolerance = 1e-6)
  expect_equal(shannon_mutual_info(xy, x, y, b = 1.5), 0.366128, tolerance = 1e-6)
  expect_equal(shannon_mutual_info(xy, x, y, b = 2.0), 0.214171, tolerance = 1e-6)
  expect_equal(shannon_mutual_info(xy, x, y, b = 3.0), 0.135127, tolerance = 1e-6)
  expect_equal(shannon_mutual_info(xy, x, y, b = 4.0), 0.107086, tolerance = 1e-6)
})

test_that("shannon_conditional_entropy checks parameters and functionality", {
  y <- Dist(c(2, 3)); xy <- Dist(c(5, 3));
  expect_error(shannon_conditional_entropy(Dist("1"),             y, b = 2))
  expect_error(shannon_conditional_entropy(Dist(NULL),            y, b = 2))
  expect_error(shannon_conditional_entropy(Dist(NA),              y, b = 2))
  expect_error(shannon_conditional_entropy(Dist(matrix(1, 2, 2)), y, b = 2))
  expect_error(shannon_conditional_entropy(Dist(0),               y, b = 2))
  expect_error(shannon_conditional_entropy(Dist(-1),              y, b = 2))

  expect_error(shannon_conditional_entropy(xy, Dist("1"),             b = 2))
  expect_error(shannon_conditional_entropy(xy, Dist(NULL),            b = 2))
  expect_error(shannon_conditional_entropy(xy, Dist(NA),              b = 2))
  expect_error(shannon_conditional_entropy(xy, Dist(matrix(1, 2, 2)), b = 2))
  expect_error(shannon_conditional_entropy(xy, Dist(0),               b = 2))
  expect_error(shannon_conditional_entropy(xy, Dist(-1),              b = 2))

  expect_error(shannon_conditional_entropy(xy, y, b = "b"))
  expect_error(shannon_conditional_entropy(xy, y, b = NULL))
  expect_error(shannon_conditional_entropy(xy, y, b = NA))
  expect_error(shannon_conditional_entropy(xy, y, b = -1))

  skip("shannon_conditional_entropy not yet fully tested in inform!")
  x  <- Dist(c(5, 2, 3, 5, 1, 4, 6, 2, 1, 4, 2, 4))
  y  <- Dist(c(2, 4, 5, 2, 7, 3, 9, 8, 8, 7, 2, 3))
  xy <- Dist(12 * 12)
  for (i in 1:12) {
    for (j in 1:12) xy <- set_item(xy, j + (i - 1) * 12, get_item(x, i) * get_item(y, j))
  }
  expect_equal(shannon_conditional_entropy(xy, y, b = 0.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_conditional_entropy(xy, y, b = 0.5), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_conditional_entropy(xy, y, b = 1.5), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_conditional_entropy(xy, y, b = 2.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_conditional_entropy(xy, y, b = 3.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_conditional_entropy(xy, y, b = 4.0), 0.000000, tolerance = 1e-6)

  x  <- Dist(c(80, 20))
  y  <- Dist(c(25, 75))
  xy <- Dist(c(10, 70, 15, 5))
  expect_equal(shannon_conditional_entropy(xy, y, b = 0.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_conditional_entropy(xy, y, b = 0.5), -0.214171, tolerance = 1e-6)
  expect_equal(shannon_conditional_entropy(xy, y, b = 1.5), 0.366128, tolerance = 1e-6)
  expect_equal(shannon_conditional_entropy(xy, y, b = 2.0), 0.214171, tolerance = 1e-6)
  expect_equal(shannon_conditional_entropy(xy, y, b = 3.0), 0.135127, tolerance = 1e-6)
  expect_equal(shannon_conditional_entropy(xy, y, b = 4.0), 0.107086, tolerance = 1e-6)
})

test_that("shannon_cond_mutual_info checks parameters and functionality", {
  xyz <- Dist(c(24, 24, 9, 6, 25, 15, 10, 5))
  xz  <- Dist(c(15, 9, 5, 10))
  yz  <- Dist(c(9, 15, 10, 15))
  z   <- Dist(c(3, 5))
  expect_error(shannon_cond_mutual_info(Dist("1"),             xz, yz, z, b = 2))
  expect_error(shannon_cond_mutual_info(Dist(NULL),            xz, yz, z, b = 2))
  expect_error(shannon_cond_mutual_info(Dist(NA),              xz, yz, z, b = 2))
  expect_error(shannon_cond_mutual_info(Dist(matrix(1, 2, 2)), xz, yz, z, b = 2))
  expect_error(shannon_cond_mutual_info(Dist(0),               xz, yz, z, b = 2))
  expect_error(shannon_cond_mutual_info(Dist(-1),              xz, yz, z, b = 2))

  expect_error(shannon_cond_mutual_info(xyz, Dist("1"),             yz, z, b = 2))
  expect_error(shannon_cond_mutual_info(xyz, Dist(NULL),            yz, z, b = 2))
  expect_error(shannon_cond_mutual_info(xyz, Dist(NA),              yz, z, b = 2))
  expect_error(shannon_cond_mutual_info(xyz, Dist(matrix(1, 2, 2)), yz, z, b = 2))
  expect_error(shannon_cond_mutual_info(xyz, Dist(0),               yz, z, b = 2))
  expect_error(shannon_cond_mutual_info(xyz, Dist(-1),              yz, z, b = 2))

  expect_error(shannon_cond_mutual_info(xyz, xz, Dist("1"),             z, b = 2))
  expect_error(shannon_cond_mutual_info(xyz, xz, Dist(NULL),            z, b = 2))
  expect_error(shannon_cond_mutual_info(xyz, xz, Dist(NA),              z, b = 2))
  expect_error(shannon_cond_mutual_info(xyz, xz, Dist(matrix(1, 2, 2)), z, b = 2))
  expect_error(shannon_cond_mutual_info(xyz, xz, Dist(0),               z, b = 2))
  expect_error(shannon_cond_mutual_info(xyz, xz, Dist(-1),              z, b = 2))

  expect_error(shannon_cond_mutual_info(xyz, xz, yz, Dist("1"),             b = 2))
  expect_error(shannon_cond_mutual_info(xyz, xz, yz, Dist(NULL),            b = 2))
  expect_error(shannon_cond_mutual_info(xyz, xz, yz, Dist(NA),              b = 2))
  expect_error(shannon_cond_mutual_info(xyz, xz, yz, Dist(matrix(1, 2, 2)), b = 2))
  expect_error(shannon_cond_mutual_info(xyz, xz, yz, Dist(0),               b = 2))
  expect_error(shannon_cond_mutual_info(xyz, xz, yz, Dist(-1),              b = 2))

  expect_error(shannon_cond_mutual_info(xyz, xz, yz, z, b = "b"))
  expect_error(shannon_cond_mutual_info(xyz, xz, yz, z, b = NULL))
  expect_error(shannon_cond_mutual_info(xyz, xz, yz, z, b = NA))
  expect_error(shannon_cond_mutual_info(xyz, xz, yz, z, b = -1))

  skip("shannon_cond_mutual_info not yet fully tested in inform!")
  x  <- Dist(c(5, 2, 3, 5, 1, 4, 6, 2, 1, 4, 2, 4))
  y  <- Dist(c(2, 4, 5, 2, 7, 3, 9, 8, 8, 7, 2, 3))
  xy <- Dist(12 * 12)
  for (i in 1:12) {
    for (j in 1:12) xy <- set_item(xy, j + (i - 1) * 12, get_item(x, i) * get_item(y, j))
  }
  expect_equal(shannon_cond_mutual_info(xy, x, y, b = 0.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_cond_mutual_info(xy, x, y, b = 0.5), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_cond_mutual_info(xy, x, y, b = 1.5), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_cond_mutual_info(xy, x, y, b = 2.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_cond_mutual_info(xy, x, y, b = 3.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_cond_mutual_info(xy, x, y, b = 4.0), 0.000000, tolerance = 1e-6)

  x  <- Dist(c(80, 20))
  y  <- Dist(c(25, 75))
  xy <- Dist(c(10, 70, 15, 5))
  expect_equal(shannon_cond_mutual_info(xy, x, y, b = 0.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_cond_mutual_info(xy, x, y, b = 0.5), -0.214171, tolerance = 1e-6)
  expect_equal(shannon_cond_mutual_info(xy, x, y, b = 1.5), 0.366128, tolerance = 1e-6)
  expect_equal(shannon_cond_mutual_info(xy, x, y, b = 2.0), 0.214171, tolerance = 1e-6)
  expect_equal(shannon_cond_mutual_info(xy, x, y, b = 3.0), 0.135127, tolerance = 1e-6)
  expect_equal(shannon_cond_mutual_info(xy, x, y, b = 4.0), 0.107086, tolerance = 1e-6)
})

test_that("shannon_relative_entropy checks parameters and functionality", {
  p <- Dist(c(2, 3)); q <- Dist(c(5, 3))
  expect_error(shannon_relative_entropy(Dist("1"),             q, b = 2))
  expect_error(shannon_relative_entropy(Dist(NULL),            q, b = 2))
  expect_error(shannon_relative_entropy(Dist(NA),              q, b = 2))
  expect_error(shannon_relative_entropy(Dist(matrix(1, 2, 2)), q, b = 2))
  expect_error(shannon_relative_entropy(Dist(0),               q, b = 2))
  expect_error(shannon_relative_entropy(Dist(-1),              q, b = 2))

  expect_error(shannon_relative_entropy(p, Dist("1"),             b = 2))
  expect_error(shannon_relative_entropy(p, Dist(NULL),            b = 2))
  expect_error(shannon_relative_entropy(p, Dist(NA),              b = 2))
  expect_error(shannon_relative_entropy(p, Dist(matrix(1, 2, 2)), b = 2))
  expect_error(shannon_relative_entropy(p, Dist(0),               b = 2))
  expect_error(shannon_relative_entropy(p, Dist(-1),              b = 2))

  expect_error(shannon_relative_entropy(p, q, b = "b"))
  expect_error(shannon_relative_entropy(p, q, b = NULL))
  expect_error(shannon_relative_entropy(p, q, b = NA))
  expect_error(shannon_relative_entropy(p, q, b = -1))

  p  <- Dist(round(runif(10) * 100))
  expect_equal(shannon_relative_entropy(p, p, b = 0.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_relative_entropy(p, p, b = 0.5), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_relative_entropy(p, p, b = 1.5), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_relative_entropy(p, p, b = 2.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_relative_entropy(p, p, b = 3.0), 0.000000, tolerance = 1e-6)
  expect_equal(shannon_relative_entropy(p, p, b = 4.0), 0.000000, tolerance = 1e-6)

  p <- Dist(c(1, 0, 0)); q <- Dist(c(1, 1, 1))
  for (b in seq(0, 4, 0.5)) {
    expect_equal(shannon_relative_entropy(p, q, b), log2(3) / log2(b), tolerance = 1e-6)
  }

  p <- Dist(c(1, 1, 0))
  for (b in seq(0, 4, 0.5)) {
    expect_equal(shannon_relative_entropy(p, q, b), log2(3/2) / log2(b), tolerance = 1e-6)
  }

  p <- Dist(c(2, 2, 1))
  for (b in seq(0, 4, 0.5)) {
    expect_equal(shannon_relative_entropy(p, q, b),
                 (4 * log2(6 / 5) + log2(3 / 5)) / (5 * log2(b)), tolerance = 1e-6)
  }
})

test_that("shannon_cross_entropy checks parameters and functionality", {
  p <- Dist(c(2, 3)); q <- Dist(c(5, 3))
  expect_error(shannon_cross_entropy(Dist("1"),             q, b = 2))
  expect_error(shannon_cross_entropy(Dist(NULL),            q, b = 2))
  expect_error(shannon_cross_entropy(Dist(NA),              q, b = 2))
  expect_error(shannon_cross_entropy(Dist(matrix(1, 2, 2)), q, b = 2))
  expect_error(shannon_cross_entropy(Dist(0),               q, b = 2))
  expect_error(shannon_cross_entropy(Dist(-1),              q, b = 2))

  expect_error(shannon_cross_entropy(p, Dist("1"),             b = 2))
  expect_error(shannon_cross_entropy(p, Dist(NULL),            b = 2))
  expect_error(shannon_cross_entropy(p, Dist(NA),              b = 2))
  expect_error(shannon_cross_entropy(p, Dist(matrix(1, 2, 2)), b = 2))
  expect_error(shannon_cross_entropy(p, Dist(0),               b = 2))
  expect_error(shannon_cross_entropy(p, Dist(-1),              b = 2))

  expect_error(shannon_cross_entropy(p, q, b = "b"))
  expect_error(shannon_cross_entropy(p, q, b = NULL))
  expect_error(shannon_cross_entropy(p, q, b = NA))
  expect_error(shannon_cross_entropy(p, q, b = -1))

  p  <- Dist(round(runif(10) * 100))
  expect_equal(shannon_cross_entropy(p, p, b = 0.0),
               shannon_entropy(p, b = 0.0), tolerance = 1e-6)
  expect_equal(shannon_cross_entropy(p, p, b = 0.5),
               shannon_entropy(p, b = 0.5), tolerance = 1e-6)
  expect_equal(shannon_cross_entropy(p, p, b = 1.5),
               shannon_entropy(p, b = 1.5), tolerance = 1e-6)
  expect_equal(shannon_cross_entropy(p, p, b = 2.0),
               shannon_entropy(p, b = 2.0), tolerance = 1e-6)
  expect_equal(shannon_cross_entropy(p, p, b = 3.0),
               shannon_entropy(p, b = 3.0), tolerance = 1e-6)
  expect_equal(shannon_cross_entropy(p, p, b = 4.0),
               shannon_entropy(p, b = 4.0), tolerance = 1e-6)

  p <- Dist(c(1, 0, 0)); q <- Dist(c(2, 1, 1))
  for (b in seq(0, 4, 0.5)) {
    expect_equal(shannon_cross_entropy(p, q, b), 1 / log2(b), tolerance = 1e-6)
  }

  p <- Dist(c(1, 1, 0))
  for (b in seq(0, 4, 0.5)) {
    expect_equal(shannon_cross_entropy(p, q, b), 3 / (2 * log2(b)), tolerance = 1e-6)
  }

  p <- Dist(c(2, 2, 1))
  for (b in seq(0, 4, 0.5)) {
    expect_equal(shannon_cross_entropy(p, q, b), 8 / ( 5 * log2(b)), tolerance = 1e-6)
  }
})
