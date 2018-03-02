xy <- Dist(c(10, 70, 15, 5))
x  <- Dist(c(80, 20))
y  <- Dist(c(25, 75))
shannon_mutual_info(xy, x, y)           # 0.2141709
shannon_mutual_info(xy, x, y, b = 3)    # 0.1351268
shannon_mutual_info(xy, x, y, b = 0)    # 0

