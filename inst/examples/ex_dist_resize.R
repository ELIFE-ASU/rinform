# Resizing invalid distribution
d <- Dist(5)
d <- resize(d, 3)
length(d) # 3

d <- resize(d, 8)
length(d) # 8

# Resizing valid distribution
d <- Dist(c(1, 2, 3, 4))
d <- resize(d, 2) # list(c(1, 2), 2, 3)
d
d <- resize(d, 4) # list(c(1, 2, 0, 0), 4, 3)
d
