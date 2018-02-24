// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/conditional_entropy.h>
#include <inform/shannon.h>

static bool check_arguments(int const *xs, int const *ys, size_t n, int bx,
    int by, inform_error *err)
{
    if (xs == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, true);
    }
    else if (ys == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, true);
    }
    else if (n < 1)
    {
        INFORM_ERROR_RETURN(err, INFORM_ESHORTSERIES, true);
    }
    else if (bx < 2)
    {
        INFORM_ERROR_RETURN(err, INFORM_EBASE, true);
    }
    else if (by < 2)
    {
        INFORM_ERROR_RETURN(err, INFORM_EBASE, true);
    }
    for (size_t i = 0; i < n; ++i)
    {
        if (xs[i] < 0 || ys[i] < 0)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENEGSTATE, true);
        }
        else if (bx <= xs[i] || by <= ys[i])
        {
            INFORM_ERROR_RETURN(err, INFORM_EBADSTATE, true);
        }
    }
    return false;
}

inline static bool allocate(int bx, int by, inform_dist **x, inform_dist **xy,
    inform_error *err)
{
    if ((*x = inform_dist_alloc(bx)) == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, true);
    }
    if ((*xy = inform_dist_alloc(bx * by)) == NULL)
    {
        inform_dist_free(*x);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, true);
    }
    return false;
}

inline static void accumulate(int const *xs, int const *ys, size_t n, int by,
    inform_dist *x, inform_dist *xy)
{
    x->counts = n;
    xy->counts = n;

    for (size_t i = 0; i < n; ++i)
    {
        x->histogram[xs[i]]++;
        xy->histogram[xs[i]*by + ys[i]]++;
    }
}

inline static void free_all(inform_dist **x, inform_dist **xy)
{
    inform_dist_free(*x);
    inform_dist_free(*xy);
}

double inform_conditional_entropy(int const *xs, int const *ys, size_t n,
    int bx, int by, inform_error *err)
{
    if (check_arguments(xs, ys, n, bx, by, err)) return NAN;

    inform_dist *x = NULL, *xy = NULL;
    if (allocate(bx, by, &x, &xy, err)) return NAN;

    accumulate(xs, ys, n, by, x, xy);

    double ce = inform_shannon_ce(xy, x, 2.0);

    free_all(&x, &xy);

    return ce;
}

double *inform_local_conditional_entropy(int const *xs, int const *ys,
    size_t n, int bx, int by, double *ce, inform_error *err)
{
    if (check_arguments(xs, ys, n, bx, by, err)) return NULL;

    bool allocate_ce = (ce == NULL);
    if (allocate_ce)
    {
        ce = malloc(n * sizeof(double));
        if (ce == NULL)
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    inform_dist *x = NULL, *xy = NULL;
    if (allocate(bx, by, &x, &xy, err))
    {
        if (allocate_ce) free(ce);
        return NULL;
    }

    accumulate(xs, ys, n, by, x, xy);

    double s, m;
    for (size_t i = 0; i < n; ++i)
    {
        int z = xs[i]*by + ys[i];
        s = xy->histogram[z];
        m = x->histogram[xs[i]];
        ce[i] = log2(m/s);
    }

    free_all(&x, &xy);

    return ce;
}