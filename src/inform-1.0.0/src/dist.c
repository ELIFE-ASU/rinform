// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/dist.h>
#include <string.h>
#include <math.h>

inform_dist* inform_dist_alloc(size_t n)
{
    // if the requested support size is zero, return NULL
    if (n == 0)
    {
        return NULL;
    }
    // allocate the distribution
    inform_dist *dist = malloc(sizeof(inform_dist));
    // if the allocation succeeded
    if (dist != NULL)
    {
        // allocate the underlying histogram
        dist->histogram = calloc(n, sizeof(uint32_t));
        // if the allocation succeeded
        if (dist->histogram != NULL)
        {
            // set the distribution size and counts
            dist->size   = n;
            dist->counts = 0;
        }
        // otherwise free the distribution
        else
        {
            free(dist);
            dist = NULL;
        }
    }
    // return the (potentially NULL) distribution
    return dist;
}

inform_dist* inform_dist_realloc(inform_dist *dist, size_t n)
{
    // if the requested size is zero, return the original distribution
    if (n == 0)
    {
        return dist;
    }
    // if the distribution is not NULL and the requested size is different
    // from the current size
    if (dist != NULL && dist->size != n)
    {
        // realloc the histogram
        uint32_t *histogram = realloc(dist->histogram, n * sizeof(uint32_t));
        // if the reallocation succeeded
        if (histogram != NULL)
        {
            // reset the distribution's histogram to the new histogram
            dist->histogram = histogram;
            // if the histogram was shrunken
            if (n < dist->size)
            {
                // set the new distribution size
                dist->size = n;
                // sum up the counts that are in the smaller support
                dist->counts = 0;
                for (size_t i = 0; i < dist->size; ++i)
                {
                    dist->counts += dist->histogram[i];
                }
            }
            // otherwise
            else
            {
                // zero out all of the newly observable events
                for (size_t i = dist->size; i < n; ++i)
                {
                    dist->histogram[i] = 0;
                }
                // set the size of the distribution
                dist->size = n;
            }
        }
        // otherwise
        else
        {
            // return NULL leaving the original distribution unscathed
            return NULL;
        }
    }
    // if the original distribution was NULL
    else if (dist == NULL)
    {
        // simply allocate the a new distribution of the requested size
        dist = inform_dist_alloc(n);
    }
    // return the (potentially NULL) distribution
    return dist;
}

inform_dist* inform_dist_copy(inform_dist const *src, inform_dist *dest)
{
    // if the source is NULL, return NULL.
    if (src == NULL)
    {
        return NULL;
    }
    // if the destination is NULL or the destination size is not the same
    // as the source
    else if (dest == NULL || src->size != dest->size)
    {
        // reallocate the destination
        inform_dist *redest = inform_dist_realloc(dest, src->size);
        // return NULL if the allocation fails
        if (redest == NULL)
        {
            return NULL;
        }
        // point dest at the new distribution
        dest = redest;
    }
    // don't copy the source to itself
    else if (src == dest)
    {
        return dest;
    }
    // copy the contents of the histogram from the source to the destination
    memcpy(dest->histogram, src->histogram, src->size * sizeof(uint32_t));
    // set the counts appropriately
    dest->counts = src->counts;
    // return the modified destination
    return dest;
}

inform_dist* inform_dist_dup(inform_dist const *dist)
{
    // if the source distribution is NULL, then just return NULL.
    if (dist == NULL)
    {
        return NULL;
    }
    // allocate the new distribution
    inform_dist *dup = inform_dist_alloc(dist->size);
    // if the allocation succeeded
    if (dup != NULL)
    {
        // copy the source distribution to the new distribution
        inform_dist_copy(dist, dup);
    }
    // return the (potentially NULL) distribution
    return dup;
}

inform_dist* inform_dist_create(uint32_t const *data, size_t n)
{
    // if the requested support size is zero, return NULL
    if (data == NULL || n == 0)
    {
        return NULL;
    }
    // allocate the distribution
    inform_dist *dist = malloc(sizeof(inform_dist));
    // if the allocation succeeded
    if (dist != NULL)
    {
        // allocate the underlying histogram
        dist->histogram = calloc(n, sizeof(uint32_t));
        // if the allocation succeeded
        if (dist->histogram != NULL)
        {
            // set the distribution content, size and counts
            memcpy(dist->histogram, data, n*sizeof(uint32_t));
            dist->size   = n;
            dist->counts = 0;
            for (size_t i = 0; i < n; ++i)
            {
                dist->counts += dist->histogram[i];
            }
        }
        // otherwise free the distribution
        else
        {
            free(dist);
            dist = NULL;
        }
    }
    // return the (potentially NULL) distribution
    return dist;
}

static inline int gcd(uint32_t const *data, size_t n)
{
    if (n == 0)
    {
        return 1;
    }
    uint32_t x, temp, gcd = data[0];
    for (size_t i = 1; i < n; ++i)
    {
        x = data[i];
        while (x != 0)
        {
            temp = x;
            x = gcd % x;
            gcd = temp;
        }
    }
    return gcd;
}

inform_dist* inform_dist_approximate(double const *probs, size_t n, double tol)
{
    if (probs == NULL || n == 0)
    {
        return NULL;
    }
    tol = fabs(tol);
    // check the validity of the probability distribution
    double diff = 1.0;
    for (size_t i = 0; i < n; ++i)
    {
        diff -= probs[i];
        if (probs[i] < 0.0) return NULL;
    }
    if (fabs(diff) > (double)n * tol)
    {
        return NULL;
    }
    // determine the number of counts
    uint32_t *counts = malloc(n * sizeof(int));
    if (counts == NULL)
    {
        return NULL;
    }
    for (size_t i = 0; i < n; ++i)
    {
        counts[i] = (uint32_t)(probs[i] / tol);
    }
    int g = gcd(counts, n);
    for (size_t i = 0; i < n; ++i)
    {
        counts[i] /= g;
    }
    // create the distribution
    inform_dist *dist = inform_dist_create(counts, n);
    free(counts);
    return dist;
}

inform_dist* inform_dist_infer(int const *events, size_t n)
{
    // if no events are observed, return NULL
    if (events == NULL || n == 0) return NULL;

    // infer the support
    int b = -1, event = 0;
    for (size_t i = 0; i < n; ++i)
    {
        event = events[i];
        if (event < 0)
        {
            b = -2;
            break;
        }
        if (event > b) b = event;
    }
    if (b < 0) return NULL;
    // the base is one greater than the largest observed event
    b += 1;
    // allocate the distribution
    inform_dist *dist = inform_dist_alloc(b);
    // accumulate the observations
    if (dist != NULL)
    {
        if (inform_dist_accumulate(dist, events, n) != n)
        {
            inform_dist_free(dist);
            dist = NULL;
        }
    }
    return dist;
}

inform_dist* inform_dist_uniform(size_t n)
{
    // construct a distribution of the desired size
    inform_dist *dist = inform_dist_alloc(n);
    if (dist != NULL)
    {
        // set the counts to the number of states
        dist->counts = n;
        // set the count for each state to 1
        for (size_t i = 0; i < n; ++i) dist->histogram[i] = 1;
    }
    return dist;
}

void inform_dist_free(inform_dist *dist)
{
    if (dist != NULL)
    {
        if (dist->histogram != NULL)
        {
            free(dist->histogram);
        }
        free(dist);
    }
}

size_t inform_dist_size(inform_dist const *dist)
{
    return (dist == NULL) ? 0 : dist->size;
}

uint64_t inform_dist_counts(inform_dist const *dist)
{
    return (dist == NULL) ? 0 : dist->counts;
}

bool inform_dist_is_valid(inform_dist const *dist)
{
    return dist != NULL && dist->size != 0 && dist->counts != 0;
}

uint32_t inform_dist_get(inform_dist const *dist, size_t event)
{
    // if the distribution is NULL or the event is outsize of the support
    if (dist == NULL || event >= dist->size)
    {
        return 0;
    }
    // otherwise return the number of occurances of the event
    return dist->histogram[event];
}

uint32_t inform_dist_set(inform_dist *dist, size_t event, uint32_t x)
{
    // if the distribution is NULL or the event is outsize of the support
    if (dist == NULL || event >= dist->size)
    {
        return 0;
    }
    // otherwise decrement counts by the old number of occurances
    dist->counts -= dist->histogram[event];
    // increment counts by the new number of occurances
    dist->counts += x;
    // set and return the new number of occurances of the event
    return (dist->histogram[event] = x);
}

uint32_t inform_dist_tick(inform_dist *dist, size_t event)
{
    // if the distribution is NULL or the event is outsize of the support
    if (dist == NULL || event >= dist->size)
    {
        return 0;
    }
    // increment counts by one
    dist->counts += 1;
    // increment by one and return the new number of occurances of the event
    return (dist->histogram[event] += 1);
}

static double inform_dist_unsafe_prob(inform_dist const *dist, size_t event)
{
    // unsafely compute the probability of an event
    // this will fail if there have been no observations made
    return (double)(dist->histogram[event]) / dist->counts;
}

double inform_dist_prob(inform_dist const *dist, size_t event)
{
    // if the distribution is NULL, no observations have been made
    // or the event is outsize of the support
    if (dist == NULL || dist->counts == 0 || event >= dist->size)
    {
        return 0;
    }
    // return the probability of the event
    return inform_dist_unsafe_prob(dist, event);
}

size_t inform_dist_dump(inform_dist const *dist, double *probs, size_t n)
{
    // if the distribution is NULL or the event is outsize of the support
    if (dist == NULL || dist->size == 0)
    {
        return 0;
    }
    if (probs == NULL)
    {
        return 0;
    }
    if (n != dist->size)
    {
        return 0;
    }
    // loop over the events
    for (size_t i = 0; i < inform_dist_size(dist); ++i)
    {
        // store their probabilities in the array
        probs[i] = inform_dist_unsafe_prob(dist,i);
    }
    return (int) n;
}

size_t inform_dist_accumulate(inform_dist *dist, int const *events, size_t n)
{
    // if the distribution is invalid or no events were provided
    if (dist == NULL || events == NULL || dist->size == 0)
    {
        return 0;
    }
    // loop over the events and add them to the distribution
    int const size = (int)dist->size;
    size_t i = 0;
    while (i < n)
    {
        if (size <= *events || *events < 0) break;
        dist->histogram[*events] += 1;
        dist->counts += 1;
        ++events;
        ++i;
    }
    return i;
}
