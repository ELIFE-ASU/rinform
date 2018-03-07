# Information flow across four time series:
ws <- c(0, 0, 1, 0, 1, 1, 0, 1)
xs <- c(0, 0, 1, 0, 1, 1, 0, 1)
ys <- c(0, 0, 1, 0, 1, 1, 0, 1)
zs <- c(0, 0, 0, 0, 0, 0, 0, 0)

info_flow(src = xs, dst = ys, lsrc = 1, ldst = 1)                            # flow ~ 1.0
info_flow(src = xs, dst = ys, back = ws, lsrc = 1, ldst = 1, lback = 1)      # flow ~ 0.0
info_flow(src = ws, dst = zs, back = ys, lsrc = 1, ldst = 1, lback = 1)      # flow ~ 0.0

# Now let's intervene on ys and zs
ws <- c(0, 0, 1, 0, 1, 1, 0, 1)
xs <- c(0, 0, 1, 0, 1, 1, 0, 1)
ys <- c(1, 0, 1, 0, 0, 1, 1, 0)
zs <- c(1, 0, 0, 0, 1, 0, 1, 1)
info_flow(src = xs, dst = ys, lsrc = 1, ldst = 1)                            # flow ~ 0.0
info_flow(src = xs, dst = ys, back = ws, lsrc = 1, ldst = 1, lback = 1)      # flow ~ 0.0
info_flow(src = ws, dst = zs, back = ys, lsrc = 1, ldst = 1, lback = 1)      # flow ~ 1.0
