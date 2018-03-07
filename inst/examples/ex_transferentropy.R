######################################################################
# The typical usage is to provide the time series and the history length. 
xs <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
ys <- c(0, 1, 1, 1, 1, 0, 0, 0, 1)
transfer_entropy(ys, xs, k = 1)       # 0.8112781
transfer_entropy(ys, xs, k = 2)       # 0.6792696
transfer_entropy(xs, ys, k = 1)       # 0.2169172
transfer_entropy(xs, ys, k = 2)       # 0

# [1] 0.4150375, 2.0, 0.4150375, 0.4150375, 0.4150375, 2.0, 0.4150375,
#     0.4150375
transfer_entropy(ys, xs, k = 1, local = TRUE)

# [1] 1.0, 0.0, 0.5849625, 0.5849625, 1.5849625, 0.0, 1.0
transfer_entropy(ys, xs, k = 2, local = TRUE)

# [1] 0.4150375, 0.4150375, -0.169925, -0.169925, 0.4150375, 1.0,
#     -0.5849625, 0.4150375
transfer_entropy(xs, ys, k = 1, local = TRUE)

# [1] 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
transfer_entropy(xs, ys, k = 2, local = TRUE)

# Multiple Initial Conditions
xs      <- matrix(0, nrow = 9, ncol = 2)
xs[, 1] <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
xs[, 2] <- c(1, 0, 0, 0, 0, 1, 1, 1, 0)
ys      <- matrix(0, nrow = 9, ncol = 2)
ys[, 1] <- c(1, 0, 0, 0, 0, 1, 1, 1, 1)
ys[, 2] <- c(1, 1, 1, 1, 0, 0, 0, 1, 1)
transfer_entropy(ys, xs, k = 1)       # 0.8828561
transfer_entropy(ys, xs, k = 2)       # 0.6935361
transfer_entropy(xs, ys, k = 1)       # 0.1596973
transfer_entropy(xs, ys, k = 2)       # 0.0
  
# [, 1] 0.4150375, 2.0, 0.67807191, 0.67807191, 0.67807191, 1.4150375,
#       0.4150375, 0.4150375
# [, 2] 1.4150375, 0.4150375, 0.4150375, 0.4150375, 2.0, 0.67807191,
#       0.67807191, 1.4150375
transfer_entropy(ys, xs, k = 1, local = TRUE)

# [, 1] 1.32192809, 0.0, 0.73696559, 0.73696559, 1.32192809, 0.0,
#       0.73696559
# [, 2] 0.0, 0.73696559, 0.73696559, 1.32192809, 0.0, 0.73696559,
#       1.32192809
transfer_entropy(ys, xs, k = 2, local = TRUE)

# [, 1] 0.5849625, 0.48542683, -0.25153877, -0.25153877, 0.48542683,
#       0.36257008, -0.22239242, -0.22239242
# [, 2] 0.36257008, -0.22239242, -0.22239242, 0.5849625, 0.48542683,
#       -0.25153877, 0.48542683, 0.36257008
transfer_entropy(xs, ys, k = 1, local = TRUE)

# [, 1] 0.000000e+00, -2.220446e-16, -2.220446e-16, -2.220446e-16,
#       0.000000e+00, -2.220446e-16, -2.220446e-16
# [, 2] -2.220446e-16, -2.220446e-16, -2.220446e-16, 0.000000e+00,
#       -2.220446e-16, -2.220446e-16, 0.000000e+00
transfer_entropy(xs, ys, k = 2, local = TRUE)

# With a background process
xs <- c(0, 1, 1, 1, 1, 0, 0, 0, 0)
ys <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
ws <- matrix(c(1, 0, 1, 0, 1, 1, 1, 1, 1,
               1, 1, 0, 1, 0, 1, 1, 1, 1), ncol = 2)
transfer_entropy(xs, ys, ws, k = 2) # 0

# [, 1] 0, 0, 0, 0, 0, 0, 0, 0, 0 
te <- transfer_entropy(xs, ys, ws, k = 2, local = TRUE)
t(te)
