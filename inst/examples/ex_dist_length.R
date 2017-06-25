length(Dist(5))
length(Dist(c(0,2,3)))

# Let's corrupt the Dist object
d      <- Dist(10)
d$size <- 2
length(d)
