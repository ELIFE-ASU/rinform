// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/utilities/coalesce.h>
#include <string.h>

static int compare_ints(void const *a, void const *b)
{
    int x = *(int const*)a;
    int y = *(int const*)b;
    if (x < y) return -1;
    if (y < x) return  1;
    return 0;
}

int inform_coalesce(int const *series, size_t n, int *coal, inform_error *err)
{
    if (series == NULL)
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, 0);
    else if (n == 0)
        INFORM_ERROR_RETURN(err, INFORM_ESHORTSERIES, 0);
    else if (coal == NULL)
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, 0);

    int *tmp = malloc(n * sizeof(int));
    if (tmp == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, 0);
    }
    memcpy(tmp, series, n * sizeof(int));
    qsort(tmp, n, sizeof(int), compare_ints);
    int b = 1;
    for (size_t i = 1; i < n; ++i)
    {
        if (tmp[i] != tmp[i-1]) ++b;
    }

    int *map = malloc(b * sizeof(int));
    if (map == NULL)
    {
        free(tmp);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, 0);
    }
    map[0] = tmp[0];
    for (size_t i = 1, j = 1; i < n; ++i)
    {
        if (tmp[i] != tmp[i-1]) map[j++] = tmp[i];
    }
    free(tmp);

    for (size_t i = 0; i < n; ++i)
    {
        int *x = bsearch(series + i, map, b, sizeof(int), compare_ints);
        if (x == NULL)
        {
            free(map);
            INFORM_ERROR_RETURN(err, INFORM_EBIN, 0);
        }
        coal[i] = (int) (x - map);
    }

    free(map);
    return b;
}