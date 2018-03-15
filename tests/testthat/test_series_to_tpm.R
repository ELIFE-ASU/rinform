################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################
library(rinform)
context("Time Series to TPM")

test_that("series_to_tpm checks parameters and functionality", {  
  expect_error(series_to_tpm("1"))
  expect_error(series_to_tpm(NULL))
  expect_error(series_to_tpm(NA))
  expect_error(series_to_tpm(matrix(1, 2, 2)))

  xs       <- matrix(c(1, 1, 1, 1, 1, 0), ncol = 2)
  expect_error(series_to_tpm(xs))

  xs       <- matrix(c(0, 1, 0, 1, 1, 0), ncol = 2)
  expected <- matrix(c(0.000000, 1.000000, 0.666667, 0.333333), ncol = 2)
  for (i in 1:2) {
    for (j in 1:2) {
      expect_equal(series_to_tpm(xs)[i, j], expected[i, j], tolerance = 1e-6)
    }
  }

  xs       <- c(0, 0, 1, 1, 0, 1, 0, 1, 1, 1)
  expected <- matrix(c(0.250000, 0.750000, 0.400000, 0.600000), ncol = 2)
  for (i in 1:2) {
    for (j in 1:2) {
      expect_equal(series_to_tpm(xs)[i, j], expected[i, j], tolerance = 1e-6)
    }
  }

  xs       <- matrix(c(0, 0, 1, 1, 0, 1, 0, 1, 1, 1), ncol = 2)
  expected <- matrix(c(0.333333, 0.666667, 0.400000, 0.600000), ncol = 2)
  for (i in 1:2) {
    for (j in 1:2) {
      expect_equal(series_to_tpm(xs)[i, j], expected[i, j], tolerance = 1e-6)
    }
  }

  xs       <- c(0, 1, 2, 2, 1, 1, 0, 0, 1, 2)
  expected <- matrix(c(0.333333, 0.666667, 0.000000,
                       0.250000, 0.250000, 0.500000,
                       0.000000, 0.500000, 0.500000), ncol = 3)
  for (i in 1:3) {
    for (j in 1:3) {
      expect_equal(series_to_tpm(xs)[i, j], expected[i, j], tolerance = 1e-6)
    }
  }

  xs       <- matrix(c(0, 1, 2, 2, 1, 1, 0, 0, 1, 2), ncol = 2)
  expected <- matrix(c(0.333333, 0.666667, 0.000000,
                       0.333333, 0.000000, 0.666667,
                       0.000000, 0.500000, 0.500000), ncol = 3)
  for (i in 1:3) {
    for (j in 1:3) {
      expect_equal(series_to_tpm(xs)[i, j], expected[i, j], tolerance = 1e-6)
    }
  }
})