// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/error.h>

bool inform_succeeded(inform_error const *err)
{
    return err == NULL || *err == INFORM_SUCCESS;
}

bool inform_failed(inform_error const *err)
{
    return !inform_succeeded(err);
}

char const *inform_strerror(inform_error const *err)
{
    if (err == NULL)
    {
        return "success";
    }
    switch (*err)
    {
        case INFORM_SUCCESS:      return "success";
        case INFORM_FAILURE:      return "generic failure";
        case INFORM_EFAULT:       return "invalid pointer encountered";
        case INFORM_EARG:         return "invalid argument provided";
        case INFORM_ENOMEM:       return "memory allocation failed";
        case INFORM_ETIMESERIES:  return "timeseries is NULL";
        case INFORM_ENOSOURCES:   return "timeseries has no sources";
        case INFORM_ENOINITS:     return "timeseries has no initial conditions";
        case INFORM_ESHORTSERIES: return "timeseries is too short";
        case INFORM_EKZERO:       return "history length is zero";
        case INFORM_EKLONG:       return "history length is too long";
        case INFORM_EBASE:        return "base is invalid";
        case INFORM_ENEGSTATE:    return "negative state in timeseries";
        case INFORM_EBADSTATE:    return "unexpected state in timeseries";
        case INFORM_EDIST:        return "invalid distribution encountered";
        case INFORM_EBIN:         return "invalid binning";
        case INFORM_EENCODE:      return "encoding/decoding failed";
        case INFORM_ETPM:         return "invalid TPM";
        case INFORM_ETPMROW:      return "all zero row in TPM";
        case INFORM_ESIZE:        return "invalid size";
        case INFORM_EPARTS:       return "invalid partitioning";
        default:                  return "unrecognized error";
    }
}
