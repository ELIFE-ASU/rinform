// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/excess_entropy.h>
#include <inform/predictive_info.h>
#include <inform/shannon.h>

double inform_excess_entropy(int const *series, size_t n, size_t m, int b,
    size_t k, inform_error *err)
{
    return inform_predictive_info(series, n, m, b, k, k, err);
}

double *inform_local_excess_entropy(int const *series, size_t n, size_t m,
    int b, size_t k, double *ee, inform_error *err)
{
    return inform_local_predictive_info(series, n, m, b, k, k, ee, err);
}
