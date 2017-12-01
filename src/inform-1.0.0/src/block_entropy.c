// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/block_entropy.h>
#include <inform/shannon.h>

static void accumulate_observations(int const* series, size_t n, size_t m,
    int b, size_t k, inform_dist *states)
{
    k -= 1;
    for (size_t i = 0; i < n; ++i, series += m)
    {
        int history = 0, q = 1, state;
        for (size_t j = 0; j < k; ++j)
        {
            q *= b;
            history *= b;
            history += series[j];
        }
        for (size_t j = k; j < m; ++j)
        {
            state  = history * b + series[j];
            states->histogram[state]++;
            history = state - series[j - k]*q;
        }
    }
}

static void accumulate_local_observations(int const* series, size_t n, size_t m,
    int b, size_t k, inform_dist *states, int *state)
{
    k -= 1;
    for (size_t i = 0; i < n; ++i)
    {
        int history = 0, q = 1;
        for (size_t j = 0; j < k; ++j)
        {
            q *= b;
            history *= b;
            history += series[j];
        }
        for (size_t j = k; j < m; ++j)
        {
            size_t l = j - k;
            state[l] = history * b + series[j];

            states->histogram[state[l]]++;

            if (j + 1 != m)
                history = state[l] - series[l]*q;
        }
        series += m;
        state += (m - k);
    }
}

static bool check_arguments(int const *series, size_t n, size_t m, int b,
    size_t k, inform_error *err)
{
    if (series == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, true);
    }
    else if (n < 1)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOINITS, true);
    }
    else if (m < 2)
    {
        INFORM_ERROR_RETURN(err, INFORM_ESHORTSERIES, true);
    }
    else if (b < 2)
    {
        INFORM_ERROR_RETURN(err, INFORM_EBASE, true);
    }
    else if (k == 0)
    {
        INFORM_ERROR_RETURN(err, INFORM_EKZERO, true);
    }
    else if (m <= k)
    {
        INFORM_ERROR_RETURN(err, INFORM_EKLONG, true);
    }
    for (size_t i = 0; i < n * m; ++i)
    {
        if (series[i] < 0)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENEGSTATE, true);
        }
        else if (b <= series[i])
        {
            INFORM_ERROR_RETURN(err, INFORM_EBADSTATE, true);
        }
    }
    return false;
}

double inform_block_entropy(int const *series, size_t n, size_t m, int b,
    size_t k, inform_error *err)
{
    if (check_arguments(series, n, m, b, k, err)) return NAN;

    size_t const states_size = (size_t) pow((double) b, (double) k);

    uint32_t *data = calloc(states_size, sizeof(uint32_t));
    if (data == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NAN);
    }

    size_t const N = n * (m - k + 1);

    inform_dist states = { data, states_size, N };

    accumulate_observations(series, n, m, b, k, &states);

    double be = inform_shannon_entropy(&states, 2.0);

    free(data);

    return be;
}

double *inform_local_block_entropy(int const *series, size_t n, size_t m, int b,
    size_t k, double *be, inform_error *err)
{
    if (check_arguments(series, n, m, b, k, err)) return NULL;

    size_t const N = n * (m - k + 1);

    bool allocate_be = (be == NULL);
    if (allocate_be)
    {
        be = malloc(N * sizeof(double));
        if (be == NULL)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
    }

    size_t const states_size = (size_t) pow((double) b, (double) k);

    uint32_t *data = calloc(states_size, sizeof(uint32_t));
    if (data == NULL)
    {
        if (allocate_be) free(be);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    inform_dist states = { data, states_size, N };

    int *state = malloc(N * sizeof(int));
    if (state == NULL)
    {
        if (allocate_be) free(be);
        free(data);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    accumulate_local_observations(series, n, m, b, k, &states, state);

    double s;
    for (size_t i = 0; i < N; ++i)
    {
        s = states.histogram[state[i]];
        be[i] = -log2(s/N);
    }

    free(state);
    free(data);

    return be;
}
