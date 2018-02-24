// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#pragma once

#include <inform/error.h>

#ifdef __cplusplus
extern "C"
{
#endif

typedef struct inform_pid_source
{
    size_t *name;
    struct inform_pid_source **above;
    struct inform_pid_source **below;
    size_t size, n_above, n_below;
    double imin;
    double pi;
} inform_pid_source;

typedef struct inform_pid_lattice
{
    inform_pid_source **sources;
    inform_pid_source *top;
    inform_pid_source *bottom;
    size_t size;
} inform_pid_lattice;

EXPORT void inform_pid_lattice_free(inform_pid_lattice *l);

EXPORT inform_pid_lattice *inform_pid(int const *stimulus, int const *responses, size_t l,
        size_t n, int bs, int const *br, inform_error *err);

#ifdef __cplusplus
}
#endif
