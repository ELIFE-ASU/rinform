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
 * Compute the effective information of an intervention for a given transition
 * probability matrix.
 *
 * If the provided intervention is @c NULL, the uniform distribution is assumed.
 *
 * @param[in] tpm   the transition probability matrix
 * @param[in] inter the intervention distribution
 * @param[in] n     the number of states in the system
 * @return the effective information of the intervention
 */
EXPORT double inform_effective_info(double const *tpm, double const *inter,
    size_t n, inform_error *err);

#ifdef __cplusplus
}
#endif
