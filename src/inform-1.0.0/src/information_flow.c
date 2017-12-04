// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/dist.h>
#include <inform/information_flow.h>
#include <inform/mutual_info.h>
#include <inform/utilities/black_boxing.h>
#include <math.h>

static void accumulate_observations(int const *src, int const *dst,
    int const *back, size_t l_src, size_t l_dst, size_t l_back,
    size_t n, size_t m, int b, inform_dist *joint, inform_dist *as,
    inform_dist *bs, inform_dist *s)
{
    int const qs = s->size, qbs = bs->size;
    for (size_t i = 0; i < n; ++i)
    {
        for (size_t j = 0; j < m; ++j)
        {
            int a_state = 0, b_state = 0, s_state = 0;
            for (size_t k = 0; k < l_src; ++k)
            {
                a_state *= b;
                a_state += src[j + i * m + k * n * m];
            }
            for (size_t k = 0; k < l_dst; ++k)
            {
                b_state *= b;
                b_state += dst[j + i * m + k * n * m];
            }
            for (size_t k = 0; k < l_back; ++k)
            {
                s_state *= b;
                s_state += back[j + i * m + k * n * m];
            }

            int as_state = a_state * qs + s_state;
            int bs_state = b_state * qs + s_state;
            int joint_state = a_state * qbs + bs_state;

            joint->histogram[joint_state]++;
            as->histogram[as_state]++;
            bs->histogram[bs_state]++;
            s->histogram[s_state]++;
        }
    }
}

static bool check_arguments(int const *src, int const *dst, int const *back,
    size_t l_src, size_t l_dst, size_t l_back, size_t n, size_t m, int b,
    inform_error *err)
{
    if (src == NULL || l_src == 0)
    {
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, true);
    }
    else if (dst == NULL || l_dst == 0)
    {
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, true);
    }
    else if (back == NULL && l_back != 0)
    {
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, true);
    }
    else if (n < 1)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOINITS, true);
    }
    else if (m < 1)
    {
        INFORM_ERROR_RETURN(err, INFORM_ESHORTSERIES, true);
    }
    else if (b < 2)
    {
        INFORM_ERROR_RETURN(err, INFORM_EBASE, true);
    }
    for (size_t i = 0; i < l_src * n * m; ++i)
    {
        if (b <= src[i])
        {
            INFORM_ERROR_RETURN(err, INFORM_EBADSTATE, true);
        }
        else if (src[i] < 0)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENEGSTATE, true);
        }
    }
    for (size_t i = 0; i < l_dst * n * m; ++i)
    {
        if (b <= dst[i])
        {
            INFORM_ERROR_RETURN(err, INFORM_EBADSTATE, true);
        }
        else if (dst[i] < 0)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENEGSTATE, true);
        }
    }
    if (back != NULL)
    {
        for (size_t i = 0; i < l_back * n * m; ++i)
        {
            if (b <= back[i])
            {
                INFORM_ERROR_RETURN(err, INFORM_EBADSTATE, true);
            }
            else if (back[i] < 0)
            {
                INFORM_ERROR_RETURN(err, INFORM_ENEGSTATE, true);
            }
        }
    }
    return false;
}

static double mutual_info(int const *src, int const *dst, size_t l_src,
    size_t l_dst, size_t n, size_t m, int b, inform_error *err)
{
    size_t const N = n * m;

    int *data = malloc((2 * N + l_src + l_dst) * sizeof(int));
    if (data == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NAN);
    }

    int b_src = 1;
    for (size_t i = 0; i < l_src; ++i)
    {
        b_src *= b;
        data[2 * N + i] = b;
    }

    int b_dst = 1;
    for (size_t i = 0; i < l_dst; ++i)
    {
        b_dst *= b;
        data[2 * N + l_src + i] = b;
    }

    inform_black_box(src, l_src, n, m, data + 2 * N, NULL, NULL, data, err);
    if (inform_failed(err))
    {
        return NAN;
    }

    inform_black_box(dst, l_dst, n, m, data + 2 * N + l_src, NULL, NULL, data + N, err);
    if (inform_failed(err))
    {
        return NAN;
    }

    double mi = inform_mutual_info(data, 2, N, (int[2]){ b_src, b_dst }, err);

    free(data);

    return mi;
}

double inform_information_flow(int const *src, int const *dst, int const *back,
    size_t l_src, size_t l_dst, size_t l_back, size_t n, size_t m, int b,
    inform_error *err)
{
    if (check_arguments(src, dst, back, l_src, l_dst, l_back, n, m, b, err))
    {
        return NAN;
    }

    if (back == NULL || l_back == 0)
    {
        return mutual_info(src, dst, l_src, l_dst, n, m, b, err);
    }

    size_t const N = n * m;

    size_t const a_size = pow((double) b, (double) l_src);
    size_t const b_size = pow((double) b, (double) l_dst);
    size_t const s_size = pow((double) b, (double) l_back);

    size_t const joint_size = a_size * b_size * s_size;
    size_t const as_size = a_size * s_size;
    size_t const bs_size = b_size * s_size;

    size_t const total_size = joint_size + as_size + bs_size + s_size;

    uint32_t *data = calloc(total_size, sizeof(uint32_t));
    if (data == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NAN);
    }

    inform_dist joint = { data, joint_size, N };
    inform_dist as    = { data + joint_size, as_size, N };
    inform_dist bs    = { data + joint_size + as_size, bs_size, N };
    inform_dist s     = { data + joint_size + as_size + bs_size, s_size, N };

    accumulate_observations(src, dst, back, l_src, l_dst, l_back, n, m, b,
        &joint, &as, &bs, &s);

    double flow = 0.0;
    int bs_state, as_state, joint_state;
    double ns, nbs, nas, njoint;
    for (int s_state = 0; s_state < (int) s_size; ++s_state)
    {
        ns = s.histogram[s_state];
        if (ns == 0)
        {
            continue;
        }
        for (int b_state = 0; b_state < (int) b_size; ++b_state)
        {
            bs_state = b_state * s_size + s_state;
            nbs = bs.histogram[bs_state];
            if (nbs == 0)
            {
                continue;
            }
            for (int a_state = 0; a_state < (int) a_size; ++a_state)
            {
                as_state = a_state * s_size + s_state;
                nas = as.histogram[as_state];
                if (nas == 0)
                {
                    continue;
                }
                joint_state = a_state * bs_size + bs_state;
                njoint = joint.histogram[joint_state];
                if (njoint == 0)
                {
                    continue;
                }
                flow += njoint * log2((njoint * ns) / (nas * nbs));
            }
        }
    }

    free(data);

    return flow / N;
}
