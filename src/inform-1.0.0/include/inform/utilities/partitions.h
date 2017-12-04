// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#pragma once

#include <inform/export.h>

#ifdef __cplusplus
extern "C"
{
#endif

/**
 * Compute the first partitioning of a given size
 *
 * This partitioning will be the coarsest partitioning: one partition with all
 * of the elements.
 *
 * @param[in] size the number of elements
 * @return an array of partition numbers (all zeros)
 */
EXPORT size_t *inform_first_partitioning(size_t size);

/**
 * Compute the next partition in place
 *
 * @param[in,out] xs the current partition
 * @param[in] size   the number of elements
 * @return the number of partitions
 */
EXPORT size_t inform_next_partitioning(size_t *xs, size_t size);

#ifdef __cplusplus
}
#endif
