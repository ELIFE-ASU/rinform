// Copyright 2016 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/shannon.h>
#include <inform/transfer_entropy.h>
#include <string.h>

static void accumulate_observations(int const *series_y, int const *series_x,
     size_t n, int b, size_t k, inform_dist *states,
     inform_dist *histories, inform_dist *sources, inform_dist *predicates)
{
    int history = 0, q = 1, y_state, future, state, source, predicate;
    for (size_t i = 0; i < k; ++i)
    {
        q *= b;
        history *= b;
        history += series_x[i];
    }
    for (size_t i = k; i < n; ++i)
    {
        y_state   = series_y[i-1];
        future    = series_x[i];
        state     = (history * b + future) * b + y_state;
        source    = history * b + y_state;
        predicate = history * b + future;

        states->histogram[state]++;
        histories->histogram[history]++;
        sources->histogram[source]++;
        predicates->histogram[predicate]++;

        history = predicate - series_x[i - k]*q;
    }
}

static void accumulate_local_observations(int const *series_y,
    int const *series_x, size_t n, int b, size_t k,
    inform_dist *states, inform_dist *histories, inform_dist *sources,
    inform_dist *predicates, int *state, int *history,
    int *source, int *predicate)
{
    history[0] = 0;
    int q = 1;
    for (size_t i = 0; i < k; ++i)
    {
        q *= b;
        history[0] *= b;
        history[0] += series_x[i];
    }
    for (size_t i = k; i < n; ++i)
    {
        size_t l = i - k;
        int y_state   = series_y[i-1];
        int future    = series_x[i];
        predicate[l]  = history[l] * b + future;
        state[l]      = predicate[l] * b + y_state;
        source[l]     = history[l] * b + y_state;

        states->histogram[state[l]]++;
        histories->histogram[history[l]]++;
        sources->histogram[source[l]]++;
        predicates->histogram[predicate[l]]++;

        if (i + 1 != n)
        {
            history[l + 1] = predicate[l] - series_x[l]*q;
        }
    }
}

static bool check_arguments(int const *node_y, int const *node_x,
    size_t n, size_t m, int b, size_t k, inform_error *err)
{
    if (node_y == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, true);
    }
    else if (node_x == NULL)
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
    else if (m <= k)
    {
        INFORM_ERROR_RETURN(err, INFORM_EKLONG, true);
    }
    else if (k == 0)
    {
        INFORM_ERROR_RETURN(err, INFORM_EKZERO, true);
    }
    for (size_t i = 0; i < n * m; ++i)
    {
        if (b <= node_y[i] || b <= node_x[i])
        {
            INFORM_ERROR_RETURN(err, INFORM_EBADSTATE, true);
        }
        else if (node_y[i] < 0 || node_x[i] < 0)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENEGSTATE, true);
        }
    }
    return false;
}

double inform_transfer_entropy(int const *node_y, int const *node_x, size_t n,
    size_t m, int b, size_t k, inform_error *err)
{
    if (check_arguments(node_y, node_x, n, m, b, k, err)) return NAN;

    size_t const N = n * (m - k);

    size_t const q = (size_t) pow((double) b, (double) k);
    size_t const states_size     = b*b*q;
    size_t const histories_size  = q;
    size_t const sources_size    = b*q;
    size_t const predicates_size = b*q;
    size_t const total_size = states_size + histories_size + sources_size + predicates_size;

    uint32_t *data = calloc(total_size, sizeof(uint32_t));
    if (data == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NAN);
    }

    inform_dist states     = { data, states_size, N };
    inform_dist histories  = { data + states_size, histories_size, N };
    inform_dist sources    = { data + states_size + histories_size, sources_size, N };
    inform_dist predicates = { data + states_size + histories_size + sources_size, predicates_size, N };

    for (size_t i = 0; i < n; ++i, node_x += m, node_y += m)
    {
        accumulate_observations(node_y, node_x, m, b, k, &states, &histories, &sources, &predicates);
    }

    double te = inform_shannon(&sources, (double) b) +
        inform_shannon(&predicates, (double) b) -
        inform_shannon(&states, (double) b) -
        inform_shannon(&histories, (double) b);

    free(data);

    return te;
}

double *inform_local_transfer_entropy(int const *node_y, int const *node_x,
    size_t n, size_t m, int b, size_t k, double *te, inform_error *err)
{
    if (check_arguments(node_y, node_x, n, m, b, k, err)) return NULL;

    size_t const N = n * (m - k);

    if (te == NULL)
    {
        te = malloc(N * sizeof(double));
        if (te == NULL)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
    }

    size_t const q = (size_t) pow((double) b, (double) k);
    size_t const states_size     = b*b*q;
    size_t const histories_size  = q;
    size_t const sources_size    = b*q;
    size_t const predicates_size = b*q;
    size_t const total_size = states_size + histories_size + sources_size + predicates_size;

    uint32_t *data = calloc(total_size, sizeof(uint32_t));
    if (data == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    inform_dist states     = { data, states_size, N };
    inform_dist histories  = { data + states_size, histories_size, N };
    inform_dist sources    = { data + states_size + histories_size, sources_size, N };
    inform_dist predicates = { data + states_size + histories_size + sources_size, predicates_size, N };

    int *state      = malloc(N * sizeof(int));
    if (state == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    int *history    = malloc(N * sizeof(int));
    if (history == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    int *source     = malloc(N * sizeof(int));
    if (source == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    int *predicate  = malloc(N * sizeof(int));
    if (predicate == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    int const *node_y_ptr = node_y, *node_x_ptr = node_x;
    int *state_ptr = state, *source_ptr = source, *history_ptr = history, *predicate_ptr = predicate;
    for (size_t i = 0; i < n; ++i)
    {
        accumulate_local_observations(node_y_ptr, node_x_ptr, m, b, k, &states,
            &histories, &sources, &predicates, state_ptr, history_ptr,
            source_ptr, predicate_ptr);
        node_y_ptr += m;
        node_x_ptr += m;
        state_ptr += (m - k);
        history_ptr += (m - k);
        source_ptr += (m - k);
        predicate_ptr += (m - k);
    }

    for (size_t i = 0; i < N; ++i)
    {
        te[i] = inform_shannon_pcmi(&states, &sources, &predicates, &histories,
            state[i], source[i], predicate[i], history[i], (double) b);
    }

    free(predicate);
    free(source);
    free(history);
    free(state);
    free(data);

    return te;
}


/******************************************************************************/
/******************************************************************************/
static void accumulate_local_observations2(int const *series_y,
    int const *series_x, size_t n, size_t m, size_t t, int b, size_t k,
    inform_dist *states, inform_dist *histories, inform_dist *sources,
    inform_dist *predicates, int *state, int *history,
    int *source, int *predicate)
{
    // n, number of timeseries
    // m, number of timesteps in a timeseries
    // t, timestep of history (i)
    
    size_t history_idx = t;
    size_t y_state_idx = t + k - 1;    
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
            history[i] += series_x[j];
        }
	
        int y_state   = series_y[y_state_idx];
        int future    = series_x[future_idx];
        predicate[i]  = history[i] * b + future;
        state[i]      = predicate[i] * b + y_state;
        source[i]     = history[i] * b + y_state;	

        // Add observation
        states->histogram[state[i]]++;
        histories->histogram[history[i]]++;
        sources->histogram[source[i]]++;
        predicates->histogram[predicate[i]]++;
	
        // Update indexes
	history_idx += m;
	y_state_idx += m;
	future_idx  += m;	
    }
}

double *inform_local_transfer_entropy2(int const *node_y, int const *node_x,
    size_t n, size_t m, int b, size_t k, double *te, inform_error *err)
{
    if (check_arguments(node_y, node_x, n, m, b, k, err)) return NULL;

    size_t const N = n * (m - k);

    if (te == NULL)
    {
        te = malloc(N * sizeof(double));
        if (te == NULL)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
    }

    size_t const q = (size_t) pow((double) b, (double) k);
    size_t const states_size     = b*b*q;
    size_t const histories_size  = q;
    size_t const sources_size    = b*q;
    size_t const predicates_size = b*q;
    size_t const total_size = states_size + histories_size + sources_size + predicates_size;

    uint32_t *data = calloc(total_size, sizeof(uint32_t));
    if (data == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    inform_dist states     = { data, states_size, n };
    inform_dist histories  = { data + states_size, histories_size, n };
    inform_dist sources    = { data + states_size + histories_size, sources_size, n };
    inform_dist predicates = { data + states_size + histories_size + sources_size, predicates_size, n };

    int *state      = malloc(n * sizeof(int));
    if (state == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    int *history    = malloc(n * sizeof(int));
    if (history == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    int *source     = malloc(n * sizeof(int));
    if (source == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    int *predicate  = malloc(n * sizeof(int));
    if (predicate == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }


    for (size_t i = 0; i < m-k; ++i)
    {
        accumulate_local_observations2(node_y, node_x, n, m, i, b, k, &states,
            &histories, &sources, &predicates, state, history,
            source, predicate);
		
	for (size_t h = 0; h < n; ++h)
	{
	    te[i+h*(m-k)] = inform_shannon_pcmi(&states, &sources, &predicates, &histories,
						state[h], source[h], predicate[h], history[h],
						(double) b);
	}
	
	memset(data, 0, total_size * sizeof(uint32_t));		
    }    
    
    free(predicate);
    free(source);
    free(history);
    free(state);
    free(data);

    return te;
}
