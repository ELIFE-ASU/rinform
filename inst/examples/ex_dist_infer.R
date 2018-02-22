# Infer distributions from collected events
xs <- sample(0:1, 10, T)
d  <- infer(xs)
dump(d)

xs      <- matrix(0, 10, 3)
xs[, 1] <- sample(0:1, 10, T)
xs[, 2] <- sample(2:3, 10, T)
xs[, 3] <- sample(0:2, 10, T)
d  <- infer(xs)
dump(d)
