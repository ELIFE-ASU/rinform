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
 * Compute the relative entropy between two timeseries, each considered as
 * a timeseries of samples from two distributions.
 */
EXPORT double inform_relative_entropy(int const *xs, int const *ys, size_t n,
    int b, inform_error *err);

/**
 * Compute the pointwise relative entropy between two timeseries, each
 * considered as a timeseries of samples from two distributions.
 */
EXPORT double *inform_local_relative_entropy(int const *xs, int const *ys,
    size_t n, int b, double *re, inform_error *err);

#ifdef __cplusplus
}
#endif
