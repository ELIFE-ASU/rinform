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
 * Coalesce a timeseries into as few states contiguous states as possible.
 *
 * @param[in] series  the timeseries
 * @param[in] n       the length of the timeseries
 * @param[out] coal   the resulting coalesced timeseries
 * @param[out] err    the error code
 * @return the number of unique states
 */
EXPORT int inform_coalesce(int const *series, size_t n, int *coal,
    inform_error *err);

#ifdef __cplusplus
}
#endif
