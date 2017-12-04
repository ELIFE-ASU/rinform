// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.

#include <stdlib.h>
#include <inform/utilities/partitions.h>

size_t *inform_first_partitioning(size_t size)
{
    return (size > 0) ? calloc(size, sizeof(size_t)) : NULL;
}

size_t inform_next_partitioning(size_t *xs, size_t size)
{
    size_t n = 0;
    if (size > 1)
    {
        size_t *first = xs;
        size_t *last  = first + size;
        for (size_t *it = last - 1; it != first; --it)
        {
            if (*it < size - 1)
            {
                for (size_t *jt = it - 1; jt != first - 1; --jt)
                {
                    if (*jt == *it)
                    {
                        *it += 1;
                        for (size_t *kt = it + 1; kt != last; ++kt)
                        {
                            *kt = 0;
                        }
                        for (size_t i = 0; i < size; ++i)
                        {
                            n = (xs[i]+1 > n) ? xs[i]+1 : n;
                        }
                        return n;
                    }
                }
            }
        }
    }
    return n;
}