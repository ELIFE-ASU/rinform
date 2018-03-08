# One initial condition and one source:
dest <- c(0, 1, 1, 1, 1, 0, 0, 0, 0)
srcs <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
separable_info(srcs, dest, k = 2)      # si ~ 0.591673

# ..and local variant:
si <- separable_info(srcs, dest, k = 2, local = TRUE)
#    si ~ { 1.222 0.637 0.637 -0.778 0.807 0.807 0.807 }
t(si)

# One initial condition and multiple sources:
dest      <- c(0, 1, 1, 1, 1, 0, 0, 0, 0)
srcs      <- matrix(0, nrow = 9, ncol = 2)
srcs[, 1] <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
srcs[, 2] <- c(1, 1, 1, 1, 0, 0, 0, 0, 0)
separable_info(srcs, dest, k = 2)      # si ~ 0.985228

# ..and local variant:
si <- separable_info(srcs, dest, k = 2, local = TRUE)
#     si ~ { 1.222 1.222 1.222 0.807 0.807 0.807 0.807 }
t(si)

# Multiple initial conditions and multiple sources:
dest      <- matrix(0, nrow = 9, ncol = 2)
dest[, 1] <- c(0, 1, 1, 1, 1, 0, 0, 0, 0)
dest[, 2] <- c(1, 1, 0, 1, 1, 0, 1, 1, 0)
srcs      <- matrix(0, nrow = 9, ncol = 4)
srcs[, 1] <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
srcs[, 2] <- c(1, 1, 1, 1, 1, 0, 1, 1, 0)
srcs[, 3] <- c(1, 1, 1, 1, 0, 0, 0, 0, 0)
srcs[, 4] <- c(0, 0, 0, 0, 1, 1, 1, 1, 0)
separable_info(srcs, dest, k = 2)      # si ~ 0.625349

# ..and local variant:
si <- separable_info(srcs, dest, k = 2, local = TRUE)
# si ~ { 1.000 -0.000 -0.000  1.000 0.585 1.000  1.000 
#        1.000 -0.415  1.000 -0.000 1.585 1.000 -0.000 }
t(si)
