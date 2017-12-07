## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

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

