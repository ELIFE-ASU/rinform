################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################
library(rinform)
context("Effective Information")

test_that("effective_info checks parameters", {
  tpm <- matrix(c(0.25, 0.75, 0.3, 0.75), 2, 2)
  expect_error(effective_info("tpm",    inter = NULL))
  expect_error(effective_info(NULL,     inter = NULL))
  expect_error(effective_info(NA,       inter = NULL))
  expect_error(effective_info(c(1:5),   inter = NULL))
  expect_error(effective_info(tpm,      inter = NULL))

  tpm <- matrix(c(0.25, 0.75, 0.3, 0.7), 2, 2)
  expect_error(effective_info(tpm, inter = "NULL"))
  expect_error(effective_info(tpm, inter = NA))
  expect_error(effective_info(tpm, inter = 0))
  expect_error(effective_info(tpm, inter = -1))
  expect_error(effective_info(tpm, inter = c(1:5)))
})

test_that("effective_info on different interventions", {
  tpm <- matrix(c(0.2, 0.8, 0.75, 0.25), 2, 2);  inter <- c(0.25, 0.75)
  expect_equal(effective_info(tpm, inter), 0.174227, tolerance = 1e-6)
  expect_equal(effective_info(tpm, NULL), 0.231593, tolerance = 1e-6)

  tpm      <- matrix(0, nrow = 3, ncol = 3)
  tpm[, 1] <- c(1.0 / 3, 1.0 / 3, 1.0 / 3)
  tpm[, 2] <- c(0.250, 0.750, 0.000)
  tpm[, 3] <- c(0.125, 0.500, 0.375)
  inter    <- c(0.300, 0.250, 0.450)
  expect_equal(effective_info(tpm, inter), 0.1724976, tolerance = 1e-6)
  expect_equal(effective_info(tpm, NULL), 0.202701, tolerance = 1e-6)

  ## E. Hoel, "When the map is better than the territory", arXiv:1612.09592
  tpm      <- matrix(0, nrow = 4, ncol = 4)
  tpm[, 1] <- c(0, 0, 1, 0)
  tpm[, 2] <- c(1, 0, 0, 0)
  tpm[, 3] <- c(0, 0, 0, 1)
  tpm[, 4] <- c(0, 1, 0, 0)
  expect_equal(effective_info(tpm, NULL), 2.0, tolerance = 1e-6)

  tpm      <- matrix(0, nrow = 4, ncol = 4)
  tpm[, 1] <- c(1.0 / 3, 1.0 / 3, 1.0 / 3, 0.000)
  tpm[, 2] <- c(1.0 / 3, 1.0 / 3, 1.0 / 3, 0.000)
  tpm[, 3] <- c(0,             0,       0, 1.0)
  tpm[, 4] <- c(0,             0,       0, 1.0)
  expect_equal(effective_info(tpm, NULL), 1.0, tolerance = 1e-6)

  tpm      <- matrix(0, nrow = 8, ncol = 8)
  tpm[, 1] <- c(1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 0.000)
  tpm[, 2] <- c(1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 0.000)
  tpm[, 3] <- c(1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 0.000)
  tpm[, 4] <- c(1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 0.000)
  tpm[, 5] <- c(1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 0.000)
  tpm[, 6] <- c(1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 0.000)
  tpm[, 7] <- c(1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 0.000)
  tpm[, 8] <- c(0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000)
  expect_equal(effective_info(tpm, NULL), 0.543565, tolerance = 1e-6)

  tpm      <- matrix(0, nrow = 8, ncol = 8)
  tpm[, 1] <- c(1.0/5, 1.0/5, 1.0/5, 1.0/5, 1.0/5, 0.000, 0.000, 0.000)
  tpm[, 2] <- c(1.0/7, 3.0/7, 1.0/7, 0.000, 1.0/7, 0.000, 1.0/7, 0.000)
  tpm[, 3] <- c(0.000, 1.0/6, 1.0/6, 1.0/6, 1.0/6, 1.0/6, 1.0/6, 0.000)
  tpm[, 4] <- c(1.0/7, 0.000, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 2.0/7, 0.000)
  tpm[, 5] <- c(1.0/9, 2.0/9, 2.0/9, 1.0/9, 0.000, 2.0/9, 1.0/9, 0.000)
  tpm[, 6] <- c(1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 1.0/7, 0.000)
  tpm[, 7] <- c(1.0/6, 1.0/6, 0.000, 1.0/6, 1.0/6, 1.0/6, 1.0/6, 0.000)
  tpm[, 8] <- c(0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000)
  expect_equal(effective_info(tpm, NULL), 0.805890, tolerance = 1e-6)

  tpm      <- matrix(0, nrow = 8, ncol = 8)
  tpm[, 1] <- c(1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8)
  tpm[, 2] <- c(1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8)
  tpm[, 3] <- c(1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8)
  tpm[, 4] <- c(1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8)
  tpm[, 5] <- c(1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8)
  tpm[, 6] <- c(1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8, 1.0/8)
  tpm[, 7] <- c(0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 0.000)
  tpm[, 8] <- c(0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000)
  expect_equal(effective_info(tpm, NULL), 0.630240, tolerance = 1e-6)
})