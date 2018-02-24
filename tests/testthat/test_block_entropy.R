library(rinform)
context("Block Entropy")

test_that("block_entropy checks parameters", {
  xs <- sample(0:1, 10, T)
  expect_error(block_entropy("series", k = 1, local = !T))
  expect_error(block_entropy(NULL,     k = 1, local = !T))
  expect_error(block_entropy(NA,       k = 1, local = !T))
  
  expect_error(block_entropy(xs, k = "k",  local = !T))
  expect_error(block_entropy(xs, k = NULL, local = !T))
  expect_error(block_entropy(xs, k = NA,   local = !T))  
  expect_error(block_entropy(xs, k = 0,    local = !T))
  expect_error(block_entropy(xs, k = -1,   local = !T))
  
  expect_error(block_entropy(xs, k = 1, local = "TRUE"))
  expect_error(block_entropy(xs, k = 1, local = NULL))
  expect_error(block_entropy(xs, k = 1, local = NA))  
})

test_that("block_entropy on single series", {
  expect_equal(block_entropy(c(1, 1, 0, 0, 1, 0, 0, 1), k = 2, local = !T),
               1.950212, tolerance = 1e-6)
  expect_equal(block_entropy(c(1, 0, 0, 0, 0, 0, 0, 0, 0), k = 2, local = !T),
               0.543564, tolerance = 1e-6)
  expect_equal(block_entropy(c(0, 0, 1, 1, 1, 1, 0, 0, 0), k = 2, local = !T),
               1.811278, tolerance = 1e-6)
  expect_equal(block_entropy(c(1, 0, 0, 0, 0, 0, 0, 1, 1), k = 2, local = !T),
               1.548795, tolerance = 1e-6)
  expect_equal(block_entropy(c(3, 3, 3, 2, 1, 0, 0, 0, 1), k = 2, local = !T),
               2.50000, tolerance = 1e-6)
  expect_equal(block_entropy(c(2, 2, 3, 3, 3, 3, 2, 1, 0), k = 2, local = !T),
               2.40564, tolerance = 1e-6)
  expect_equal(block_entropy(c(2, 2, 2, 2, 2, 2, 1, 1, 1), k = 2, local = !T),
               1.298794, tolerance = 1e-6)			   
})

test_that("block_entropy on ensemble of series", {
  series      <- matrix(0, nrow = 8, ncol = 2)
  series[, 1] <- c(1, 1, 0, 0, 1, 0, 0, 1)
  series[, 2] <- c(0, 0, 0, 1, 0, 0, 0, 1)
  expect_equal(block_entropy(series, k = 2, local = !T),
               1.788450, tolerance = 1e-6)

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
  expect_equal(block_entropy(series, k = 2, local = !T),
               1.649204, tolerance = 1e-6)

  series      <- matrix(0, nrow = 9, ncol = 4)
  series[, 1] <- c(3, 3, 3, 2, 1, 0, 0, 0, 1)
  series[, 2] <- c(2, 2, 3, 3, 3, 3, 2, 1, 0)
  series[, 3] <- c(0, 0, 0, 0, 1, 1, 0, 0, 0)
  series[, 4] <- c(1, 1, 0, 0, 0, 1, 1, 2, 2)
  expect_equal(block_entropy(series, k = 2, local = !T),
               3.010976, tolerance = 1e-6)
})

test_that("active_info local on single series", {
  expect_equal(mean(block_entropy(c(1, 1, 0, 0, 1, 0, 0, 1), k = 2, local = T)),
               1.950212, tolerance = 1e-6)
  expect_equal(mean(block_entropy(c(1, 0, 0, 0, 0, 0, 0, 0, 0), k = 2, local = T)),
               0.543564, tolerance = 1e-6)
  expect_equal(mean(block_entropy(c(0, 0, 1, 1, 1, 1, 0, 0, 0), k = 2, local = T)),
               1.811278, tolerance = 1e-6)
  expect_equal(mean(block_entropy(c(1, 0, 0, 0, 0, 0, 0, 1, 1), k = 2, local = T)),
               1.548795, tolerance = 1e-6)
  expect_equal(mean(block_entropy(c(3, 3, 3, 2, 1, 0, 0, 0, 1), k = 2, local = T)),
               2.50000, tolerance = 1e-6)
  expect_equal(mean(block_entropy(c(2, 2, 3, 3, 3, 3, 2, 1, 0), k = 2, local = T)),
               2.40564, tolerance = 1e-6)
  expect_equal(mean(block_entropy(c(2, 2, 2, 2, 2, 2, 1, 1, 1), k = 2, local = T)),
               1.298794, tolerance = 1e-6)			   
})

test_that("block_entropy local on ensemble of series", {
  series      <- matrix(0, nrow = 8, ncol = 2)
  series[, 1] <- c(1, 1, 0, 0, 1, 0, 0, 1)
  series[, 2] <- c(0, 0, 0, 1, 0, 0, 0, 1)
  expect_equal(mean(block_entropy(series, k = 2, local = T)),
               1.788450, tolerance = 1e-6)

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
  expect_equal(mean(block_entropy(series, k = 2, local = T)),
               1.649204, tolerance = 1e-6)

  series      <- matrix(0, nrow = 9, ncol = 4)
  series[, 1] <- c(3, 3, 3, 2, 1, 0, 0, 0, 1)
  series[, 2] <- c(2, 2, 3, 3, 3, 3, 2, 1, 0)
  series[, 3] <- c(0, 0, 0, 0, 1, 1, 0, 0, 0)
  series[, 4] <- c(1, 1, 0, 0, 0, 1, 1, 2, 2)
  expect_equal(mean(block_entropy(series, k = 2, local = T)),
               3.010976, tolerance = 1e-6)
})
