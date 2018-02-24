library(rinform)
context("Cross Entropy")

test_that("cross_entropy checks parameters", {
  ps <- sample(0:1, 10, T)
  qs <- sample(0:1, 10, T)
  
  expect_error(cross_entropy("series", qs))
  expect_error(cross_entropy(NULL,     qs))
  expect_error(cross_entropy(NA,       qs))
  expect_error(cross_entropy(1,       qs))
  expect_error(cross_entropy(ps, "series"))
  expect_error(cross_entropy(ps, NULL))
  expect_error(cross_entropy(ps, NA))    
  expect_error(cross_entropy(ps, 1))    
})

test_that("cross_entropy on single series", {
  expect_equal(cross_entropy(c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                             c(1, 0, 0, 1, 0, 0, 1, 0, 0)),
			     log2(3) - 5.0 / 9.0, tolerance = 1e-6)
  expect_equal(cross_entropy(c(1, 0, 0, 1, 0, 0, 1, 0, 0),
                             c(0, 0, 1, 1, 1, 1, 0, 0, 0)),
			     (18 * log2(3) - 6 * log2(5) - 6) / 9.0, tolerance = 1e-6)
  expect_equal(cross_entropy(c(0, 0, 1, 1, 1, 1, 0, 0, 0),
                             c(1, 1, 0, 0, 0, 0, 1, 1, 1)),
			     (18 * log2(3) - 4 * log2(5) - 10) / 9.0, tolerance = 1e-6)
  expect_equal(cross_entropy(c(0, 0, 0, 0, 0, 0, 0, 0, 0),
                             c(1, 1, 1, 0, 0, 0, 1, 1, 1)),
			     log2(3), tolerance = 1e-6)
  expect_equal(cross_entropy(c(0, 1, 0, 0, 1, 0, 0, 1, 0),
                             c(1, 0, 0, 1, 0, 0, 1, 0, 0)),
			     log2(3) - 6.0/ 9.0, tolerance = 1e-6)
  expect_equal(cross_entropy(c(1, 0, 0, 1, 0, 0, 1, 0),
                             c(2, 0, 1, 2, 0, 1, 2, 0)),
			     (24 - 5 * log2(3) - 3) / 8.0, tolerance = 1e-6)
})