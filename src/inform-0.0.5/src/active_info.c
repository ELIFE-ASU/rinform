// Copyright 2016 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/active_info.h>
#include <inform/shannon.h>
#include <string.h>


static void accumulate_observations(int const* series, size_t n, int b,
    size_t k, inform_dist *states, inform_dist *histories, inform_dist *futures)
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
        futures->histogram[future]++;

        history = state - series[i - k]*q;
    }
}

static void accumulate_local_observations(int const* series, size_t n, int b,
    size_t k, inform_dist *states, inform_dist *histories, inform_dist *futures,
    int *state, int *history, int *future)
{
    history[0] = 0;
    int q = 1;
    for (size_t i = 0; i < k; ++i)
    {
        q *= b;
        history[0] *= b;
        history[0] += series[i];
    }
    for (size_t i = k; i < n; ++i)
    {
        size_t l = i - k;
        future[l] = series[i];
        state[l] = history[l] * b + future[l];

        states->histogram[state[l]]++;
        histories->histogram[history[l]]++;
        futures->histogram[future[l]]++;

        if (i + 1 != n)
            history[l + 1] = state[l] - series[l]*q;
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

double inform_active_info(int const *series, size_t n, size_t m, int b, size_t k, inform_error *err)
{
    if (check_arguments(series, n, m, b, k, err)) return NAN;

    size_t const N = n * (m - k);

    size_t const states_size = (size_t) (b * pow((double) b,(double) k));
    size_t const histories_size = states_size / b;
    size_t const futures_size = b;
    size_t const total_size = states_size + histories_size + futures_size;

    uint32_t *data = calloc(total_size, sizeof(uint32_t));
    if (data == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NAN);
    }

    inform_dist states    = { data, states_size, N };
    inform_dist histories = { data + states_size, histories_size, N };
    inform_dist futures   = { data + states_size + histories_size, futures_size, N };

    for (size_t i = 0; i < n; ++i, series += m)
    {
        accumulate_observations(series, m, b, k, &states, &histories, &futures);
    }

    double ai = inform_shannon_mi(&states, &histories, &futures, (double) b);

    free(data);

    return ai;
}

double *inform_local_active_info(int const *series, size_t n, size_t m,
    int b, size_t k, double *ai, inform_error *err)
{
    if (check_arguments(series, n, m, b, k, err)) return NULL;

    size_t const N = n * (m - k);

    if (ai == NULL)
    {
        ai = malloc(N * sizeof(double));
        if (ai == NULL)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
    }

    size_t const states_size = (size_t) (b*pow((double) b,(double) k));
    size_t const histories_size = states_size / b;
    size_t const futures_size = b;
    size_t const total_size = states_size + histories_size + futures_size;

    uint32_t *data = calloc(total_size, sizeof(uint32_t));
    if (data == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    inform_dist states    = { data, states_size, N };
    inform_dist histories = { data + states_size, histories_size, N };
    inform_dist futures   = { data + states_size + histories_size, futures_size, N };

    int *state   = malloc(N * sizeof(int));
    if (state == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    int *history = malloc(N * sizeof(int));
    if (history == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    int *future  = malloc(N * sizeof(int));
    if (future == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    int const *series_ptr = series;
    int *state_ptr = state, *history_ptr = history, *future_ptr = future;
    for (size_t i = 0; i < n; ++i)
    {
        accumulate_local_observations(series_ptr, m, b, k, &states, &histories,
            &futures, state_ptr, history_ptr, future_ptr);
        series_ptr += m;
        state_ptr += (m - k);
        history_ptr += (m - k);
        future_ptr += (m - k);
    }

    for (size_t i = 0; i < N; ++i)
    {
        ai[i] = inform_shannon_pmi(&states, &histories, &futures, state[i],
            history[i], future[i], (double) b);
    }

    free(future);
    free(history);
    free(state);
    free(data);

    return ai;
}


/******************************************************************************/
/******************************************************************************/
static void accumulate_local_observations2(int const* series, size_t n, size_t m, size_t t, int b,
    size_t k, inform_dist *states, inform_dist *histories, inform_dist *futures,
    int *state, int *history, int *future)
{
    // n, number of timeseries
    // m, number of timesteps in a timeseries
    // t, timestep of history (i)
  
    size_t history_idx = t;
    size_t future_idx = t + k;
    int q = 1;    
    for (size_t i = 0; i <n; ++i)
    {      
        // Compute history
        history[i] = 0;
        q = 1;
        for (size_t j = history_idx; j < history_idx + k; ++j)
        {
            q *= b;
            history[i] *= b;
            history[i] += series[j];
        }
	future[i] = series[future_idx];
	state[i] = history[i] * b + future[i];

        // Add observation
        states->histogram[state[i]]++;
        histories->histogram[history[i]]++;
        futures->histogram[future[i]]++;

        // Update indexes
	history_idx += m;
	future_idx  += m;	
    }
}

double *inform_local_active_info2(int const *series, size_t n, size_t m,
    int b, size_t k, double *ai, inform_error *err)
{
    
    if (check_arguments(series, n, m, b, k, err)) return NULL;

    size_t const N = n * (m - k);

    if (ai == NULL)
    {
        ai = malloc(N * sizeof(double));
        if (ai == NULL)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
    }

    size_t const states_size = (size_t) (b*pow((double) b,(double) k));
    size_t const histories_size = states_size / b;
    size_t const futures_size = b;
    size_t const total_size = states_size + histories_size + futures_size;

    uint32_t *data = calloc(total_size, sizeof(uint32_t));
    if (data == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    inform_dist states    = { data, states_size, n };
    inform_dist histories = { data + states_size, histories_size, n };
    inform_dist futures   = { data + states_size + histories_size, futures_size, n };

    int *state   = malloc(n * sizeof(int));
    if (state == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    int *history = malloc(n * sizeof(int));
    if (history == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    int *future  = malloc(n * sizeof(int));
    if (future == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    for (size_t i = 0; i < m-k; ++i)
    {
        accumulate_local_observations2(series, n, m, i, b, k, &states, &histories,
            &futures, state, history, future);

	for (size_t h = 0; h < n; ++h)
	{
	    ai[i+h*(m-k)] = inform_shannon_pmi(&states, &histories, &futures, state[h],
                history[h], future[h], (double) b);
	}
	
	memset(data, 0, total_size * sizeof(uint32_t));		
    }

    free(future);
    free(history);
    free(state);
    free(data);

    return ai;
}
