################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################
library(rinform)
context("Coalesce Time Series")

test_that("coalesce checks parameters and functionality", {  
  expect_error(coalesce("1"))
  expect_error(coalesce(NULL))
  expect_error(coalesce(NA))
  expect_error(coalesce(matrix(1, 2, 2)))

  xs <- c(0, 2, 2, 1, 2, 3)
  expect_equal(coalesce(xs)$b, 4)
  for (i in 1:6) expect_equal(coalesce(xs)$series[i], xs[i])

  xs <- c(1, 3, 3, 2, 3, 4)
  expect_equal(coalesce(xs)$b, 4)
  for (i in 1:6) expect_equal(coalesce(xs)$series[i], xs[i] - 1)

  xs <- c(2, 8, 7, 2, 0, 0)
  ys <- c(1, 3, 2, 1, 0, 0)
  expect_equal(coalesce(xs)$b, 4)
  for (i in 1:6) expect_equal(coalesce(xs)$series[i], ys[i])
})