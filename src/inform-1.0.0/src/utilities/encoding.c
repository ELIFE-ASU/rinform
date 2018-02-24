// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/utilities/encoding.h>
#include <math.h>

int32_t inform_encode(int const *state, size_t n, int b, inform_error *err)
{
    if (state == NULL || n == 0)
        INFORM_ERROR_RETURN(err, INFORM_EARG, -1);
    else if (b < 2)
        INFORM_ERROR_RETURN(err, INFORM_EBASE, -1);
    else if (n * log2(b) > 31)
        INFORM_ERROR_RETURN(err, INFORM_EENCODE, -1);

    int32_t encoding = 0;
    for (int32_t i = 0; i < (int32_t) n; ++i)
    {
        if (b <= state[i])
            INFORM_ERROR_RETURN(err, INFORM_EENCODE, -1);
        encoding *= b;
        encoding += state[i];
    }
    return encoding;
}

void inform_decode(int32_t encoding, int b, int *state, size_t n, inform_error *err)
{
    if (encoding < 0)
        INFORM_ERROR_RETURN_VOID(err, INFORM_EARG);
    else if (b < 2)
        INFORM_ERROR_RETURN_VOID(err, INFORM_EBASE);
    else if (state == NULL || n == 0)
        INFORM_ERROR_RETURN_VOID(err, INFORM_EARG);

    for (size_t i = 0; i < n; ++i, encoding /= b)
        state[n - i - 1] = encoding % b;

    if (encoding != 0)
        INFORM_ERROR_RETURN_VOID(err, INFORM_EENCODE);
}
