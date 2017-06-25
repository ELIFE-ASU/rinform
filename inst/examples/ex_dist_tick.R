d <- Dist(5)
d <- tick(d, 1)
d <- tick(d, 1)
d <- tick(d, 3)
d # [2, 0, 1, 0]

# These produce an out of bounds error
d <- tick(d, 0)
d <- tick(d, 6)
