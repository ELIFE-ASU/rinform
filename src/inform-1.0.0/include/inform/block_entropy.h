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
 * Compute the block entropy of an ensemble of time series
 *
 * @param[in] series the ensemble of time series
 * @param[in] n      the number of initial conditions
 * @param[in] m      the number of time steps in each time series
 * @param[in] b      the base or number of distinct states at each time step
 * @param[in] k      the history length used to calculate the active information
 * @param[out] err   an error structure
 * @return the block entropy for the ensemble
 */
EXPORT double inform_block_entropy(int const *series, size_t n, size_t m, int b,
    size_t k, inform_error *err);

/**
 * Compute the local block entropy of a ensemble of time series
 *
 * @param[in] series the ensemble of time series
 * @param[in] n      the number of initial conditions
 * @param[in] m      the number of time steps in each time series
 * @param[in] b      the base or number of distinct states at each time step
 * @param[in] k      the history length used to calculate the active information
 * @param[out] ent   the local entropy
 * @param[out] err   an error structure
 * @return a pointer to the local block entropy array
 */
EXPORT double *inform_local_block_entropy(int const *series, size_t n, size_t m,
    int b, size_t k, double *ent, inform_error *err);

#ifdef __cplusplus
}
#endif
