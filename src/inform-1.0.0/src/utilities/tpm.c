// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/error.h>

inline static bool check_arguments(int const *series, size_t n, size_t m, int b, 
    inform_error *err)
{
    if (series == NULL)
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, true);
    else if (n == 0)
        INFORM_ERROR_RETURN(err, INFORM_ENOINITS, true);
    else if (m <= 1)
        INFORM_ERROR_RETURN(err, INFORM_ESHORTSERIES, true);
    else if (b < 2)
        INFORM_ERROR_RETURN(err, INFORM_EBIN, true);
    for (size_t i = 0; i < n * m; ++i)
    {
        if (series[i] < 0)
            INFORM_ERROR_RETURN(err, INFORM_ENEGSTATE, true);
        else if (b <= series[i])
            INFORM_ERROR_RETURN(err, INFORM_EBADSTATE, true);
    }
    return false;
}

inline static double *setup_tpm(double *tpm, int b, inform_error *err)
{
    if (tpm == NULL)
    {
        tpm = calloc(b * b, sizeof(double));
        if (tpm == NULL)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
    }
    else
    {
        for (size_t i = 0; i < (size_t)(b * b); ++i)
        {
            tpm[i] = 0.0;
        }
    }
    return tpm;
}

double *inform_tpm(int const *series, size_t n, size_t m, int b, double *tpm,
    inform_error *err)
{
    if (check_arguments(series, n, m, b, err))
        return NULL;

    if ((tpm = setup_tpm(tpm, b, err)) == NULL)
        return NULL;

    int current = 0, future = 0;
    for (size_t i = 0; i < n; ++i)
    {
        for (size_t j = 0; j < m - 1; ++j)
        {
            current = series[m * i + j];
            future = series[m * i + j + 1];
            tpm[b * current + future] += 1;
        }
    }

    for (int i = 0; i < b; ++i)
    {
        double sum = 0.0;
        for (int j = 0; j < b; ++j)
            sum += tpm[b * i + j];

        if (sum != 0.0)
        {
            for (int j = 0; j < b; ++j)
            {
                tpm[b * i + j] /= sum;
            }
        }
        else
        {
            INFORM_ERROR(err, INFORM_ETPMROW);
        }
    }

    return tpm;
}
