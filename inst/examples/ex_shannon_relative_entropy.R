p <- Dist(c(4, 1))
q <- Dist(c(1, 1))
shannon_relative_entropy(p, q)          # 0.2780719
shannon_relative_entropy(q, p)          # 0.3219281
shannon_relative_entropy(p, q, b = 3)   # 0.1754438
shannon_relative_entropy(q, p, b = 3)   # 0.2031140

p <- Dist(c(1, 0))
q <- Dist(c(1, 1))
shannon_relative_entropy(p, q)          # 1.0
shannon_relative_entropy(q, p)          # NaN
shannon_relative_entropy(p, q, b = 3)   # 0.6309298
shannon_relative_entropy(q, p, b = 3)   # NaN

