# One initial condition
xs <- c(0, 0, 1, 1, 0, 0, 1, 1, 0)
predictive_info(xs, kpast = 1, kfuture = 2) # 0.985228

# [0.807, 0.807, 1.222, 1.222, 0.807, 0.807, 1.222]
predictive_info(xs, kpast = 1, kfuture = 2, local = TRUE)

# Multiple initial conditions
xs      <- matrix(0, nrow = 9, ncol = 2)
xs[, 1] <- c(0, 0, 1, 1, 0, 0, 1, 1, 0)
xs[, 2] <- c(0, 1, 0, 1, 0, 1, 0, 1, 0)
predictive_info(xs, kpast = 1, kfuture = 2) # 0.244905

# [, 1] -0.515 0.807 -0.363 1.222 -0.515 0.807 -0.363
# [, 2] 0.222 0.485  0.222 0.485  0.222 0.485  0.222
predictive_info(xs, kpast = 1, kfuture = 2, local = TRUE)

