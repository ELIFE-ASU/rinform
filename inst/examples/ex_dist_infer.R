# Infer distributions from collected events
xs <- sample(0:1, 10, TRUE)
d  <- infer(xs)
dump(d)

xs      <- matrix(0, 10, 3)
xs[, 1] <- sample(0:1, 10, TRUE)
xs[, 2] <- sample(2:3, 10, TRUE)
xs[, 3] <- sample(0:2, 10, TRUE)
d  <- infer(xs)
dump(d)
