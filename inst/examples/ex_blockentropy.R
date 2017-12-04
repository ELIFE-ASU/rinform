# The typical usage is to provide the time series and the history length. 
xs <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
block_entropy(xs, k = 1) # 0.9910761
# [ 0.8479969, 0.8479969, 1.169925, 1.169925,  1.169925, 1.169925, 0.8479969,
#   0.8479969, 0.8479969]
block_entropy(xs, k = 1, local = TRUE)
block_entropy(xs, k = 2) # 1.811278
# [ 1.415037, 3.0, 1.415037, 1.415037, 1.415037, 3.0, 1.415037, 1.415037]
block_entropy(xs, k = 2, local = TRUE)

# Multiple Initial Conditions
xs      <- matrix(0, nrow = 9, ncol = 2)
xs[, 1] <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
xs[, 2] <- c(1, 0, 0, 1, 0, 0, 1, 0, 0)
block_entropy(xs, k = 2) # 1.936278
# [, 1] 1.415037, 2.415037, 2.415037, 2.415037, 2.415037, 2.0, 1.415037, 1.415037
# [, 2] 2.0 , 1.415037, 2.415037, 2.0, 1.415037, 2.415037, 2.0, 1.415037
block_entropy(xs, k = 2, local = TRUE)

