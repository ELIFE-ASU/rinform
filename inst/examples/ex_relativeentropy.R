xs <- c(0, 1, 0, 0, 0, 0, 0, 0, 0, 1)
ys <- c(0, 1, 1, 1, 1, 0, 0, 1, 0, 0)
relative_entropy(xs, ys)       # 0.2780719
relative_entropy(ys, xs)       # 0.3219281

# [1]  0.6780719 -1.3219281
relative_entropy(xs, ys, local = TRUE)

xs <- c(0, 0, 0, 0)
ys <- c(0, 1, 1, 0)
relative_entropy(xs, ys)       # 1.0
relative_entropy(ys, xs)       # NaN
