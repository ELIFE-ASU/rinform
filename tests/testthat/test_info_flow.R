library(rinform)
context("Evidence of Integration")

test_that("integration_evidence checks parameters", {
  series <- sample(0:1, 30, T)
  
  expect_error(integration_evidence("series", parts = NULL))
  expect_error(integration_evidence(NULL,     parts = NULL))
  expect_error(integration_evidence(NA,       parts = NULL))
  expect_error(integration_evidence(series,   parts = NULL))
  
  series <- matrix(series, ncol = 3)
  expect_error(integration_evidence(series, parts = "parts"))
  expect_error(integration_evidence(series, parts = NA))
  expect_error(integration_evidence(series, parts = c(0)))
  expect_error(integration_evidence(series, parts = c(1)))
  expect_error(integration_evidence(series, parts = c(2)))
  expect_error(integration_evidence(series, parts = c(-1, 2, 3)))
  expect_error(integration_evidence(series, parts = c(1, 1, 3)))
  expect_error(integration_evidence(series, parts = c(1, 0, 0)))
})

test_that("integration_evidence on all possible partitions", {
  series <- matrix(c(1, 1, 0, 1, 0, 1), ncol = 2)
  expect <- c(-0.415037, 0.584963, 0.584963)
  eoi    <- integration_evidence(series)
  for (i in 1:3) {
    expect_equal(eoi$min[i], expect[i], tolerance = 1e-6)
    expect_equal(eoi$max[i], expect[i], tolerance = 1e-6)
  }

  series <- matrix(c(1, 1, 0, 1, 0, 0), ncol = 2)
  expect <- c(0.584963, -0.415037, 0.584963)
  eoi    <- integration_evidence(series)
  for (i in 1:3) {
    expect_equal(eoi$min[i], expect[i], tolerance = 1e-6)
    expect_equal(eoi$max[i], expect[i], tolerance = 1e-6)
  }

  series <- matrix(c(1, 1, 1, 1, 0, 0), ncol = 2)
  expect <- c(0, 0, 0)
  eoi    <- integration_evidence(series)
  for (i in 1:3) {
    expect_equal(eoi$min[i], expect[i], tolerance = 1e-6)
    expect_equal(eoi$max[i], expect[i], tolerance = 1e-6)
  }

  series <- matrix(c(1, 0, 0, 1, 0, 0), ncol = 2)
  expect <- c(1.584963, 0.584963, 0.584963)
  eoi    <- integration_evidence(series)
  for (i in 1:3) {
    expect_equal(eoi$min[i], expect[i], tolerance = 1e-6)
    expect_equal(eoi$max[i], expect[i], tolerance = 1e-6)
  }

  series <- matrix(c(1, 1, 0, 1, 0, 1, 0, 1, 1), ncol = 3)
  expect <- c(0.584963, 0.584963, 0.584963, 1.584963, 1.584963, 1.584963)
  eoi    <- integration_evidence(series)
  for (i in 1:3) {
    expect_equal(eoi$min[i], expect[i], tolerance = 1e-6)
    expect_equal(eoi$max[i], expect[i + 3], tolerance = 1e-6)
  }

  series <- matrix(c(1, 1, 0, 1, 1, 1, 0, 1, 1), ncol = 3)
  expect <- c(0.000000, -0.415037, 0.000000, 0.584963,  0.000000, 0.584963)
  eoi    <- integration_evidence(series)
  for (i in 1:3) {
    expect_equal(eoi$min[i], expect[i], tolerance = 1e-6)
    expect_equal(eoi$max[i], expect[i + 3], tolerance = 1e-6)
  }

  series <- matrix(c(1, 1, 0, 1, 0, 0, 0, 1, 1), ncol = 3)
  expect <- c(0.584963, -0.415037, 0.584963, 2.169925,  0.584963, 1.169925)
  eoi    <- integration_evidence(series)
  for (i in 1:3) {
    expect_equal(eoi$min[i], expect[i], tolerance = 1e-6)
    expect_equal(eoi$max[i], expect[i + 3], tolerance = 1e-6)
  }

  series <- matrix(c(1, 1, 0, 0, 1, 1, 0, 1, 1), ncol = 3)
  expect <- c(0.584963, -0.415037, 0.584963, 2.169925,  0.584963, 1.169925)
  eoi    <- integration_evidence(series)
  for (i in 1:3) {
    expect_equal(eoi$min[i], expect[i], tolerance = 1e-6)
    expect_equal(eoi$max[i], expect[i + 3], tolerance = 1e-6)
  }

  series <- matrix(c(0, 1, 1, 0, 1, 1, 0, 1, 1), ncol = 3)
  expect <- c(1.584963, 0.584963, 0.584963, 3.169925, 1.169925, 1.169925)
  eoi    <- integration_evidence(series)
  for (i in 1:3) {
    expect_equal(eoi$min[i], expect[i], tolerance = 1e-6)
    expect_equal(eoi$max[i], expect[i + 3], tolerance = 1e-6)
  }
})

test_that("integration_evidence on given partition", {
  series <- matrix(c(1, 1, 0, 1, 0, 1, 0, 1, 1), ncol = 3)
  parts  <- c(1, 2, 2)
  expect <- c(0.584963, 0.584963, 1.584963)
  eoi    <- integration_evidence(series, parts)
  for (i in 1:3) {
    expect_equal(eoi[i], expect[i], tolerance = 1e-6)
  }

  series <- matrix(c(1, 1, 0, 1, 0, 1, 0, 1, 1), ncol = 3)
  parts  <- c(2, 1, 2)
  expect <- c(0.584963, 1.584963, 0.584963)
  eoi    <- integration_evidence(series, parts)
  for (i in 1:3) {
    expect_equal(eoi[i], expect[i], tolerance = 1e-6)
  }

  series <- matrix(c(1, 1, 0, 1, 0, 1, 0, 1, 1), ncol = 3)
  parts  <- c(2, 2, 1)
  expect <- c(1.584963, 0.584963, 0.584963)
  eoi    <- integration_evidence(series, parts)
  for (i in 1:3) {
    expect_equal(eoi[i], expect[i], tolerance = 1e-6)
  }
})