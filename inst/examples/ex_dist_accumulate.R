# Accumulate observations to a distribution from collected events
d  <- Dist(c(5, 5))
dump(d)

xs <- sample(0:1, 10, TRUE)
d  <- accumulate(d, xs)
dump(d)

xs      <- matrix(0, 10, 3)
xs[, 1] <- sample(0:1, 10, TRUE)
xs[, 2] <- sample(2:3, 10, TRUE)
xs[, 3] <- sample(0:2, 10, TRUE)
d  <- accumulate(d, xs)
dump(d)
