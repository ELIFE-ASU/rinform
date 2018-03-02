d <- Dist(c(0, 1, 2, 3, 4, 5))
for (i in 1:length(d))
  cat("event", i, "probability", probability(d, i), "\n")
