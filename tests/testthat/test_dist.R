library(rinform)
context("Distributions")

test_that("Dist checks parameters", {
  expect_error(Dist("1"))
  expect_error(Dist(NULL))
  expect_error(Dist(NA))
  expect_error(Dist(matrix(1, 2, 2)))
  expect_error(Dist(0))
  expect_error(Dist(-1))
})

test_that("resize checks parameters", {
  d <- Dist(3)
  expect_error(resize(NULL, 5))
  expect_error(resize(NA, 5))
  expect_error(resize(1, 5))
  expect_error(resize("dist", 5))

  expect_error(resize(d, 0))
  expect_error(resize(d, -1))
  expect_error(resize(d, "two"))
  expect_error(resize(d, NULL))
  expect_error(resize(d, NA))

  expect_equal(length(resize(d, 5)), 5)
  expect_equal(length(resize(d, 10)), 10)
  expect_equal(length(resize(d, 5)), 5)
  expect_equal(length(resize(d, 3)), 3)  
})

test_that("copy checks parameters", {
  d <- Dist(c(13, 56, 32))
  expect_error(copy(NULL))
  expect_error(copy(NA))
  expect_error(copy(1))
  expect_error(copy("dist"))

  expect_equal(length(copy(d)), 3)
  expect_equal(counts(copy(d)), 101)
})

test_that("length checks parameters", {
  d <- Dist(c(13, 56, 32))

  dc      <- d
  dc$size <- 5
  expect_error(length(dc))

  dc           <- d
  dc$histogram <- "two"
  expect_error(length(dc))

  dc           <- d
  dc$counts <- "two"
  expect_error(length(dc))
})

test_that("get_item checks parameters", {
  d <- Dist(c(13, 56, 32))

  dc      <- d
  dc$size <- 5
  expect_error(get_item(dc, 1))

  dc           <- d
  dc$histogram <- "two"
  expect_error(get_item(dc, 1))

  dc           <- d
  dc$counts <- "two"
  expect_error(get_item(dc, 1))

  dc        <- d
  class(dc) <- "two"
  expect_error(get_item(dc, 1, 1))

  expect_equal(get_item(d, 1), 13)
  expect_equal(get_item(d, 2), 56)
  expect_equal(get_item(d, 3), 32)
})

test_that("set_item checks parameters", {
  d <- Dist(c(13, 56, 32))

  dc      <- d
  dc$size <- 5
  expect_error(set_item(dc, 1, 1))

  dc           <- d
  dc$histogram <- "two"
  expect_error(set_item(dc, 1, 1))

  dc           <- d
  dc$counts <- "two"
  expect_error(set_item(dc, 1, 1))

  dc        <- d
  class(dc) <- "two"
  expect_error(set_item(dc, 1, 1))

  expect_error(set_item(d, 0, 1))
  expect_error(set_item(d, -1, 1))

  expect_equal(set_item(d, 1, 0)$histogram[1], 0)
  expect_equal(set_item(d, 2, 0)$histogram[2], 0)
  expect_equal(set_item(d, 3, 0)$histogram[3], 0)
})

test_that("counts checks parameters", {
  d <- Dist(c(13, 56, 32))

  dc      <- d
  dc$size <- 5
  expect_error(counts(dc))

  dc           <- d
  dc$histogram <- "two"
  expect_error(counts(dc))

  dc           <- d
  dc$counts <- "two"
  expect_error(counts(dc))

  dc        <- d
  class(dc) <- "two"
  expect_error(counts(dc))

  expect_equal(counts(d), 101)
})

test_that("valid checks parameters", {
  d <- Dist(c(13, 56, 32))

  dc      <- d
  dc$size <- 5
  expect_equal(valid(dc), !T)  

  dc           <- d
  dc$histogram <- "two"
  expect_equal(valid(dc), !T)  

  dc           <- d
  dc$counts <- "two"
  expect_equal(valid(dc), !T)  

  dc        <- d
  class(dc) <- "two"
  expect_error(valid(dc))

  expect_equal(valid(d), T)  
})

test_that("tick checks parameters", {
  d <- Dist(c(13, 56, 32))

  dc      <- d
  dc$size <- 5
  expect_error(tick(dc, 1))

  dc           <- d
  dc$histogram <- "two"
  expect_error(tick(dc, 1))

  dc           <- d
  dc$counts <- "two"
  expect_error(tick(dc, 1))

  dc        <- d
  class(dc) <- "two"
  expect_error(tick(dc, 1))

  expect_equal(counts(tick(d, 1)), 102)
  expect_equal(counts(tick(d, 2)), 102)
  expect_equal(counts(tick(d, 3)), 102)
})
