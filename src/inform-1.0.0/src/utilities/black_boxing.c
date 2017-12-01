// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/error.h>
#include <string.h>
#include <math.h>

#include <stdio.h>

static bool check_arguments(int const *series, size_t l, size_t n, size_t m,
    int const *b, size_t const *r, size_t const *s, inform_error *err)
{

    if (series == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, true);
    }
    else if (l == 0)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOSOURCES, true);
    }
    else if (n == 0)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOINITS, true);
    }
    else if (m == 0)
    {
        INFORM_ERROR_RETURN(err, INFORM_ESHORTSERIES, true);
    }
    else if (b == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_EBASE, true);
    }
    else if (r != NULL)
    {
        if (s != NULL)
        {
            for (size_t i = 0; i < l; ++i)
            {
                if (r[i] == 0 && s[i] == 0)
                    INFORM_ERROR_RETURN(err, INFORM_EKZERO, true);
                if (r[i] + s[i] > m)
                    INFORM_ERROR_RETURN(err, INFORM_EKLONG, true);
            }
        }
        else
        {
            for (size_t i = 0; i < l; ++i)
            {
                if (r[i] == 0)
                    INFORM_ERROR_RETURN(err, INFORM_EKZERO, true);
                if (r[i] > m)
                    INFORM_ERROR_RETURN(err, INFORM_EKLONG, true);
            }
        }
    }
    double bits = 0.0;
    if (r != NULL)
    {
        for (size_t i = 0; i < l; ++i)
        {
            if (b[i] < 2)
            {
                INFORM_ERROR_RETURN(err, INFORM_EBASE, true);
            }
            bits += r[i] * log2(b[i]);
        }
    }
    else
    {
        for (size_t i = 0; i < l; ++i)
        {
            if (b[i] < 2)
            {
                INFORM_ERROR_RETURN(err, INFORM_EBASE, true);
            }
            bits += log2(b[i]);
        }
    }
    if (s != NULL)
    {
        for (size_t i = 0; i < l; ++i)
        {
            bits += s[i] * log2(b[i]);
        }
    }
    if (bits > 30.0)
    {
        INFORM_ERROR_RETURN(err, INFORM_EENCODE, true);
    }
    for (size_t i = 0; i < l; ++i)
    {
        for (size_t j = 0; j < n * m; ++j)
        {
            if (series[n*m*i + j] < 0)
            {
                INFORM_ERROR_RETURN(err, INFORM_ENEGSTATE, true);
            }
            else if (series[n*m*i + j] >= b[i])
            {
                INFORM_ERROR_RETURN(err, INFORM_EBADSTATE, true);
            }
        }
    }

    return false;
}

static void compute_lengths(size_t const *r, size_t const *s, size_t l,
    size_t *max_r, size_t *max_s)
{
    *max_r = 1;
    *max_s = 0;
    if (r != NULL && s == NULL)
    {
        *max_s = 0;
        for (size_t i = 0; i < l; ++i)
            *max_r = (r[i] > *max_r) ? r[i] : *max_r;
    }
    else if (r == NULL && s != NULL)
    {
        *max_r = 1;
        for (size_t i = 0; i < l; ++i)
            *max_s = (s[i] > *max_s) ? s[i] : *max_s;
    }
    else if (r != NULL && s != NULL)
    {
        for (size_t i = 0; i < l; ++i)
        {
            *max_r = (r[i] > *max_r) ? r[i] : *max_r;
            *max_s = (s[i] > *max_s) ? s[i] : *max_s;
        }
    }
}

static void accumulate(int const *series, size_t l, size_t n, size_t m,
    int const *b, size_t const *r, size_t const *s, size_t max_r, size_t max_s,
    int *box, inform_error *err)
{
    int *data = malloc(2 * l * sizeof(int));
    if (data == NULL) INFORM_ERROR_RETURN_VOID(err, INFORM_ENOMEM);

    int *qs = data, *states = qs + l;
    size_t const w = m - max_r - max_s + 1;
    for (size_t i = 0; i < n * w; ++i) box[i] = 0;
    
    for (size_t i = 0; i < l; ++i)
    {
        for (size_t j = 0; j < n; ++j)
        {
            qs[i] = 1;
            states[i] = 0;
            for (size_t k = max_r - r[i]; k < max_r + s[i]; ++k)
            {
                qs[i] *= b[i];
                states[i] *= b[i];
                states[i] += series[k + m * (j + n * i)];
            }
            box[w * j] *= qs[i];
            box[w * j] += states[i];

            for (size_t k = max_r; k < m - max_s; ++k)
            {
                states[i] *= b[i];
                states[i] -= series[k - r[i] + m * (j + n * i)] * qs[i];
                states[i] += series[k + s[i] + m * (j + n * i)];
                box[k - max_r + 1 + w * j] *= qs[i];
                box[k - max_r + 1 + w * j] += states[i];
            }
        }
    }
        
    free(data);
}

int* inform_black_box(int const *series, size_t l, size_t n, size_t m,
    int const *b, size_t const *r, size_t const *s, int *box, inform_error *err)
{
    if (check_arguments(series, l, n, m, b, r, s, err))
    {
        return NULL;
    }
    size_t max_r, max_s;
    compute_lengths(r, s, l, &max_r, &max_s);

    bool allocate = (box == NULL);
    if (allocate)
    {
        box = calloc(n * (m - max_r - max_s + 1), sizeof(int));
        if (box == NULL)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
    }

    size_t *data = calloc(2 * l, sizeof(size_t));
    if (data == NULL)
    {
        if (allocate) free(box);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    size_t *history = data;
    if (r == NULL)
    {
        for (size_t i = 0; i < l; ++i) history[i] = 1;
    }
    else
    {
        memcpy(history, r, l * sizeof(size_t));
    }

    size_t *future = data + l;
    if (s != NULL)
    {
        memcpy(future, s, l * sizeof(size_t));
    }

    accumulate(series, l, n, m, b, history, future, max_r, max_s, box, err);

    if (inform_failed(err))
    {
        if (allocate) free(box);
        box = NULL;
    }
    free(data);
    return box;
}

static int compare_ints(void const *x, void const *y)
{
    int a = *(int const *)x;
    int b = *(int const *)y;
    return (a < b) ? -1 : (a > b) ? 1 : 0;
}

int *inform_black_box_parts(int const *series, size_t l, size_t n, int const *b,
    size_t const *parts, size_t nparts, int *box, inform_error *err)
{
    if (check_arguments(series, l, 1, n, b, NULL, NULL, err))
    {
        return NULL;
    }
    if (parts == NULL || nparts < 1)
    {
        INFORM_ERROR_RETURN(err, INFORM_EPARTS, NULL);
    }
    else
    {
        size_t *sorted_parts = malloc(l * sizeof(size_t));
        memcpy(sorted_parts, parts, l * sizeof(size_t));
        qsort(sorted_parts, l, sizeof(size_t), compare_ints);
        if (sorted_parts[0] != 0)
        {
            free(sorted_parts);
            INFORM_ERROR_RETURN(err, INFORM_EPARTS, NULL);
        }
        for (size_t i = 1; i < l; ++i)
        {
            int x = (int)(sorted_parts[i] - sorted_parts[i-1]);
            if (x != 0 && x != 1)
            {
                free(sorted_parts);
                INFORM_ERROR_RETURN(err, INFORM_EPARTS, NULL);
            }
        }
        if (sorted_parts[l-1] + 1 != nparts)
        {
            free(sorted_parts);
            INFORM_ERROR_RETURN(err, INFORM_EPARTS, NULL);
        }
        free(sorted_parts);
    }

    int allocate = (box == NULL);
    if (allocate)
    {
        box = malloc(nparts * (1 + n) * sizeof(int));
        if (box == NULL)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
    }

    int *partitioned = box;
    int *bases = partitioned + nparts * n;
    if (nparts == l)
    {
        memcpy(partitioned, series, l * n * sizeof(int));
        for (size_t i = 0; i < l; ++i) bases[i] = b[i];
    }
    else
    {
        size_t *members = malloc(l * sizeof(size_t));
        if (members == NULL)
        {
            if (allocate) free(box);
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
        for (size_t i = 0; i < l; ++i) members[i] = -1;

        for (size_t i = 0; i < nparts; ++i)
        {
            size_t k = 0;
            for (size_t j = 0; j < l; ++j)
            {
                if (parts[j] == i)
                {
                    members[k++] = j;
                }
            }

            if (k == 1)
            {
                memcpy(partitioned + n*i, series + n*members[0], n*sizeof(int));
                bases[i] = b[members[0]];
            }
            else
            {
                int *subbases = malloc(k * (1 + n) * sizeof(int));
                int *subseries = subbases + k;
                if (subseries == NULL)
                {
                    free(members);
                    if (allocate) free(box);
                    INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
                }
                bases[i] = 1;
                for (size_t j = 0; j < k; ++j)
                {
                    subbases[j] = b[members[j]];
                    bases[i] *= subbases[j];
                    for (size_t p = 0; p < n; ++p)
                    {
                        subseries[p + n*j] = series[p + n*members[j]];
                    }
                }
                inform_black_box(subseries, k, 1, n, subbases, NULL, NULL,
                    partitioned + n*i, err);
                free(subbases);
                if (inform_failed(err))
                {
                    free(members);
                    if (allocate) free(box);
                    return NULL;
                }
            }
            for (size_t i = 0; i < l; ++i) members[i] = -1;
        }
        free(members);
    }
    return box;
}