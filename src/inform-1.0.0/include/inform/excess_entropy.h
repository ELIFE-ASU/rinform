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
 * Compute excess entropy of an ensemble of time series
 *
 * @param[in] series the ensemble of time series
 * @param[in] n      the number of initial conditions
 * @param[in] m      the number of time steps in each time series
 * @param[in] b      the base or number of distinct states at each time step
 * @param[in] k      the history length
 * @param[out] err   an error structure
 * @return the excess entropy for the ensemble
 */
EXPORT double inform_excess_entropy(int const *series, size_t n, size_t m,
    int b, size_t k, inform_error *err);

/**
 * Compute the local excess entropy of a ensemble of time series
 *
 * @param[in] series the ensemble of time series
 * @param[in] n      the number of initial conditions
 * @param[in] m      the number of time steps in each time series
 * @param[in] b      the base or number of distinct states at each time step
 * @param[in] k      the history length
 * @param[out] ee    the local excess entropy
 * @param[out] err   an error structure
 * @return a pointer to the local excess entropy array
 */
EXPORT double *inform_local_excess_entropy(int const *series, size_t n,
    size_t m, int b, size_t k, double *ee, inform_error *err);

#ifdef __cplusplus
}
#endif
