p <- Dist(c(1, 0, 0))
q <- Dist(c(2, 1, 1))
shannon_cross_entropy(p, q)               # 1.0000000
shannon_cross_entropy(q, p)               # Inf
shannon_cross_entropy(p, q, b = 3)        # 0.6309298
shannon_cross_entropy(q, p, b = 3)        # Inf


