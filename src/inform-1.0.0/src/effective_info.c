// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/dist.h>
#include <inform/effective_info.h>
#include <math.h>

static inline double sum_row(double const *row, size_t n)
{
    double sum = 0.0;
    for (size_t i = 0; i < n; ++i)
    {
        if (row[i] < 0.0)
            return NAN;
        sum += row[i];
    }
    return sum;
}

static int check_arguments(double const *tpm, double const *inter, size_t n,
    inform_error *err)
{
    if (tpm == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ETPM, 1);
    }
    else if (n == 0)
    {
        INFORM_ERROR_RETURN(err, INFORM_ESIZE, 1);
    }

    for (double const *row = tpm; row < tpm + n*n; row += n)
    {
        double const sum = sum_row(row, n);
        if (isnan(sum))
        {
            INFORM_ERROR_RETURN(err, INFORM_ETPM, 1);
        }
        if (fabs(sum - 1.0) > 1e-6)
        {
            INFORM_ERROR_RETURN(err, INFORM_ETPM, 1);
        }
    }

    if (inter != NULL)
    {
        double const sum = sum_row(inter, n);
        if (isnan(sum))
        {
            INFORM_ERROR_RETURN(err, INFORM_EDIST, 1);
        }
        if (fabs(sum - 1.0) > 1e-6)
        {
            INFORM_ERROR_RETURN(err, INFORM_EDIST, 1);
        }
    }

    return 0;
}

static inline double kldivergence(double const *ps, double const *qs, size_t n)
{
    double kld = 0.0;
    for (size_t i = 0; i < n; ++i)
    {
        if (ps[i] != 0)
        {
            kld += ps[i] * log2(ps[i] / qs[i]);
        }
    }
    return kld;
}

double inform_effective_info(double const *tpm, double const *inter, size_t n,
    inform_error *err)
{
    if (check_arguments(tpm, inter, n, err))
    {
        return NAN;
    }

    // allocate enough memory for the ID and ED distributions
    double *data = calloc(2 * n, sizeof(double));
    if (data == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NAN);
    }

    // set the ID and ED pointers to pointer the right places
    double *ed = data;
    double const *id;
    if (inter != NULL)
    {
        id = inter;
    }
    else
    {
        // make the ID distribution uniform
        double const k = 1.0 / n;
        for (size_t i = 0; i < n; ++i) data[i + n] = k;
        id = (double const *) data + n;
    }

    // compute the ED given the ID and TPM
    for (size_t i = 0; i < n; ++i)
    {
        for (size_t j = 0; j < n; ++j)
        {
            ed[j] += id[i] * tpm[j + i*n];
        }
    }

    // and comput the effective information
    double ei = 0.0;
    for (double const *sf = tpm; sf != tpm + n*n; sf += n, ++id)
    {
        ei += (*id) * kldivergence(sf, ed, n);
    }

    free(data);

    return ei;
}
