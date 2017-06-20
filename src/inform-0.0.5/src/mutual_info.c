// Copyright 2016 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/mutual_info.h>
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

inline static bool allocate(int bx, int by, inform_dist **x, inform_dist **y,
    inform_dist **xy, inform_error *err)
{
    if ((*x = inform_dist_alloc(bx)) == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, true);
    }
    if ((*y = inform_dist_alloc(by)) == NULL)
    {
        inform_dist_free(*x);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, true);
    }
    if ((*xy = inform_dist_alloc(bx * by)) == NULL)
    {
        inform_dist_free(*y);
        inform_dist_free(*x);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, true);
    }
    return false;
}

inline static void accumulate(int const *xs, int const *ys, size_t n, int by,
    inform_dist *x, inform_dist *y, inform_dist *xy)
{
    x->counts = n;
    y->counts = n;
    xy->counts = n;

    for (size_t i = 0; i < n; ++i)
    {
        x->histogram[xs[i]]++;
        y->histogram[ys[i]]++;
        xy->histogram[xs[i]*by + ys[i]]++;
    }
}

inline static void free_all(inform_dist **x, inform_dist **y, inform_dist **xy)
{
    inform_dist_free(*x);
    inform_dist_free(*y);
    inform_dist_free(*xy);
}

double inform_mutual_info(int const *xs, int const *ys, size_t n, int bx,
    int by, double b, inform_error *err)
{
    if (check_arguments(xs, ys, n, bx, by, err)) return NAN;

    inform_dist *x = NULL, *y = NULL, *xy = NULL;
    if (allocate(bx, by, &x, &y, &xy, err)) return NAN;

    accumulate(xs, ys, n, by, x, y, xy);

    double mi = inform_shannon_mi(xy, x, y, (double) b);

    free_all(&x, &y, &xy);

    return mi;
}

double *inform_local_mutual_info(int const *xs, int const *ys, size_t n, int bx,
    int by, double b, double *mi, inform_error *err)
{
    if (check_arguments(xs, ys, n, bx, by, err)) return NULL;

    if (mi == NULL)
    {
        mi = malloc(n * sizeof(double));
        if (mi == NULL)
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    inform_dist *x = NULL, *y = NULL, *xy = NULL;
    if (allocate(bx, by, &x, &y, &xy, err)) return NULL;

    accumulate(xs, ys, n, by, x, y, xy);

    for (size_t i = 0; i < n; ++i)
    {
        int z = xs[i]*by + ys[i];
        mi[i] = inform_shannon_pmi(xy, x, y, z, xs[i], ys[i], (double) b);
    }

    free_all(&x, &y, &xy);

    return mi;
}