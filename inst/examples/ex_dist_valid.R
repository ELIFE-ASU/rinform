d <- Dist(5)
valid(d) # FALSE, support is empty

d <- Dist(c(0, 1, 0))
valid(d) # TRUE, at least one observation is made
