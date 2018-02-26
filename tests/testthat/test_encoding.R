library(rinform)
context("Encoding/Decoding States")

test_that("encode checks parameters and functionality", {
  state <- c(1, 2, 3)
  expect_error(encode("1"))
  expect_error(encode(NULL))
  expect_error(encode(NA))
  expect_error(encode(matrix(1, 2, 2)))
  
  expect_error(encode(state, b = -1))
  expect_error(encode(state, b = 0))
  expect_error(encode(state, b = 1))
  expect_error(encode(state, b = 2))

  expect_equal(encode(0, b = 2), 0)
  expect_equal(encode(1, b = 2), 1)
  expect_equal(encode(0, b = 3), 0)
  expect_equal(encode(1, b = 3), 1)
  expect_equal(encode(2, b = 3), 2)

  expect_equal(encode(c(0, 0), b = 2), 0)
  expect_equal(encode(c(0, 1), b = 2), 1)
  expect_equal(encode(c(1, 0), b = 2), 2)
  expect_equal(encode(c(1, 1), b = 2), 3)

  expect_equal(encode(c(0, 0), b = 3), 0)
  expect_equal(encode(c(0, 1), b = 3), 1)
  expect_equal(encode(c(0, 2), b = 3), 2)
  expect_equal(encode(c(1, 0), b = 3), 3)
  expect_equal(encode(c(1, 1), b = 3), 4)
  expect_equal(encode(c(1, 2), b = 3), 5)
  expect_equal(encode(c(2, 0), b = 3), 6)
  expect_equal(encode(c(2, 1), b = 3), 7)
  expect_equal(encode(c(2, 2), b = 3), 8)  
})

test_that("decode checks parameters and functionality", {
  expect_error(dencode("1",             b = 5))
  expect_error(dencode(NULL,            b = 5))
  expect_error(dencode(NA,              b = 5))
  expect_error(dencode(c(1, 2, 2),      b = 5))
  expect_error(dencode(matrix(1, 2, 2), b = 5))

  state <- 5
  expect_error(decode(state, b = 4, n = 0))
  expect_error(decode(state, b = 4, n = -1))
  expect_error(decode(state, b = 4, n = 1))

  expect <- c(0, 1, 0)
  for (i in 1:3) expect_equal(decode(2, b = 2, n = 3)[i], expect[i])

  expect <- c(1, 0, 1)
  for (i in 1:3) expect_equal(decode(5, b = 2, n = 3)[i], expect[i])

  expect <- c(0, 2, 2)
  for (i in 1:3) expect_equal(decode(8, b = 3, n = 3)[i], expect[i])

  expect <- c(1, 1, 0)
  for (i in 1:3) expect_equal(decode(12, b = 3, n = 3)[i], expect[i])

  for (i in 0:80) {
    state <- decode(i, b = 3, n = 4)
    expect_equal(encode(state, b = 3), i)
  }
})