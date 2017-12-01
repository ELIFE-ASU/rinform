// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#pragma once

#include <inform/export.h>
#include <stdbool.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C"
{
#endif

/**
 * Error tags to be used in conjunction with `inform_error`
 */
typedef enum
{
    INFORM_SUCCESS      =  0, /// no error occurred
    INFORM_FAILURE      = -1, /// an unspecified error occurred
    INFORM_EFAULT       =  1, /// invalid pointer
    INFORM_EARG         =  2, /// invalid argument
    INFORM_ENOMEM       =  3, /// malloc/calloc/realloc failed
    INFORM_ETIMESERIES  =  4, /// time series is NULL
    INFORM_ENOSOURCES   =  5, /// timeseries has no sources
    INFORM_ENOINITS     =  6, /// time series has no initial conditions
    INFORM_ESHORTSERIES =  7, /// time series has less than two timesteps
    INFORM_EKZERO       =  8, /// history length is zero
    INFORM_EKLONG       =  9, /// history is too long for the time series
    INFORM_EBASE        = 10, /// the provided base is invalid
    INFORM_ENEGSTATE    = 11, /// time series has negative state
    INFORM_EBADSTATE    = 12, /// time series has states inconsistent with expected base
    INFORM_EDIST        = 13, /// invalid distribution
    INFORM_EBIN         = 14, /// invalid binning
    INFORM_EENCODE      = 15, /// cannot encode state
    INFORM_ETPM         = 16, /// invalid TPM
    INFORM_ETPMROW      = 17, /// all zero row in transition probability matrix
    INFORM_ESIZE        = 18, /// invalid size,
    INFORM_EPARTS       = 19, /// invalid partitioning
} inform_error;

/// set an error as pointed to by ERR
#define INFORM_ERROR(ERR, TAG) do {\
        if ((ERR) != NULL) {\
            *(ERR) = (inform_error) TAG;\
        }\
    } while(0)

/// set an error and return a result
#define INFORM_ERROR_RETURN(ERR, TAG, RET) do {\
        INFORM_ERROR(ERR, TAG); \
        return RET; \
    } while(0)

/// set an error and return a void result
#define INFORM_ERROR_RETURN_VOID(ERR, TAG) do {\
        INFORM_ERROR(ERR, TAG); \
        return; \
    } while(0)

/**
 * Determine if an error code signifies a success.
 *
 * @param[in] err a pointer to an error code
 * @return `true` if the error is success, and `false` otherwise
 */
EXPORT bool inform_succeeded(inform_error const *err);

/**
 * Determine if an error code signifies a failure.
 *
 * @param[in] err a pointer to an error code
 * @return `true` if the error is not success, and `false` otherwise
 */
EXPORT bool inform_failed(inform_error const *err);

/**
 * Provide a string describing an error code.
 * 
 * @param[in] err a pointer to an error code
 * @return a descrptive string
 */
EXPORT char const *inform_strerror(inform_error const *err);

#ifdef __cplusplus
}
#endif
