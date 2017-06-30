d <- Dist(c(1, 1, 1, 1))
shannon_entropy(d)          # 2.0
shannon_entropy(d, 4)       # 1.0

d <- Dist(c(2, 1))
shannon_entropy(d)          # 0.9182958
shannon_entropy(d, b = 3)   # 0.5793802
