// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#pragma once

#include <inform/error.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C"
{
#endif

/**
 * Encode a base-`b` array of integers into a single integer.
 *
 * @param[in] state the state to encode
 * @param[in] n     the number of base-`b` terms in `states`
 * @param[in] b     the base of each terms
 * @param[out] err  the error code
 * @return the encoded state
 */
EXPORT int32_t inform_encode(int const *state, size_t n, int b,
    inform_error *err);

/**
 * Decode an integer into a base-`b` array of integers.
 *
 * @param[in] encoding the encoded state
 * @param[in] b        the base of the encoding
 * @param[out] state   the decoded state
 * @param[in] n        the maximum number of decoded base-`b` terms
 * @param[out]         the error code
 */
EXPORT void inform_decode(int32_t encoding, int b, int *state, size_t n,
    inform_error *err);

#ifdef __cplusplus
}
#endif
