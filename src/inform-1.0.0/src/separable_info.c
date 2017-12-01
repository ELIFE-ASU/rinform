// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/active_info.h>
#include <inform/transfer_entropy.h>
#include <math.h>

double inform_separable_info(int const *srcs, int const *dest, size_t l,
    size_t n, size_t m, int b, size_t k, inform_error *err)
{
    if (l < 1) INFORM_ERROR_RETURN(err, INFORM_ENOSOURCES, NAN);

    double si = inform_active_info(dest, n, m, b, k, err);
    if (inform_failed(err)) return NAN;

    for (size_t i = 0; i < l; ++i, srcs += n*m)
    {
        si += inform_transfer_entropy(srcs, dest, NULL, 0, n, m, b, k, err);
        if (inform_failed(err)) return NAN;
    }

    return si;
}

double *inform_local_separable_info(int const *srcs, int const *dest,
    size_t l, size_t n, size_t m, int b, size_t k, double *si,
    inform_error *err)
{
    if (l < 1) INFORM_ERROR_RETURN(err, INFORM_ENOSOURCES, NULL);

    bool allocated_si = (si == NULL);

    si = inform_local_active_info(dest, n, m, b, k, si, err);
    if (inform_failed(err))
    {
        if (allocated_si) free(si);
        return NULL;
    }

    const size_t N = n * (m - k);
    double *te = malloc(n * (m - k) * sizeof(double));
    if (te == NULL)
    {
        if (allocated_si) free(si);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    for (size_t i = 0; i < l; ++i, srcs += n*m)
    {
        inform_local_transfer_entropy(srcs, dest, NULL, 0, n, m, b, k, te, err);
        if (inform_failed(err))
        {
            free(te);
            if (allocated_si) free(si);
            return NULL;
        }
        for (size_t j = 0; j < N; ++j) si[j] += te[j];
    }

    free(te);

    return si;
}
