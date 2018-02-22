library(rinform)
context("Binning Time Series")

test_that("series_range checks parameters", {  
  expect_error(series_range("1"))
  expect_error(series_range(NULL))
  expect_error(series_range(NA))
  expect_error(series_range(matrix(1, 2, 2)))

  xs <- c(0, 0, 0, 1, 1, 1)
  expect_equal(series_range(xs)$srange, 1)
  expect_equal(series_range(xs)$smin, 0)
  expect_equal(series_range(xs)$smax, 1)

  xs <- c(0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3)
  expect_equal(series_range(xs)$srange, 3)
  expect_equal(series_range(xs)$smin, 0)
  expect_equal(series_range(xs)$smax, 3)
})

test_that("bin_series checks parameters", {
  xs <- c(0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3)
  expect_error(bin_series("1", b = 1))
  expect_error(bin_series(NULL, b = 1))
  expect_error(bin_series(NA, b = 1))
  expect_error(bin_series(matrix(1, 2, 2), b = 1))

  expect_error(bin_series(xs, b = -1))
  expect_error(bin_series(xs, b = NA))

  expect_error(bin_series(xs, b = NA, step = -1))
  expect_error(bin_series(xs, b = NA, step = NA))

  expect_error(bin_series(xs, b = NA, step = NA, bounds = NULL))
  expect_error(bin_series(xs, b = NA, step = NA, bounds = NA))

  expect_equal(bin_series(xs, b = 3)$b, 3)
  expect_equal(bin_series(xs, step = 1)$b, 4)
  expect_equal(bin_series(xs, bounds = c(3, 4))$b, 2)
})