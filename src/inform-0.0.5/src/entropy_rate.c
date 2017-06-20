// Copyright 2016 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/entropy_rate.h>
#include <inform/shannon.h>

static void accumulate_observations(int const* series, size_t n,
    int b, size_t k, inform_dist *states, inform_dist *histories)
{
    int history = 0, q = 1, state, future;
    for (size_t i = 0; i < k; ++i)
    {
        q *= b;
        history *= b;
        history += series[i];
    }
    for (size_t i = k; i < n; ++i)
    {
        future = series[i];
        state  = history * b + future;

        states->histogram[state]++;
        histories->histogram[history]++;

        history = state - series[i - k]*q;
    }
}

static void accumulate_local_observations(int const* series, size_t n,
    int b, size_t k, inform_dist *states, inform_dist *histories,
    int *state, int *history)
{
    int q = 1;
    history[0] = 0;
    for (size_t i = 0; i < k; ++i)
    {
        q *= b;
        history[0] *= b;
        history[0] += series[i];
    }
    for (size_t i = k; i < n; ++i)
    {
        size_t l = i - k;
        state[l]  = history[l] * b + series[i];

        states->histogram[state[l]]++;
        histories->histogram[history[l]]++;

        if (i + 1 != n)
        {
            history[l + 1] = state[l] - series[l]*q;
        }
    }
}

static bool check_arguments(int const *series, size_t n, size_t m, int b, size_t k, inform_error *err)
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

double inform_entropy_rate(int const *series, size_t n, size_t m, int b,
    size_t k, inform_error *err)
{
    if (check_arguments(series, n, m, b, k, err)) return NAN;

    size_t const N = n * (m - k);

    size_t const states_size = (size_t) (b * pow((double) b, (double) k));
    size_t const histories_size = states_size / b;
    size_t const total_size = states_size + histories_size;

    uint32_t *data = calloc(total_size, sizeof(uint32_t));
    if (data == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NAN);
    }

    inform_dist states    = { data, states_size, N };
    inform_dist histories = { data + states_size, histories_size, N };

    for (size_t i = 0; i < n; ++i, series += m)
    {
        accumulate_observations(series, m, b, k, &states, &histories);
    }

    double er = inform_shannon_ce(&states, &histories, (double) b);

    free(data);

    return er;
}

double *inform_local_entropy_rate(int const *series, size_t n, size_t m, int b,
    size_t k, double *er, inform_error *err)
{
    if (check_arguments(series, n, m, b, k, err)) return NULL;

    size_t const N = n * (m - k);

    if (er == NULL)
    {
        er = malloc(N * sizeof(double));
        if (er == NULL)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
    }

    size_t const states_size = (size_t) (b * pow((double) b, (double) k));
    size_t const histories_size = states_size / b;
    size_t const total_size = states_size + histories_size;

    uint32_t *data = calloc(total_size, sizeof(uint32_t));
    if (data == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    inform_dist states    = { data, states_size, N };
    inform_dist histories = { data + states_size, histories_size, N };

    int *state = malloc(N * sizeof(uint64_t));
    if (state == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    int *history = malloc(N * sizeof(uint64_t));
    if (history == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    int const *series_ptr = series;
    int *state_ptr = state, *history_ptr = history;
    for (size_t i = 0; i < n; ++i)
    {
        accumulate_local_observations(series_ptr, m, b, k, &states, &histories, state_ptr, history_ptr);
        series_ptr += m;
        state_ptr += (m - k);
        history_ptr += (m - k);
    }

    for (size_t i = 0; i < N; ++i)
    {
        er[i] = inform_shannon_pce(&states, &histories, state[i], history[i], (double) b);
    }

    free(history);
    free(state);
    free(data);

    return er;
}
