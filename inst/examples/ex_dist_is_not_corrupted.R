d <- Dist(5)
is_not_corrupted(d)

# Let's corrupt the Dist object
d$size <- 2
is_not_corrupted(d)

