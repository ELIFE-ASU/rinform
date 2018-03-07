# Black-box 4 time series in the same partition (1st) 
xs      <- matrix(0, nrow = 8, ncol = 4)
xs[, 1] <- c(0, 1, 1, 0, 1, 0, 0, 1)
xs[, 2] <- c(1, 0, 0, 1, 1, 0, 1, 0)
xs[, 3] <- c(0, 0, 0, 1, 1, 1, 0, 0)
xs[, 4] <- c(1, 0, 1, 0, 1, 1, 1, 0)
parts   <- c(1, 1, 1, 1)
black_box_parts(xs, parts)           # box = c(5 8 9 6 15 3 5 8), b = c(16)

# Black-box 4 time series with histories and futures:
# box[, 1] = c(1 2 3 0 3 1 1 2), the time series for the 1st partition
# box[, 1] = c(2 0 0 3 3 1 2 0), the time series for the 2st partition
# b = c(4, 4)
parts   <- c(1, 2, 2, 1)
black_box_parts(xs, parts)
