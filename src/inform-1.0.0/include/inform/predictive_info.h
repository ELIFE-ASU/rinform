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
 * Compute predictive information of an ensemble of time series
 *
 * @param[in] series  the ensemble of time series
 * @param[in] n       the number of initial conditions
 * @param[in] m       the number of time steps in each time series
 * @param[in] b       the base or number of distinct states at each time step
 * @param[in] kpast   the history length
 * @param[in] kfuture the future length
 * @param[out] err    an error structure
 * @return the predictive information for the ensemble
 */
EXPORT double inform_predictive_info(int const *series, size_t n, size_t m,
    int b, size_t kpast, size_t kfuture, inform_error *err);

/**
 * Compute the local predictive information of a ensemble of time series
 *
 * @param[in] series  the ensemble of time series
 * @param[in] n       the number of initial conditions
 * @param[in] m       the number of time steps in each time series
 * @param[in] b       the base or number of distinct states at each time step
 * @param[in] kpast   the history length
 * @param[in] kfuture the future length
 * @param[out] pi     the local predictive information
 * @param[out] err    an error structure
 * @return a pointer to the local predictive information array
 */
EXPORT double *inform_local_predictive_info(int const *series, size_t n,
    size_t m, int b, size_t kpast, size_t kfuture, double *pi,
    inform_error *err);

#ifdef __cplusplus
}
#endif
