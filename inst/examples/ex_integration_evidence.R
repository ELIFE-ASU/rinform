# Evidence of Integration of three time series:
series      <- matrix(0, nrow = 10, ncol = 3)
series[, 1] <- c(0, 1, 0, 1, 1, 1, 0, 0, 1, 0)
series[, 2] <- c(0, 1, 0, 1, 1, 1, 0, 0, 1, 0)
series[, 3] <- c(1, 1, 1, 1, 1, 0, 0, 0, 0, 0)
# min        = c(-0.322 0.263 -0.322 0.263 0.263 -0.322 0.263 0.263 -0.322 0.263)
# max        = c( 1.000 1.263  1.000 1.263 1.263  1.000 1.263 1.263  1.000 1.263)
# integrated = c( FALSE  TRUE  FALSE  TRUE  TRUE  FALSE  TRUE  TRUE  FALSE  TRUE)
integration_evidence(series)

# Evidence of Integration of three time series for the partitionning c(1, 1, 2)
parts <- c(1, 1, 2)
# -0.322 0.263 -0.322 0.263 0.263 -0.322 0.263 0.263 -0.322 0.263
integration_evidence(series, parts)
