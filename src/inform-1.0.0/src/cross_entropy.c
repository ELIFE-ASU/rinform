// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/cross_entropy.h>
#include <inform/shannon.h>

static bool check_arguments(int const *ps, int const *qs, size_t n, int b,
    inform_error *err)
{
    if (ps == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, true);
    }
    else if (qs == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, true);
    }
    else if (n < 1)
    {
        INFORM_ERROR_RETURN(err, INFORM_ESHORTSERIES, true);
    }
    else if (b < 2)
    {
        INFORM_ERROR_RETURN(err, INFORM_EBASE, true);
    }
    for (size_t i = 0; i < n; ++i)
    {
        if (ps[i] < 0 || qs[i] < 0)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENEGSTATE, true);
        }
        else if (b <= ps[i] || b <= qs[i])
        {
            INFORM_ERROR_RETURN(err, INFORM_EBADSTATE, true);
        }
    }
    return false;
}

inline static bool allocate(int b, inform_dist **p, inform_dist **q,
    inform_error *err)
{
    if ((*p = inform_dist_alloc(b)) == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, true);
    }
    if ((*q = inform_dist_alloc(b)) == NULL)
    {
        inform_dist_free(*p);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, true);
    }
    return false;
}

inline static void accumulate(int const *ps, int const *qs, size_t n,
    inform_dist *p, inform_dist *q)
{
    p->counts = n;
    q->counts = n;

    for (size_t i = 0; i < n; ++i)
    {
        p->histogram[ps[i]]++;
        q->histogram[qs[i]]++;
    }
}

inline static void free_all(inform_dist **p, inform_dist **q)
{
    inform_dist_free(*p);
    inform_dist_free(*q);
}

double inform_cross_entropy(int const *ps, int const *qs, size_t n, int b,
    inform_error *err)
{
    if (check_arguments(ps, qs, n, b, err)) return NAN;

    inform_dist *p = NULL, *q = NULL;
    if (allocate(b, &p, &q, err)) return NAN;

    accumulate(ps, qs, n, p, q);

    double ce = inform_shannon_cross(p, q, 2.0);

    free_all(&p, &q);

    return ce;
}
