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


## ---- fig.show='hold'----------------------------------------------------
plot(1:10)
plot(10:1)

## ---- echo=FALSE, results='asis'-----------------------------------------
knitr::kable(head(mtcars, 10))

