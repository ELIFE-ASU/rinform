// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/integration.h>
#include <inform/mutual_info.h>
#include <inform/utilities.h>
#include <math.h>

static bool check_arguments(int const *series, size_t l, inform_error *err)
{
    if (series == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, true);
    }
    else if (l < 2)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOSOURCES, true);
    }
    // All other checks will be caught by inform_black_box_parts or
    // inform_local_mutual_info
    return false;
}

double *inform_integration_evidence(int const *series, size_t l, size_t n,
    int const *b, double *evidence, inform_error *err)
{
    if (check_arguments(series, l, err))
    {
        return NULL;
    }
    int allocate = (evidence == NULL);
    if (allocate)
    {
        evidence = malloc(2 * n * sizeof(double));
        if (evidence == NULL)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
    }
    double *lmi = malloc(n * sizeof(double));
    if (lmi == NULL)
    {
        if (allocate) free(evidence);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    double *minimum = evidence;
    double *maximum = minimum + n;
    for (size_t i = 0; i < n; ++i)
    {
        minimum[i] = INFINITY;
        maximum[i] = -INFINITY;
    }

    size_t *parts = inform_first_partitioning(l);
    size_t nparts = 1;
    while ((nparts = inform_next_partitioning(parts, l)))
    {
        inform_integration_evidence_part(series, l, n, b, parts, nparts, lmi, err);
        if (inform_failed(err))
        {
            break;
        }
        for (size_t i = 0; i < n; ++i)
        {
            minimum[i] = MIN(minimum[i], lmi[i]);
            maximum[i] = MAX(maximum[i], lmi[i]);
        }
    }
    free(parts);
    free(lmi);
    
    if (inform_failed(err))
    {
        if (allocate)
        {
            free(evidence);
        }
        return NULL;
    }

    return evidence;
}

double *inform_integration_evidence_part(int const *series, size_t l, size_t n,
    int const *b, size_t const *parts, size_t nparts, double *evidence,
    inform_error *err)
{
    if (check_arguments(series, l, err))
    {
        return NULL;
    }
    int allocate_evidence = (evidence == NULL);
    if (allocate_evidence)
    {
        evidence = malloc(2 * n * sizeof(double));
        if (evidence == NULL)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
    }
    size_t *partitioning = (size_t *)parts;
    int allocate_parts = (partitioning == NULL);
    if (allocate_parts)
    {
        partitioning = malloc(l * sizeof(size_t));
        if (partitioning == NULL)
        {
            if (allocate_evidence) free(evidence);
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
        for (size_t i = 0; i < l; ++i) partitioning[i] = i;
        nparts = l;
    }
    int *partitioned = inform_black_box_parts(series, l, n, b, partitioning,
        nparts, NULL, err);
    if (inform_succeeded(err))
    {
        inform_local_mutual_info(partitioned, nparts, n, partitioned + nparts*n,
            evidence, err);
    }
    free(partitioned);
    if (allocate_parts) free(partitioning);
    if (inform_failed(err))
    {
        if (allocate_evidence) free(evidence);
        return NULL;
    }
    return evidence;
}
