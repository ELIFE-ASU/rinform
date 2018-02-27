# Compute effective information on a 3 by 3 tpm with uniform interventionn
tpm      <- matrix(0, nrow = 3, ncol = 3)
tpm[, 1] <- c(1.0 / 3, 1.0 / 3, 1.0 / 3)
tpm[, 2] <- c(0.250, 0.750, 0.000)
tpm[, 3] <- c(0.125, 0.500, 0.375)
inter    <- c(0.300, 0.250, 0.450)
effective_info(tpm, NULL)        # 0.202701

# .. and with a non-uniform intervention
inter    <- c(0.300, 0.250, 0.450)
effective_info(tpm, inter)       # 0.1724976
