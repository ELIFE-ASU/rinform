xyz <- Dist(c(24, 24, 9, 6, 25, 15, 10, 5))
xz  <- Dist(c(15, 9, 5, 10))
yz  <- Dist(c(9, 15, 10, 15))
z   <- Dist(c(3, 5))
shannon_cond_mutual_info(xyz, xz, yz, z)           # 0.1259494
shannon_cond_mutual_info(xyz, xz, yz, z, b = 3)    # 0.0794652

