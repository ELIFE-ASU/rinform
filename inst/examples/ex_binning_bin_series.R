# First method: bin into uniform bins
xs <- runif(20, 0, 5)
bin_series(xs, b = 5)

# Second method: bins of specific size <step>
bin_series(xs, step = 1)

# Third method: bins of specific size <step>
bounds <- c(2.0, 5.0)
bin_series(xs, bounds = bounds)

# These should give an error
bin_series(xs, b = 3, step = 1, bounds = bounds)
bin_series(xs, b = 3, step = 1)
bin_series(xs, b = 3, bounds = bounds)

bounds <- c(bounds, NA)
bin_series(xs, bounds = bounds)
