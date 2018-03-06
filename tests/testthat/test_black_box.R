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

  expect_error(black_box(xs, l = 1, r = "r",    s = NULL))
  expect_error(black_box(xs, l = 1, r = NA,     s = NULL))
  expect_error(black_box(xs, l = 1, r = 0,      s = NULL))
  expect_error(black_box(xs, l = 1, r = -1,     s = NULL))
  expect_error(black_box(xs, l = 2, r = c(1:3), s = NULL))
  expect_error(black_box(xs, l = 1, r = c(3),   s = NULL))

})

test_that("active_info on single series", {
	   
})

test_that("black_box on ensemble of series", {
  series      <- matrix(0, nrow = 8, ncol = 2)
  series[, 1] <- c(1, 1, 0, 0, 1, 0, 0, 1)
  series[, 2] <- c(0, 0, 0, 1, 0, 0, 0, 1)
  expect_equal(active_info(series, k = 2, local = !T), 0.459148, tolerance = 1e-6)

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
  expect_equal(active_info(series, k = 2, local = !T),
               0.3080467, tolerance = 1e-6)

  series      <- matrix(0, nrow = 9, ncol = 4)
  series[, 1] <- c(3, 3, 3, 2, 1, 0, 0, 0, 1)
  series[, 2] <- c(2, 2, 3, 3, 3, 3, 2, 1, 0)
  series[, 3] <- c(0, 0, 0, 0, 1, 1, 0, 0, 0)
  series[, 4] <- c(1, 1, 0, 0, 0, 1, 1, 2, 2)
  expect_equal(active_info(series, k = 2, local = !T), 1.324292, tolerance = 1e-6)
})

test_that("active_info on multiple series", {
	   
})

test_that("black_box on ensemble of multiple series", {
  series      <- matrix(0, nrow = 8, ncol = 2)
  series[, 1] <- c(1, 1, 0, 0, 1, 0, 0, 1)
  series[, 2] <- c(0, 0, 0, 1, 0, 0, 0, 1)
  expect_equal(active_info(series, k = 2, local = !T), 0.459148, tolerance = 1e-6)

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
  expect_equal(active_info(series, k = 2, local = !T),
               0.3080467, tolerance = 1e-6)

  series      <- matrix(0, nrow = 9, ncol = 4)
  series[, 1] <- c(3, 3, 3, 2, 1, 0, 0, 0, 1)
  series[, 2] <- c(2, 2, 3, 3, 3, 3, 2, 1, 0)
  series[, 3] <- c(0, 0, 0, 0, 1, 1, 0, 0, 0)
  series[, 4] <- c(1, 1, 0, 0, 0, 1, 1, 2, 2)
  expect_equal(active_info(series, k = 2, local = !T), 1.324292, tolerance = 1e-6)
})