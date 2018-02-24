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
 * Compute the mutual information between time series
 *
 * @param[in] series the time series
 * @param[in] l      the number of time series
 * @param[in] n      the number of elements per time series
 * @param[in] b      the base of each time series
 * @param[in] err    an error code
 * @return the mutual information between the time series
 */
EXPORT double inform_mutual_info(int const *series, size_t l, size_t n,
    int const *b, inform_error *err);

/**
 * Compute the pointwise mutual information between time series
 *
 * @param[in] series the time series
 * @param[in] l      the number of time series
 * @param[in] n      the number of elements per time series
 * @param[in] b      the base of each time series
 * @param[out] mi    the pointwise mutual information
 * @param[in] err    an error code
 * @return the pointwise mutual information between the time series
 */
EXPORT double *inform_local_mutual_info(int const *series, size_t l, size_t n,
    int const *b, double *mi, inform_error *err);

#ifdef __cplusplus
}
#endif
