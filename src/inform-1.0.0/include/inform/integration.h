// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#pragma once

#include <inform/error.h>

#ifdef __cplusplus
extern "C"
{
#endif

/**
 * Compute the minimum and maximum evidence of integration for a collection of
 * time series.
 *
 * The first and second halves of the returned array contain the minimum and
 * maximum evidence, respectively.
 *
 * @param[in] series    the time series
 * @param[in] l         the number of time series
 * @param[in] n         the number of time steps per time series
 * @param[in] b         the bases of the time series
 * @param[out] evidence the computed evidence of integration
 * @param[out] err      an error code
 * @return the minimum and maximum evidience of integration
 */
EXPORT double *inform_integration_evidence(int const *series, size_t l,
    size_t n, int const *b, double *evidence, inform_error *err);

/**
 * Compute the minimum and maximum evidence of integration for a collection of
 * time series for a given partitioning.
 *
 * @param[in] series    the time series
 * @param[in] l         the number of time series
 * @param[in] n         the number of time steps per time series
 * @param[in] b         the bases of the time series
 * @param[in] parts     the partiitioning
 * @param[in] nparts    the number of partitions in the partitioning
 * @param[out] evidence the computed evidence of integration
 * @param[out] err      an error code
 * @return the evidience of integration
 */
EXPORT double *inform_integration_evidence_part(int const *series, size_t l,
    size_t n, int const *b, size_t const *parts, size_t nparts,
    double *evidence, inform_error *err);

#ifdef __cplusplus
}
#endif
