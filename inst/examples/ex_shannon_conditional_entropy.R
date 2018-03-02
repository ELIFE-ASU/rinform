xy <- Dist(c(10, 70, 15, 5))
x  <- Dist(c(80, 20))
y  <- Dist(c(25, 75))
shannon_conditional_entropy(xy, x)              # 0.5971072
shannon_conditional_entropy(xy, y)              # 0.5077571
shannon_conditional_entropy(xy, x, b = 3)       # 0.3767327
shannon_conditional_entropy(xy, y, b = 3)       # 0.3203591


