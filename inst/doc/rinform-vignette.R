## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ------------------------------------------------------------------------
# Create an empty distribution with support size 3
Dist(3)

# Create a distribution with 2 events, the first observed 5 times, the second
# observed 3 times
Dist(c(5, 3))

## ------------------------------------------------------------------------
# Create a distribution with size 2
d <- Dist(c(2, 13))
d

# Increase the size of the support to 5
d <- resize(d, 5)
d

# Decrease the size of the support to 3
d <- resize(d, 3)
d

## ------------------------------------------------------------------------
# Create base distribution
d <- Dist(c(1:5))
d

# Copy distribution
p <- copy(d)
p

## ------------------------------------------------------------------------
# Create a distribution ~ {3/5, 2/5}
dist <- infer(c(0, 0, 1, 0, 1))
dump(dist)

# Create a distribution ~ {3/8, 3/8, 2/8}
dist <- infer(c(0, 0, 1, 0, 1, 2, 2, 1))
dump(dist)

## ------------------------------------------------------------------------
# Approximate a distribution with tolerance 1e-3
probs <- c(0.5, 0.2, 0.3)
dist <- approximate(probs, 1e-3)
dist$histogram

probs <- c(1./3, 2./3)
dist <- approximate(probs, 1e-3)
dist$histogram

## ------------------------------------------------------------------------
# Uniform distribution of size 3
dist <- uniform(3)
dist

dump(dist)

## ------------------------------------------------------------------------
# NULL distribution
d <- NULL
length(d)

# Distribution with size 5
d <- Dist(5)
length(d)

## ------------------------------------------------------------------------
# Counts of valid distribution
dist <- Dist(c(5, 10))
counts(dist) == 15

dist <- set_item(dist, 2, 5)
counts(dist) == 10

## ------------------------------------------------------------------------
# Distribution with 0 observations
dist <- Dist(3)
valid(dist)

# Valid distribution
dist <- Dist(c(1:5))
valid(dist)

# Invalid distribution with 0 support
dist$size <- as.integer(0)
valid(dist)

## ------------------------------------------------------------------------
# Get item from a valid distribution
dist <- Dist(c(3, 2, 1, 0))
get_item(dist, 1) == 3
get_item(dist, 2) == 2
get_item(dist, 3) == 1
get_item(dist, 4) == 0

## ------------------------------------------------------------------------
# Initialize empty distribution
dist <- Dist(2)
dist

# Set item into a valid distribution
dist <- set_item(dist, 1, 3)
dist <- set_item(dist, 2, 8)
dist

## ------------------------------------------------------------------------
# Initial distribution
dist <- Dist(c(2, 4))

# Adding an observation for each event
dist <- tick(dist, 1)
get_item(dist, 1) == 3

dist <- tick(dist, 2)
get_item(dist, 2) == 5

## ------------------------------------------------------------------------
# Create a valid distribution
d <- Dist(c(1, 2, 3))
dump(d)

# Accumulate events
events <- c(0, 0, 1, 0, 1)
d <- accumulate(d, events)
dump(d)

# Accumulate invalid events
events <- c(0, 1, 1, 3, 1)
d <- accumulate(d, events)
dump(d)

## ------------------------------------------------------------------------
# Initialize distribution
dist <- Dist(c(2, 2, 4))

# Compute probabilities
probability(dist, 1) == 0.25
probability(dist, 2) == 0.25
probability(dist, 3) == 0.50

## ------------------------------------------------------------------------
# Initialize distribution and dump probabilities
dist <- Dist(c(2, 2, 4))
dump(dist)

# Modify and dump again
dist <- set_item(dist, 1, 12)
dump(dist)

## ------------------------------------------------------------------------
# One initial condition:
series <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
active_info(series, k = 2)

# ..and local variant:
lai <- active_info(series, k = 2, local = T)
t(lai)

# Two initial conditions:
series      <- matrix(nrow = 9, ncol = 2)
series[, 1] <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
series[, 2] <- c(1, 0, 0, 1, 0, 0, 1, 0, 0)
active_info(series, k = 2)

# ..and local variant:
lai <- active_info(series, k = 2, local = T)
t(lai)


## ------------------------------------------------------------------------
# One initial condition:
# k = 1
series <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
block_entropy(series, k = 1)

# k = 2
block_entropy(series, k = 2)

# ..and local variant:
# k = 1
be <- block_entropy(series, k = 1, local = T)
t(be)

# k = 2
be <- block_entropy(series, k = 2, local = T)
t(be)

# Two initial conditions:
series      <- matrix(nrow = 9, ncol = 2)
series[, 1] <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
series[, 2] <- c(1, 0, 0, 1, 0, 0, 1, 0, 0)
block_entropy(series, k = 2)

# ..and local variant:
be <- block_entropy(series, k = 2, local = T)
t(be)

## ------------------------------------------------------------------------
xs <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1)
ys <- c(0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1)

# Conditional entropy:
conditional_entropy(xs, ys)

conditional_entropy(ys, xs)

# ..and local variant:
ce <- conditional_entropy(xs, ys, local = T)
t(ce)

ce <- conditional_entropy(ys, xs, local = T)
t(ce)

## ------------------------------------------------------------------------
ps <- c(0, 1, 1, 0, 1, 0, 0, 1, 0, 0)
qs <- c(0, 0, 0, 0, 0, 1, 1, 0, 0, 1)

cross_entropy(ps, qs)

cross_entropy(qs, ps)

## ------------------------------------------------------------------------
# One initial condition:
series <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
entropy_rate(series, k = 2)

# ..and local variant:
er <- entropy_rate(series, k = 2, local = T)
t(er)

# Two initial conditions:
series      <- matrix(nrow = 9, ncol = 2)
series[, 1] <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
series[, 2] <- c(1, 0, 0, 1, 0, 0, 1, 0, 0)
entropy_rate(series, k = 2)

# ..and local variant:
er <- entropy_rate(series, k = 2, local = T)
t(er)

## ------------------------------------------------------------------------
# Two variables:
xs <- matrix(c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
               0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1), ncol = 2)

mutual_info(xs)

# ..and local variant:
mi <- mutual_info(xs, local = T)
t(mi)

# Three variables:
xs <- matrix(c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
               0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1,
               1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1), ncol = 3)

mutual_info(xs)

# ..and local variant:
mi <- mutual_info(xs, local = T)
t(mi)

## ------------------------------------------------------------------------
series <- c(0, 0, 1, 1, 0, 0, 1, 1, 0)
predictive_info(series, 1, 2)

# ..and local variant:
pi <- predictive_info(series, 1, 2, T)
t(pi)

## ------------------------------------------------------------------------
series      <- matrix(0, nrow = 9, ncol = 2)
series[, 1] <- c(0, 0, 1, 1, 0, 0, 1, 1, 0)
series[, 2] <- c(0, 1, 0, 1, 0, 1, 0, 1, 0)
predictive_info(series, 1, 2)

# ..and local variant:
pi <- predictive_info(series, 1, 2, T)
t(pi)

## ------------------------------------------------------------------------
xs <- c(0, 1, 0, 0, 0, 0, 0, 0, 0, 1)
ys <- c(0, 1, 1, 1, 1, 0, 0, 1, 0, 0)

# Average relative entropy:
relative_entropy(xs, ys)

relative_entropy(ys, xs)

# ..and local variant:
re <- relative_entropy(xs, ys, local = T)
t(re)

re <- relative_entropy(ys, xs, local = T)
t(re)

## ------------------------------------------------------------------------
# One initial condition, no background:
xs <- c(0, 1, 1, 1, 1, 0, 0, 0, 0)
ys <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
transfer_entropy(xs, ys, ws = NULL, k = 2)

# .. and local variant:
te <- transfer_entropy(xs, ys, ws = NULL, k = 2, local = T)
t(te)

# Two initial conditions, no background:
xs <- matrix(0, nrow = 9, ncol = 2)
xs[, 1] <- c(1, 0, 0, 0, 0, 1, 1, 1, 1)
xs[, 2] <- c(1, 1, 1, 1, 0, 0, 0, 1, 1)
ys <- matrix(0, nrow = 9, ncol = 2)
ys[, 1] <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
ys[, 2] <- c(1, 0, 0, 0, 0, 1, 1, 1, 0)
transfer_entropy(xs, ys, ws = NULL, k = 2)

# .. and local variant:
te <- transfer_entropy(xs, ys, ws = NULL, k = 2, local = T)
t(te)

# One initial condition, one background process:
xs <- c(0, 1, 1, 1, 1, 0, 0, 0, 0)
ys <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
ws <- array(c(0, 1, 1, 1, 1, 0, 1, 1, 1), dim = c(1, 9, 1))
transfer_entropy(xs, ys, ws, k = 2)

# .. and local variant:
te <- transfer_entropy(xs, ys, ws, k = 2, local = T)
t(te)

## ------------------------------------------------------------------------
# One initial condition, two background processes:
xs <- c(0, 1, 1, 1, 1, 0, 0, 0, 0)
ys <- c(0, 0, 1, 1, 1, 1, 0, 0, 0)
ws <- array(c(1, 0, 1, 0, 1, 1, 1, 1, 1,
              1, 1, 0, 1, 0, 1, 1, 1, 1), dim = c(2, 9, 1))
transfer_entropy(xs, ys, ws, k = 2)

# .. and local variant:
te <- transfer_entropy(xs, ys, ws, k = 2, local = T)
t(te)

## ------------------------------------------------------------------------
# Valid time series
xs <- c(0.2, 0.5, -3.2, 1.8, 0.6, 2.3)
series_range(xs)

## ------------------------------------------------------------------------
# First method: number of bins
series <- c(1, 2, 3, 4, 5, 6)
bin_series(series, b = 2)

# Second method: bin size
bin_series(series, step = 2.0)

# Third method: bin bounds
bin_series(series, bounds = c(3,7))

## ------------------------------------------------------------------------
coalesce(c(0, 2, 0, 2, 0, 2))

## ------------------------------------------------------------------------
coalesce(c(-8, 2, 6, -2, 4))

## ------------------------------------------------------------------------
encode(c(0, 0, 1), b = 2)
encode(c(0, 1, 0), b = 3)
encode(c(1, 0, 0), b = 4)
encode(c(1, 0, 4), b = 5)

## ------------------------------------------------------------------------
encode(c(0, 0, 2), NA)
encode(c(0, 2, 0))
encode(c(1, 2, 1))

## ------------------------------------------------------------------------
decode(2, b = 2, n = 2)
# array([1, 0], dtype=int32)
decode(6, b = 2, n = 3)
#array([1, 1, 0], dtype=int32)
decode(6, b = 3, n = 2)
#array([2, 0], dtype=int32)

## ------------------------------------------------------------------------
decode(2, b = 2, n = 4)

## ------------------------------------------------------------------------
decode(1, b = 2)
decode(1, b = 3)
decode(3, b = 2)
decode(3, b = 3)
decode(3, b = 4)

