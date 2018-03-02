# TPM from 2 base-2 time series
xs      <- matrix(0, nrow = 5, ncol = 2)
xs[, 1] <- c(0, 0, 1, 1, 0)
xs[, 2] <- c(1, 0, 1, 1, 1)
series_to_tpm(xs)

# TPM from one base-3 time series
xs <- c(0, 1, 2, 2, 1, 1, 0, 0, 1, 2)
series_to_tpm(xs)
