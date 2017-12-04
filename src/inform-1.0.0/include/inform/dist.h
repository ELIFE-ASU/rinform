// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#pragma once

#include <inform/export.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C"
{
#endif

/**
 * A distribution of observed event frequencies
 *
 * This structure is the basis for almost all of the calculations performed
 * via the library. It provides a means of managing observations and converting
 * the observed event frequencies to probabilities.
 *
 * A distribution can be allocated with a set number of observable events
 * (inform_dist_alloc), resized (inform_dist_realloc), copied
 * (inform_dist_copy) or duplicated (inform_dist_dup). Once the distribution
 * has served its purpose, it can be freed (inform_dist_free).
 *
 * The distribution is, roughly, a histogram with finite support. The events
 * are assumed to be mapped to the dense set of integers @f {0, 1, ..., N-1} @f
 * where @f N @f is the number of observable events. The number of observable
 * events can be extracted with inform_dist_size.
 *
 * Events can be observed one at a time (inform_dist_tick) or in batches
 * (inform_dist_set). The occurance frequency of a given event can be
 * obtained (inform_dist_get) as can the total number of observations
 * (inform_dist_counts).
 *
 * Once the distribution populated, the probabilities can be extracted in either
 * element-by-element (inform_dist_prob) or dumped to a dynamically allocated
 * array (inform_dist_dump).
 *
 * Whenever the size of the support or the number of observed events is zero,
 * the distrubution is considered invalid meaning that you can't trust any
 * probabilities extracted from it. One can use inform_dist_is_valid to assess
 * the validity of the distribution.
 */
typedef struct inform_distribution
{
    /// the histogram or array of observation frequencies
    uint32_t *histogram;
    /// the size of the support
    size_t size;
    /// the number of observations made so far
    uint64_t counts;
} inform_dist;

/**
 * Allocate a distribution with a specified support size.
 *
 * The allocation will fail and return `NULL` if either `n == 0` or
 * the memory allocation fails for whatever reason.
 *
 * Immediately following allocation, the distribution is invalid.
 *
 * @param[in] n the number of distinct events that could be observed
 * @return the distribution
 */
EXPORT inform_dist* inform_dist_alloc(size_t n);
/**
 * Resize the distribution to have new support.
 *
 * If the distribution is `NULL`, a new distribution of the requested
 * size is allocated.
 *
 * If the distribution already has the requested size, then the original
 * distribution is returned. If the requested size is greater than the
 * current size, then the newly observable events are assigned
 * zero frequency. If the requested size is less than the current size,
 * then the discarded events are lost and the observation count is adjusted
 * accordingly.
 *
 * Note that the distribution cannot be reduced to size `0`. In that case
 * the distribution is left unmodified.
 *
 * In the event that the reallocation fails, the original distribution
 * is left untouched.
 *
 * @param[in,out] dist the distribution to resize
 * @param[in] n        the desired support size
 * @return the reallocated distribution
 */
EXPORT inform_dist* inform_dist_realloc(inform_dist *dist, size_t n);
/**
 * Copy a distribution to a destination.
 *
 * If the source distribution is `NULL`, then the destination is
 * left untouched and `NULL` is returned.
 *
 * In the event that the destination is `NULL` or has a different
 * size from that of the source, the destination is reallocated, and
 * the result is returned.
 *
 * @param[in] src the source distribution
 * @param[in,out] the destination distribution
 * @return a pointer to the copied distribution
 */
EXPORT inform_dist* inform_dist_copy(inform_dist const *src, inform_dist *dest);
/**
 * Duplicate a distribution.
 *
 * This function simply duplicates a distribution, essentially allocating
 * a new distribution and copying the contents of the source to the new
 * distribution.
 *
 * If the allocation fails or the source distribution is `NULL`, then the
 * return value is `NULL`.
 *
 * @param[in] dist the source distribution
 * @return the new distribution
 */
EXPORT inform_dist* inform_dist_dup(inform_dist const *dist);
/**
 * Create a distribution from an underlying histogram.
 *
 * @param[in] data the underlying histogram data
 * @param[in] n    the number of events in the histogram
 * @return the new distribution
 */
EXPORT inform_dist* inform_dist_create(uint32_t const *data, size_t n);
/**
 * Infer a distribution from a collection of observed events.
 *
 * @param[in] events   the events to observe
 * @param[in] n        the number of events provided
 * @return the new distribution
 */
EXPORT inform_dist* inform_dist_infer(int const *events, size_t n);
/**
 * Approximate a given probability distribution to a given tolerance.
 *
 * @param[in] probs the probabilities
 * @param[in] n     the number of probabilities
 * @param[in] tol   the acceptable tolerance
 * @return the new distribution
 */
EXPORT inform_dist* inform_dist_approximate(double const *probs, size_t n,
    double tol);
/**
 * Create a uniform distribution of a given size.
 * @param[in] n the size of the distribution
 * @return the new distribution
 */
EXPORT inform_dist* inform_dist_uniform(size_t n);
/**
 * Free all dynamically allocated memory associated with a distribution.
 *
 * @param[in] dist the distribution to free
 */
EXPORT void inform_dist_free(inform_dist *dist);

/**
 * Get the size of the distribution's support.
 *
 * If the distribution is `NULL`, then a support of `0` is returned.
 *
 * @param[in] dist the distribution
 * @return the size of the distribution's support
 */
EXPORT size_t inform_dist_size(inform_dist const *dist);
/**
 * Get the total number of observations so far made.
 *
 * If the distribution is `NULL`, then return `0`.
 *
 * @param[in] dist the distribution
 * @return the number of observations thus far made
 */
EXPORT uint64_t inform_dist_counts(inform_dist const *dist);
/**
 * Determine whether or not the distribution is valid.
 *
 * In order to safely extract probabilities, the distribution must be
 * non-`NULL`, the size of the support must be non-zero and the number
 * of observations must be non-zero. In any other case, the distribution
 * is invalid.
 *
 * @param[in] dist the distribution
 * @return the validity of the distribution
 */
EXPORT bool inform_dist_is_valid(inform_dist const *dist);

/**
 * Get the number of occurances of a given event.
 *
 * If the distribution is `NULL` or the `event` is not in the support,
 * `0` is returned.
 *
 * @param[in] dist  the distribution
 * @param[in] event the event in question
 * @return the number of observed occurances of the event
 *
 * @see inform_dist_set
 */
EXPORT uint32_t inform_dist_get(inform_dist const *dist, size_t event);
/**
 * Set the number of occurances of a given event.
 *
 * This function manually sets the number of occurances of a given event.
 * Note that the only restriction is that the value be positive. This means
 * that this function can be used to invalidate the distribution by changing
 * all of the event frequencies to zero.
 *
 * If the event is not in the support or the distribution is `NULL`, then
 * nothing happens and zero is returned.
 *
 * @param[in,out] dist  the distribution
 * @param[in] event     the event in question
 * @return the new number of observed occurances of the event
 *
 * @see inform_dist_get
 * @see inform_dist_tick
 */
EXPORT uint32_t inform_dist_set(inform_dist *dist, size_t event, uint32_t x);

/**
 * Increment the number of observations of a given event.
 *
 * As an alternative to inform_dist_set, this function simply increments
 * the number of occurances of a given event. This is useful for when
 * iteratively observing events.
 *
 * If the event is not in the support or the distribution is `NULL`, then
 * nothing happens and zero is returned.
 *
 * @param[in,out] dist the distribution
 * @param[in] event    the event in question
 * @return the new number of occurances of the event
 *
 * @see inform_dist_set
 */
EXPORT uint32_t inform_dist_tick(inform_dist *dist, size_t event);

/**
 * Extact the probability of an event.
 *
 * This function simply computes the probability of a given event and
 * returns that value.
 *
 * If the event is not in the support, the distribution is `NULL`, or
 * no observations have yet been made, then a zero probability is returned.
 *
 * @param[in] dist the distribution
 * @param[in] event the event in question
 * @return the heuristic probability of the event
 *
 * @see inform_dist_get
 * @see inform_dist_dump
 */
EXPORT double inform_dist_prob(inform_dist const *dist, size_t event);
/**
 * Dump the probabilities of all events to an array.
 *
 * This function computes the probabilities of all of the events in the
 * support, stores them in the provided array, and the number of values
 * written.
 *
 * If the distribution is `NULL`, -1 is returned. If the destination is
 * NULL, -2 is returned. If `n` is not equal to the distribution's
 * support, -3 is returned.
 *
 * @param[in] dist  the distribution
 * @param[out] arr  the preallocated array of probabilities
 * @param[in] probs the size of the preallocated array
 * @return the number of probabilities written to the array
 */
EXPORT size_t inform_dist_dump(inform_dist const *dist, double *probs, size_t n);
/**
 * Accumulate observations from a series.
 *
 * If an invalid distribution is provided, no events will be observed (0 will
 * be returned). If an invalid event is provided, then the number of valid
 * events to that point will be returned.
 *
 * @param[in,out] dist the distribution
 * @param[in] events   the events to observe
 * @param[in] n        the number of events provided
 * @return the number of valid observations
 */
EXPORT size_t inform_dist_accumulate(inform_dist *dist, int const *events,
    size_t n);

#ifdef __cplusplus
}
#endif
