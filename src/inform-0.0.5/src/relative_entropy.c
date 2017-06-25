// Copyright 2016 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/relative_entropy.h>
#include <inform/shannon.h>

static bool check_arguments(int const *xs, int const *ys, size_t n, int b,
    inform_error *err)
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
    else if (b < 2)
    {
        INFORM_ERROR_RETURN(err, INFORM_EBASE, true);
    }
    for (size_t i = 0; i < n; ++i)
    {
        if (xs[i] < 0 || ys[i] < 0)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENEGSTATE, true);
        }
        else if (b <= xs[i] || b <= ys[i])
        {
            INFORM_ERROR_RETURN(err, INFORM_EBADSTATE, true);
        }
    }
    return false;
}

inline static bool allocate(int b, inform_dist **x, inform_dist **y,
    inform_error *err)
{
    if ((*x = inform_dist_alloc(b)) == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, true);
    }
    if ((*y = inform_dist_alloc(b)) == NULL)
    {
        inform_dist_free(*x);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, true);
    }
    return false;
}

inline static void accumulate(int const *xs, int const *ys, size_t n,
    inform_dist *x, inform_dist *y)
{
    x->counts = n;
    y->counts = n;

    for (size_t i = 0; i < n; ++i)
    {
        x->histogram[xs[i]]++;
        y->histogram[ys[i]]++;
    }
}

inline static void free_all(inform_dist **x, inform_dist **y)
{
    inform_dist_free(*x);
    inform_dist_free(*y);
}

double inform_relative_entropy(int const *xs, int const *ys, size_t n, int b,
    double base, inform_error *err)
{
    if (check_arguments(xs, ys, n, b, err)) return NAN;

    inform_dist *x = NULL, *y = NULL;
    if (allocate(b, &x, &y, err)) return NAN;

    accumulate(xs, ys, n, x, y);

    double re = inform_shannon_re(x, y, base);

    free_all(&x, &y);

    return re;
}

double *inform_local_relative_entropy(int const *xs, int const *ys, size_t n,
    int b, double base, double *re, inform_error *err)
{
    if (check_arguments(xs, ys, n, b, err)) return NULL;

    if (re == NULL)
    {
        re = malloc(n * sizeof(double));
        if (re == NULL)
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    inform_dist *x = NULL, *y = NULL;
    if (allocate(b, &x, &y, err)) return NULL;

    accumulate(xs, ys, n, x, y);

    for (size_t i = 0; i < (size_t) b; ++i)
    {
        re[i] = inform_shannon_pre(x, y, i, base);
    }

    free_all(&x, &y);

    return re;
}