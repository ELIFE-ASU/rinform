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
 * Compute the entropy rate of an ensemble of time series
 *
 * @param[in] series the ensemble of time series
 * @param[in] n      the number of initial conditions
 * @param[in] m      the number of time steps in each time series
 * @param[in] b      the base or number of distinct states at each time step
 * @param[in] k      the history length used to calculate the entropy rate
 * @param[out] err   an error structure
 * @return the entropy rate for the ensemble
 */
EXPORT double inform_entropy_rate(int const *series, size_t n, size_t m, int b,
    size_t k, inform_error *err);

/**
 * Compute the local entropy rate of an ensemble of time series
 *
 * @param[in] series the ensemble of time series
 * @param[in] n      the number of initial conditions
 * @param[in] m      the number of time steps in each time series
 * @param[in] b      the base or number of distinct states at each time step
 * @param[in] k      the history length used to calculate the entropy rate
 * @param[out] er    the local entropy rate of the ensemble
 * @param[out] err   an error structures
 * @return a pointer to the local entropy rate array
 */
EXPORT double *inform_local_entropy_rate(int const *series, size_t n, size_t m, int b,
    size_t k, double *er, inform_error *err);

#ifdef __cplusplus
}
#endif
