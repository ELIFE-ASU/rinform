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
 * Compute the range of a continuously-valued timeseries.
 *
 * @param[in] series the timeseries
 * @param[in] n      the length of the timeseries
 * @param[out] min   the minimum value in the timeseries
 * @param[out] max   the maximum value in the timeseries
 * @param[out] err   the error code
 * @return the range of the timeseries `max - min`
 */
EXPORT double inform_range(double const *series, size_t n, double *min,
    double *max, inform_error *err);

/**
 * Bin a continuously-valued timeseries into `b` uniform bins.
 *
 * @param[in] series  the timeseries
 * @param[in] n       the length of the timeseries
 * @param[in] b       the desired number of bins
 * @param[out] binned the resulting binned timeseries
 * @param[out] err    the error code
 * @return the size of each bin
 */
EXPORT double inform_bin(double const *series, size_t n, int b, int *binned,
    inform_error *err);

/**
 * Bin a continuously-valued timeseries into bins of uniform size `step`.
 *
 * @param[in] series  the timeseries
 * @param[in] n       the length of the timeseries
 * @param[in] step    the desired size of each bin
 * @param[out] binned the resulting binned timeseries
 * @param[out] err    the error code
 * @return the number of bins
 */
EXPORT int inform_bin_step(double const *series, size_t n, double step,
    int *binned, inform_error *err);

/**
 * Bin a continuously-valued timeseries into bins with specified boundaries.
 *
 * @param[in] series  the timeseries
 * @param[in] n       the length of the timeseries
 * @param[in] bounds  desired bin boundaries
 * @param[in] m       the number of specified bin boundaries
 * @param[out] binned the resulting binned timeseries
 * @param[out] err    the error code
 * @return the number of bins
 */
EXPORT int inform_bin_bounds(double const *series, size_t n,
    double const *bounds, size_t m, int *binned, inform_error *err);

#ifdef __cplusplus
}
#endif
