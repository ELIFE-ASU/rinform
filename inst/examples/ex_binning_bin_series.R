# First method: bin into uniform bins
xs <- runif(20, 0, 5)
bin_series(xs, b = 5)

# Second method: bins of specific size <step>
bin_series(xs, step = 1)

# Third method: bins of specific size <step>
bounds <- c(2.0, 5.0)
bin_series(xs, bounds = bounds)

