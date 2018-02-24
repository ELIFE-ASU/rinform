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
 * Compute the information flow from one time series to another
 *
 * @param[in] src    the ensemble of   the source node
 * @param[in] dst    the ensemble of   the destination node
 * @param[in] back   the collection of background nodes
 * @param[in] l_src  the number of source nodes
 * @param[in] l_dst  the number of destination nodes
 * @param[in] l_back the number of background nodes
 * @param[in] n      the number initial conditions
 * @param[in] m      the number of time steps in each time series
 * @param[in] b      the base or number of distinct states at each time step
 * @param[out] err an error structure
 * @return the information flow of the ensemble
 */
EXPORT double inform_information_flow(int const *src, int const *dst,
    int const *back, size_t l_src, size_t l_dst, size_t l_back, size_t n,
    size_t m, int b, inform_error *err);

#ifdef __cplusplus
}
#endif
