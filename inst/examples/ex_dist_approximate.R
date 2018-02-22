# Approximate distributions with different tolerance
p <- c(0.12345, 0.23456, 1.0 - 0.12345 - 0.23456)
d <- approximate(p, tol = 0.1)
dump(d)

d <- approximate(p, tol = 0.001)
dump(d)

d <- approximate(p, tol = 0.00001)
dump(d)

