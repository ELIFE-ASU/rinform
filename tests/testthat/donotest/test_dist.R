################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################
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

test_that("infer checks parameters", {
  expect_error(infer(NULL))
  expect_error(infer(NA))
  expect_error(infer("series"))

  xs <- c(0, 0, 0, 0, 0, 1, 1, 1, 1, 1)
  expect_equal(probability(infer(xs), 1), 0.5)
  expect_equal(probability(infer(xs), 2), 0.5)
})

test_that("approximate checks parameters", {
  p <- c(0.1234, 1.0 - 0.1234)
  
  expect_error(approximate(NULL, 0.1))
  expect_error(approximate(NA, 0.1))
  expect_error(approximate("probs", 0.1))
  expect_error(approximate(-1, 0.1))
  expect_error(approximate(1.2, 0.1))
  expect_error(approximate(p, NULL))
  expect_error(approximate(p, NA))
  expect_error(approximate(p, "tol"))

  expect_equal(probability(approximate(p, 0.1), 1), 1.0 / 9.0)
  expect_equal(probability(approximate(p, 0.1), 2), 8.0 / 9.0)
})


test_that("uniform checks parameters", {
  expect_error(uniform(NULL))
  expect_error(uniform(NA))
  expect_error(uniform(0))
  expect_error(uniform(-1))
  expect_error(uniform("dist"))

  expect_equal(probability(uniform(3), 1), 1.0 / 3)
  expect_equal(probability(uniform(3), 2), 1.0 / 3)
  expect_equal(probability(uniform(3), 3), 1.0 / 3)
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

test_that("accumulate checks parameters", {
  d      <- Dist(c(13, 56, 32))
  events <- sample(0:2, 100, T)

  dc      <- d
  dc$size <- 5
  expect_error(accumulate(dc, events))

  dc           <- d
  dc$histogram <- "two"
  expect_error(accumulate(dc, events))

  dc           <- d
  dc$counts <- "two"
  expect_error(accumulate(dc, events))

  dc        <- d
  class(dc) <- "two"
  expect_error(accumulate(dc, events))
  expect_error(accumulate(d, NA))
  
  expect_equal(counts(accumulate(d, events)), 201)
})

test_that("probability checks parameters", {
  d <- Dist(c(13, 56, 32))

  dc      <- d
  dc$size <- 0
  expect_error(probability(dc, 1))

  dc           <- d
  dc$histogram <- "two"
  expect_error(probability(dc, 1))

  dc           <- d
  dc$counts <- "two"
  expect_error(probability(dc, 1))

  dc        <- d
  class(dc) <- "two"
  expect_error(probability(dc, 1))

  expect_equal(probability(d, 1), 13 / 101.0)
  expect_equal(probability(d, 2), 56 / 101.0)
  expect_equal(probability(d, 3), 32 / 101.0)
})

test_that("dump checks parameters", {
  d <- Dist(c(13, 56, 32))

  dc      <- d
  dc$size <- 0
  expect_error(dump(dc))

  dc           <- d
  dc$histogram <- "two"
  expect_error(dump(dc))

  dc           <- d
  dc$counts <- "two"
  expect_error(dump(dc))

  dc        <- d
  class(dc) <- "two"
  expect_error(dump(dc))

  expect_equal(dump(d)[1], 13 / 101.0)
  expect_equal(dump(d)[2], 56 / 101.0)
  expect_equal(dump(d)[3], 32 / 101.0)
})
