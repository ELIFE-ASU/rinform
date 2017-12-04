ps <- c(0, 1, 1, 0, 1, 0, 0, 1, 0, 0)
qs <- c(0, 0, 0, 0, 0, 1, 1, 0, 0, 1)
cross_entropy(ps, qs)      # 1.003530
cross_entropy(qs, ps)      # 0.912454
