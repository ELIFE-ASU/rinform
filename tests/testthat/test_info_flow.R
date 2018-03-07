library(rinform)
context("Information Flow")

test_that("info_flow checks parameters", {
  src  <- sample(0:1, 30, T)
  dst  <- sample(0:1, 30, T)
  back <- sample(0:1, 30, T)
  
  expect_error(info_flow("src",  dst = dst, back = NULL, lsrc = 1, ldst = 1, lback = 0))
  expect_error(info_flow(NULL,   dst = dst, back = NULL, lsrc = 1, ldst = 1, lback = 0))
  expect_error(info_flow(NA,     dst = dst, back = NULL, lsrc = 1, ldst = 1, lback = 0))
  expect_error(info_flow(matrix(src, ncol = 2), dst = dst, back = NULL,
                         lsrc = 2, ldst = 1, lback = 0))

  expect_error(info_flow(src = src, "dst", back = NULL, lsrc = 1, ldst = 1, lback = 0))
  expect_error(info_flow(src = src, NULL,  back = NULL, lsrc = 1, ldst = 1, lback = 0))
  expect_error(info_flow(src = src, NA,    back = NULL, lsrc = 1, ldst = 1, lback = 0))
  expect_error(info_flow(src = src, matrix(src, ncol = 2), back = NULL,
                         lsrc = 1, ldst = 2, lback = 0))

  expect_error(info_flow(src = src, dst = dst, back = "back",
                         lsrc = 1, ldst = 1, lback = 1))
  expect_error(info_flow(src = src, dst = dst, back = NA,
                         lsrc = 1, ldst = 1, lback = 0))
  expect_error(info_flow(src = src, dst = dst, back = matrix(src, ncol = 2),
                         lsrc = 1, ldst = 1, lback = 2))

  expect_error(info_flow(src, dst, back, lsrc = 0, ldst = 1, lback = 1))
  expect_error(info_flow(src, dst, back, lsrc = 1, ldst = 0, lback = 1))
  expect_error(info_flow(src, dst, back, lsrc = 1, ldst = 1, lback = 0))

  expect_error(info_flow(src, dst, back, lsrc = "0", ldst = 1,   lback = 1))
  expect_error(info_flow(src, dst, back, lsrc = 1,   ldst = "0", lback = 1))
  expect_error(info_flow(src, dst, back, lsrc = 1,   ldst = 1,   lback = "0"))

  expect_error(info_flow(src, dst, back, lsrc = NULL, ldst = 1, lback = 1))
  expect_error(info_flow(src, dst, back, lsrc = 1, ldst = NULL, lback = 1))
  expect_error(info_flow(src, dst, back, lsrc = 1, ldst = 1, lback = NULL))

  expect_error(info_flow(src, dst, back, lsrc = NA, ldst = 1, lback = 1))
  expect_error(info_flow(src, dst, back, lsrc = 1, ldst = NA, lback = 1))
  expect_error(info_flow(src, dst, back, lsrc = 1, ldst = 1, lback = NA))

  expect_error(info_flow(src, dst, back, lsrc = 2, ldst = 1, lback = 1))
  expect_error(info_flow(src, dst, back, lsrc = 1, ldst = 2, lback = 1))
  expect_error(info_flow(src, dst, back, lsrc = 1, ldst = 1, lback = 2))
})

test_that("info_flow functionality", {
  A <- c(1, 1, 1, 0, 0, 0)
  B <- c(0, 0, 0, 1, 1, 1)
  S <- c(1, 1, 1, 1, 1, 1)
  expect_equal(info_flow(A, B, NULL, 1, 1, 0), 1.0, tolerance = 1e-6)
  expect_equal(info_flow(B, A, NULL, 1, 1, 0), 1.0, tolerance = 1e-6)
  expect_equal(info_flow(A, B, S, 1, 1, 1),    1.0, tolerance = 1e-6)
  expect_equal(info_flow(B, A, S, 1, 1, 1),    1.0, tolerance = 1e-6)
  expect_equal(info_flow(A, A, NULL, 1, 1, 0), 1.0, tolerance = 1e-6)
  expect_equal(info_flow(B, B, NULL, 1, 1, 0), 1.0, tolerance = 1e-6)

  A      <- c(1, 1, 1, 1, 0, 0)
  B      <- c(0, 0, 1, 1, 1, 1)
  S      <- c(1, 1, 1, 1, 1, 1)
  expect <- log2(3.0) - 4.0/3.0
  expect_equal(info_flow(A, B, NULL, 1, 1, 0), expect, tolerance = 1e-6)
  expect_equal(info_flow(B, A, NULL, 1, 1, 0), expect, tolerance = 1e-6)
  expect_equal(info_flow(A, B, S, 1, 1, 1),    expect, tolerance = 1e-6)
  expect_equal(info_flow(B, A, S, 1, 1, 1),    expect, tolerance = 1e-6)
  expect_equal(info_flow(A, A, NULL, 1, 1, 0), expect + 2/3, tolerance = 1e-6)
  expect_equal(info_flow(B, B, NULL, 1, 1, 0), expect + 2/3, tolerance = 1e-6)

  A      <- matrix(c(1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0), ncol = 2)
  B      <- c(0, 0, 1, 1, 1, 1)
  S      <- c(1, 1, 1, 1, 1, 1)
  expect <- log2(3.0) - 4.0/3.0
  expect_equal(info_flow(A, B, NULL, 2, 1, 0), expect, tolerance = 1e-6)
  expect_equal(info_flow(B, A, NULL, 1, 2, 0), expect, tolerance = 1e-6)
  expect_equal(info_flow(A, B, S, 2, 1, 1),    expect, tolerance = 1e-6)
  expect_equal(info_flow(B, A, S, 1, 2, 1),    expect, tolerance = 1e-6)
  expect_equal(info_flow(A, A, NULL, 2, 2, 0), log2(3.0), tolerance = 1e-6)

  A <- c(1, 1, 1, 0, 0, 0)
  B <- c(0, 0, 0, 1, 1, 1)
  S <- c(0, 0, 1, 1, 0, 0)
  expect_equal(info_flow(A, B, S, 1, 1, 1), 1.0, tolerance = 1e-6)
  expect_equal(info_flow(B, A, S, 1, 1, 1), 1.0, tolerance = 1e-6)
  expect_equal(info_flow(S, A, B, 1, 1, 1),    0.0, tolerance = 1e-6)
  expect_equal(info_flow(S, B, A, 1, 1, 1),    0.0, tolerance = 1e-6)

  A <- c(1, 1, 0, 0, 0, 0)
  B <- c(0, 0, 0, 0, 1, 1)
  S <- c(0, 0, 1, 1, 0, 0)
  expect_equal(info_flow(A, B, S, 1, 1, 1), 2 / 3, tolerance = 1e-6)
  expect_equal(info_flow(B, A, S, 1, 1, 1), 2 / 3, tolerance = 1e-6)
  expect_equal(info_flow(S, A, B, 1, 1, 1), 2 / 3, tolerance = 1e-6)
  expect_equal(info_flow(S, B, A, 1, 1, 1), 2 / 3, tolerance = 1e-6)

  A <- c(1, 1, 0, 0, 0, 0)
  B <- c(0, 0, 1, 0, 1, 1)
  S <- c(0, 0, 1, 1, 0, 0)
  expect_equal(info_flow(A, B, S, 1, 1, 1), 2 / 3, tolerance = 1e-6)
  expect_equal(info_flow(B, A, S, 1, 1, 1), 2 / 3, tolerance = 1e-6)
  expect_equal(info_flow(S, A, B, 1, 1, 1), log2(3) / 2 - 1 / 3, tolerance = 1e-6)
  expect_equal(info_flow(S, B, A, 1, 1, 1), 1 - 0.5 * log2(3), tolerance = 1e-6)

  A      <- matrix(c(1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0), ncol = 2)
  B      <- c(0, 0, 1, 0, 1, 1)
  S      <- c(0, 0, 1, 1, 0, 0)
  expect_equal(info_flow(A, B, S, 2, 1, 1), 1.0, tolerance = 1e-6)
  expect_equal(info_flow(B, A, S, 1, 2, 1), 1.0, tolerance = 1e-6)
  expect_equal(info_flow(S, A, B, 1, 2, 1),    log2(3.0) - 1.0, tolerance = 1e-6)
  expect_equal(info_flow(S, B, A, 1, 1, 2),    1 / 3, tolerance = 1e-6)
})
