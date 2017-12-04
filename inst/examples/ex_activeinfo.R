# The typical usage is to provide the time series and the history length. 
xs <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
active_info(xs, k = 2) # 0.3059585
# [-0.1926451,  0.8073549,  0.2223924,  0.2223924, -0.3625701, 1.222392,
#  0.2223924]
active_info(xs, k = 2, local = TRUE)

# Multiple Initial Conditions
xs      <- matrix(0, nrow = 9, ncol = 2)
xs[, 1] <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
xs[, 2] <- c(1, 0, 0, 1, 0, 0, 1, 0, 0)
active_info(xs, k = 2) # 0.359879
# [, 1] 0.8073549, -0.3625701,  0.6374299,  0.6374299, -0.7776076, 0.8073549,
#      -1.192645
# [, 2] 0.8073549,  0.8073549,  0.2223924,  0.8073549,  0.8073549, 0.2223924,
#      0.8073549
active_info(xs, k = 2, local = TRUE)

