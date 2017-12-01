// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#pragma once

#include <inform/error.h>

#ifdef __cplusplus
extern "C"
{
#endif

/**
 * Compute the a transition probability matrix from a time series.
 *
 * The function allocates a tpm of the proper size if the *tpm* argument is
 * `NULL`.
 *
 * @param[in] series  the timeseries
 * @param[in] n       the number of initial conditions
 * @param[in] m       the number of time steps for each initial condition
 * @param[in] b       the base of the time series
 * @param[in,out] tpm the transition probability matrix (or NULL)
 * @param[out] err    an error code
 * @return the transition probability matrix
 */
EXPORT double *inform_tpm(int const *series, size_t n, size_t m, int b,
    double *tpm, inform_error *err);

#ifdef __cplusplus
}
#endif
