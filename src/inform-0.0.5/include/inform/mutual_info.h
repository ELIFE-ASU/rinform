// Copyright 2016 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#pragma once

#include <inform/error.h>

#ifdef __cplusplus
extern "C"
{
#endif

/**
 * Compute the mutual information between two timeseries
 */
EXPORT double inform_mutual_info(int const *xs, int const *ys, size_t n,
    int bx, int by, double b, inform_error *err);

/**
 * Compute the local mutual information between two timeseries
 */
EXPORT double *inform_local_mutual_info(int const *xs, int const *ys, size_t n,
    int bx, int by, double b, double *mi, inform_error *err);

#ifdef __cplusplus
}
#endif
