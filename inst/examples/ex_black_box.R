# Black-box two time series with no history or futures
xs      <- matrix(0, nrow = 8, ncol = 2)
xs[, 1] <- c(0, 1, 1, 0, 1, 0, 0, 1)
xs[, 2] <- c(1, 0, 0, 1, 1, 0, 1, 0)
black_box(xs, l = 2)                                   # c(1 2 2 1 3 0 1 2)

# Black-box two time series with histories and futures:
black_box(xs, l = 2, r = c(2, 1), s = c(0, 1))         # c(4 13 11 6 9 2)

# Black-box a single time series in time with history length 2
xs <- c(0, 1, 1, 0, 1, 0, 0, 1)
black_box(xs, l = 1, r = 2)                            # c(1 3 2 1 2 0 1)
