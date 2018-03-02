# Single initial conditions
xs <- c(0, 0, 1, 1, 0, 0, 1, 1, 0)
excess_entropy(xs, k = 2) # 1.918296

# [1.585 1.585 2.585 2.585 1.585 1.585]
excess_entropy(xs, k = 2, local = TRUE)

# Multiple initial conditions
xs      <- matrix(0, nrow = 9, ncol = 2)
xs[, 1] <- c(0, 0, 1, 1, 0, 0, 1, 1, 0)
xs[, 2] <- c(0, 1, 0, 1, 0, 1, 0, 1, 0)
excess_entropy(xs, k = 2) # 1.109170

# [, 1] 2.585 -0.059 3.585 -0.415 2.585 -0.059
# [, 2] 0.848  0.848 0.848  0.848 0.848  0.848
excess_entropy(xs, k = 2, local = TRUE)

