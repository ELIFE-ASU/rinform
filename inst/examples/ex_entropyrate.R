# The typical usage is to provide the time series and the history length. 
xs <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
entropy_rate(xs, k = 2) #0.6792696
# [1] 1.0, 0.0, 0.5849625, 0.5849625, 1.5849625, 0.0, 1.0
entropy_rate(xs, k = 2, local = TRUE)

# Multiple Initial Conditions
xs      <- matrix(0, nrow = 9, ncol = 2)
xs[, 1] <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
xs[, 2] <- c(1, 0, 0, 1, 0, 0, 1, 0, 0)
entropy_rate(xs, k = 2)         # 0.6253491

# [, 1] 0.4150375, 1.5849625, 0.5849625, 0.5849625, 1.5849625, 0.0, 2.0
# [, 2] 0.0, 0.4150375, 0.5849625, 0.0, 0.4150375, 0.5849625, 0.0
entropy_rate(xs, k = 2, local = TRUE)
