library(rinform)
context("Partitioning Time Series")

test_that("partitioning checks parameters and functionality", {  
  expect_error(partitioning("1"))
  expect_error(partitioning(NULL))
  expect_error(spartitioning(NA))
  expect_error(partitioning(c(1, 2, 2)))
  expect_error(partitioning(matrix(1, 2, 2)))

  P <- partitioning(2) - 1
  expected <- matrix(c(0, 0,
                       0, 1), ncol = 2)
  for (i in 1:2) {
    for (j in 1:2) {
      expect_equal(P[j, i], expected[j, i], tolerance = 1e-6)
    }
  }

  P <- partitioning(3) - 1
  expected <- matrix(c(0, 0, 0,
                       0, 0, 1,
                       0, 1, 0,
		       0, 1, 1,
		       0, 1, 2), ncol = 5)
  for (i in 1:5) {
    for (j in 1:3) {
      expect_equal(P[j, i], expected[j, i], tolerance = 1e-6)
    }
  }

  P <- partitioning(4) - 1
  expected <- matrix(c(0, 0, 0, 0,
                       0, 0, 0, 1,
                       0, 0, 1, 0,
		       0, 0, 1, 1,
		       0, 0, 1, 2,
		       0, 1, 0, 0,
                       0, 1, 0, 1,
                       0, 1, 0, 2,
                       0, 1, 1, 0,
		       0, 1, 1, 1,
		       0, 1, 1, 2,
                       0, 1, 2, 0,
		       0, 1, 2, 1,
		       0, 1, 2, 2,
		       0, 1, 2, 3), ncol = 15)
  for (i in 1:15) {
    for (j in 1:4) {
      expect_equal(P[j, i], expected[j, i], tolerance = 1e-6)
    }
  }

})