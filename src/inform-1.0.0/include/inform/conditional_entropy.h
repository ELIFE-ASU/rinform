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
 * Compute the conditional entropy between two timeseries, using the
 * first as the condition.
 */
EXPORT double inform_conditional_entropy(int const *xs, int const *ys,
    size_t n, int bx, int by, inform_error *err);

/**
 * Compute the local conditional entropy between two timeseries, using the
 * first as the condition.
 */
EXPORT double *inform_local_conditional_entropy(int const *xs, int const *ys,
    size_t n, int bx, int by, double *mi, inform_error *err);

#ifdef __cplusplus
}
#endif
