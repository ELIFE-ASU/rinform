// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/mutual_info.h>
#include <inform/shannon.h>

static bool check_arguments(int const *series, size_t l, size_t n, int const *b,
    inform_error *err)
{
    if (series == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, true);
    }
    else if (l < 2)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOSOURCES, true);
    }
    else if (n < 1)
    {
        INFORM_ERROR_RETURN(err, INFORM_ESHORTSERIES, true);
    }
    for (size_t i = 0; i < l; ++i)
    {
        if (b[i] < 2)
        {
            INFORM_ERROR_RETURN(err, INFORM_EBASE, true);
        }
        for (size_t j = 0; j < n; ++j)
        {
            if (series[j + n * i] < 0)
            {
                INFORM_ERROR_RETURN(err, INFORM_ENEGSTATE, true);
            }
            else if (b[i] <= series[j + n * i])
            {
                INFORM_ERROR_RETURN(err, INFORM_EBADSTATE, true);
            }
        }
    }
    return false;
}

inline static bool allocate(int const *b, size_t l, inform_dist **joint,
    inform_dist **marginals, inform_error *err)
{
    size_t joint_support = 1;
    for (size_t i = 0; i < l; ++i)
    {
        joint_support *= b[i];
        if ((marginals[i] = inform_dist_alloc(b[i])) == NULL)
        {
            for (size_t j = 0; j < i; ++j)
            {
                inform_dist_free(marginals[j]);
            }
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, true);
        }
    }
    if ((*joint = inform_dist_alloc(joint_support)) == NULL)
    {
        for (size_t i = 0; i < l; ++i)
        {
            inform_dist_free(marginals[i]);
        }
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, true);
    }

    return false;
}

inline static void accumulate(int const *series, size_t l, size_t n,
    int const *b, inform_dist *joint, inform_dist **marginals)
{
    joint->counts = n;
    for (size_t i = 0; i < l; ++i)
    {
        marginals[i]->counts = n;
    }

    for (size_t i = 0; i < n; ++i)
    {
        size_t joint_event = 0;
        for (size_t j = 0; j < l; ++j)
        {
            joint_event = joint_event * b[j] + series[i + n * j];
            marginals[j]->histogram[series[i + n * j]]++;
        }
        joint->histogram[joint_event]++;
    }
}

inline static void free_all(inform_dist **joint, inform_dist **marginals,
    size_t l)
{
    inform_dist_free(*joint);
    for (size_t i = 0; i < l; ++i)
    {
        inform_dist_free(marginals[i]);
    }
    free(marginals);
}

double inform_mutual_info(int const *series, size_t l, size_t n, int const *b,
    inform_error *err)
{
    if (check_arguments(series, l, n, b, err)) return NAN;

    inform_dist **marginals = malloc(l * sizeof(inform_dist*));
    if (marginals == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NAN);
    }
    inform_dist *joint = NULL;
    if (allocate(b, l, &joint, marginals, err))
    {
        free(marginals);
        return NAN;
    }

    accumulate(series, l, n, b, joint, marginals);

    double mi = inform_shannon_multi_mi(joint, (inform_dist const **)marginals, l, 2.0);

    free_all(&joint, marginals, l);

    return mi;
}

double *inform_local_mutual_info(int const *series, size_t l, size_t n,
    int const *b, double *mi, inform_error *err)
{
    if (check_arguments(series, l, n, b, err)) return NULL;

    bool allocate_mi = (mi == NULL);
    if (allocate_mi)
    {
        mi = malloc(n * sizeof(double));
        if (mi == NULL)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
    }

    inform_dist **marginals = malloc(l * sizeof(inform_dist*));
    if (marginals == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    inform_dist *joint = NULL;
    if (allocate(b, l, &joint, marginals, err))
    {
        if (allocate_mi) free(mi);
        free(marginals);
        return NULL;
    }

    accumulate(series, l, n, b, joint, marginals);

    double norm = 1;
    for (size_t i = 0; i < l; ++i) norm *= marginals[i]->counts;
    norm /= joint->counts;

    double j, m;
    for (size_t i = 0; i < n; ++i)
    {
        m = 1;
        size_t joint_event = 0;
        for (size_t j = 0; j < l; ++j)
        {
            int marginal_event = series[i + n * j];
            m *= marginals[j]->histogram[marginal_event];
            joint_event = joint_event * b[j] + marginal_event;
        }
        j = joint->histogram[joint_event];
        mi[i] = log2((j * norm) / m);
    }

    free_all(&joint, marginals, l);

    return mi;
}