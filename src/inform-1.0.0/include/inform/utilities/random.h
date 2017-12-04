// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#pragma once

#include <inform/export.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C"
{
#endif

/**
 * Seed the C psuedo-random number generator.
 *
 * This is just a convenience wrapper for the standard `srand(time(NULL))`.
 */
EXPORT void inform_random_seed();

/**
 * Generate a pseudo-random integer uniformly sampled between `a` and `b`.
 *
 * @param[in] a the lower bound
 * @param[in] b the upper bound
 * @return the generated integer
 */
EXPORT int inform_random_int(int a, int b);

/**
 * Generate an array of `n` pseudo-random integers uniformly sampled between
 * `a` and `b`.
 *
 * @param[in] a the lower bound
 * @param[in] b the upper bound
 * @param[in] n the number of samples
 * @return an array of generated integers
 */
EXPORT int *inform_random_ints(int a, int b, size_t n);

/**
 * Generate a base-`b` array of `n` pseudo-random integers.
 *
 * This function is just a convenience wrapper for
 * `inform_random_ints(0, b, n)`.
 *
 * @param[in] n the number of samples
 * @param[in] b the base of the samples
 * @return an array of generated integers
 */
EXPORT int *inform_random_series(size_t n, int b);

#ifdef __cplusplus
}
#endif
