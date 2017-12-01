// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <assert.h>
#include <float.h>
#include <inform/utilities/binning.h>
#include <math.h>
#include <string.h>

double inform_range(double const *series, size_t n, double *min, double *max,
    inform_error *err)
{
    if (series == NULL)
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, 0.0);
    else if (n == 0)
        INFORM_ERROR_RETURN(err, INFORM_ESHORTSERIES, 0.0);

    double a = series[0], b = series[0];
    for (size_t i = 1; i < n; ++i)
    {
        if (series[i] < a) a = series[i];
        if (b < series[i]) b = series[i];
    }
    if (min != NULL) *min = a;
    if (max != NULL) *max = b;
    return (b - a);
}

double inform_bin(double const *series, size_t n, int b, int *binned,
    inform_error *err)
{
    if (series == NULL)
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, 0.0);
    else if (n == 0)
        INFORM_ERROR_RETURN(err, INFORM_ESHORTSERIES, 0.0);
    else if (b < 2)
        INFORM_ERROR_RETURN(err, INFORM_EBIN, 0.0);
    else if (binned == NULL)
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, 0.0);

    double min, max;
    double range = inform_range(series, n, &min, &max, err);
    double step = range / b;

    if (step <= 10.*DBL_EPSILON)
    {
        memset(binned, 0, n*sizeof(int));
        INFORM_ERROR_RETURN(err, INFORM_EBIN, step);
    }

    for (size_t i = 0; i < n; ++i)
    {
        binned[i] = (int) floor((series[i] - min) / step) - (series[i] == max);
        assert(0 <= binned[i] && binned[i] < b);
    }

    return step;
}

int inform_bin_step(double const *series, size_t n, double step, int *binned,
    inform_error *err)
{
    if (series == NULL)
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, 0);
    else if (n == 0)
        INFORM_ERROR_RETURN(err, INFORM_ESHORTSERIES, 0);
    else if (step <= 10.*DBL_EPSILON)
        INFORM_ERROR_RETURN(err, INFORM_EBIN, 0);
    else if (binned == NULL)
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, 0);

    double min, max;
    double range = inform_range(series, n, &min, &max, err);
    int b = (int) ceil(range / step);

    if (fmod(range,step) == 0.0) ++b;

    for (size_t i = 0; i < n; ++i)
    {
        binned[i] = (int) floor((series[i] - min) / step);
        assert(0 <= binned[i] && binned[i] < b);
    }

    return b;
}

int inform_bin_bounds(double const *series, size_t n, double const *bounds,
    size_t m, int *binned, inform_error *err)
{
    if (series == NULL)
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, 0);
    else if (n == 0)
        INFORM_ERROR_RETURN(err, INFORM_ESHORTSERIES, 0);
    else if (bounds == NULL || m == 0)
        INFORM_ERROR_RETURN(err, INFORM_EBIN, 0);
    else if (binned == NULL)
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, 0);

    int b = 0;
    for (size_t i = 0; i < n; ++i)
    {
        binned[i] = (int)m;
        for (int x = 0; x < (int)m; ++x)
        {
            if (series[i] < bounds[x])
            {
                binned[i] = x;
                break;
            }
        }
        b = (b < binned[i]) ? binned[i] : b;
    }

    return b + 1;
}
