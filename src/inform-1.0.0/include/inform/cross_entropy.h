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
 * Compute the cross entropy between two timeseries, each considered as
 * a timeseries of samples from two distributions.
 *
 * @param[in] ps      the "true" time series
 * @param[in] qs      the "unnatural" time series
 * @param[in] n       the length of the time series
 * @param[in] b       the base of the time series
 * @param[in,out] err the error structure
 * @return the cross entropy between the time series
 */
EXPORT double inform_cross_entropy(int const *ps, int const *qs, size_t n,
    int b, inform_error *err);

#ifdef __cplusplus
}
#endif
