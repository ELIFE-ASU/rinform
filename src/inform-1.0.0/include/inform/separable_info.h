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
 * Compute the separable information into a node from a set of sources
 *
 * @param[in] srcs the ensemble of the source nodes
 * @param[in] dest the ensemble of the target node
 * @param[in] l    the number of source nodes
 * @param[in] n    the number of initial conditions
 * @param[in] m    the number of time steps in each time series
 * @param[in] b    the base or number of distinct states at each time step
 * @param[in] k    the history length
 * @param[out] err an error structure
 * @return the separable information of the ensemble
 */
EXPORT double inform_separable_info(int const *srcs, int const *dest, size_t l,
    size_t n, size_t m, int b, size_t k, inform_error *err);

/**
 * Compute the local separable information into a node from a set of sources
 *
 * @param[in] srcs the ensemble of the source node
 * @param[in] dest the ensemble of the target node
 * @param[in] l    the number of source nodes
 * @param[in] n    the number of initial conditions
 * @param[in] m    the number of time steps in each time series
 * @param[in] b    the base or number of distinct states at each time step
 * @param[in] k    the history length
 * @param[out] si  the separable information array
 * @param[out] err an error structure
 * @return a pointer to the separable information array
 */
EXPORT double *inform_local_separable_info(int const *srcs, int const *dest,
    size_t l, size_t n, size_t m, int b, size_t k, double *si,
    inform_error *err);

#ifdef __cplusplus
}
#endif
