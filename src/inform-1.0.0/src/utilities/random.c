// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/utilities/random.h>
#include <stdlib.h>
#include <time.h>

void inform_random_seed()
{
    srand((unsigned int) time(NULL));
}

int inform_random_int(int a, int b)
{
    return a + (rand() % (b - a));
}

int *inform_random_ints(int a, int b, size_t n)
{
    int *xs = malloc(n * sizeof(int));
    if (xs == NULL)
        return NULL;
    for (size_t i = 0; i < n; ++i)
        xs[i] = inform_random_int(a, b);
    return xs;
}

int *inform_random_series(size_t n, int b)
{
    return inform_random_ints(0, b, n);
}