// Copyright 2016 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/block_entropy.h>
#include <inform/shannon.h>

static void accumulate_observations(int const* series, size_t n, int b,
    size_t k, inform_dist *states)
{
    k -= 1;
    int history = 0, q = 1, state;
    for (size_t i = 0; i < k; ++i)
    {
        q *= b;
        history *= b;
        history += series[i];
    }
    for (size_t i = k; i < n; ++i)
    {
        state  = history * b + series[i];
        states->histogram[state]++;
        history = state - series[i - k]*q;
    }
}

static void accumulate_local_observations(int const* series, size_t n, int b,
    size_t k, inform_dist *states, int *state)
{
    k -= 1;
    int history = 0;
    int q = 1;
    for (size_t i = 0; i < k; ++i)
    {
        q *= b;
        history *= b;
        history += series[i];
    }
    for (size_t i = k; i < n; ++i)
    {
        size_t l = i - k;
        state[l] = history * b + series[i];

        states->histogram[state[l]]++;

        if (i + 1 != n)
            history = state[l] - series[l]*q;
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

    for (size_t i = 0; i < n; ++i, series += m)
    {
        accumulate_observations(series, m, b, k, &states);
    }

    double be = inform_shannon(&states, (double) b);

    free(data);

    return be;
}

double *inform_local_block_entropy(int const *series, size_t n, size_t m, int b,
    size_t k, double *be, inform_error *err)
{
    if (check_arguments(series, n, m, b, k, err)) return NULL;

    size_t const N = n * (m - k + 1);

    if (be == NULL)
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
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    inform_dist states = { data, states_size, N };

    int *state = malloc(N * sizeof(int));
    if (state == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    int const *series_ptr = series;
    int *state_ptr = state;
    for (size_t i = 0; i < n; ++i)
    {
        accumulate_local_observations(series_ptr, m, b, k, &states, state_ptr);
        series_ptr += m;
        state_ptr += (m - k + 1);
    }

    for (size_t i = 0; i < N; ++i)
    {
        be[i] = inform_shannon_si(&states, state[i], (double) b);
    }

    free(state);
    free(data);

    return be;
}
