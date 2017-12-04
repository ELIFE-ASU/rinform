// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <ginger/vector.h>
#include <inform/pid.h>
#include <inform/dist.h>
#include <inform/utilities.h>
#include <inform/utilities/black_boxing.h>
#include <inform/utilities/encoding.h>
#include <string.h>
#include <math.h>

#define FAILED(ERR) ((ERR) && *(ERR) != INFORM_SUCCESS)

#define MAKE_PUSH(NAME, TYPE) \
static TYPE* NAME(TYPE* xs, TYPE x) \
{ \
    if (!xs) \
    { \
        return xs; \
    } \
     \
    size_t cap = gvector_cap(xs); \
    if (gvector_len(xs) >= cap) \
    { \
        cap = (cap) ? 2*cap : 1; \
        TYPE* ys = gvector_reserve(xs, cap); \
        if (!ys) \
        { \
            return NULL; \
        } \
        xs = ys; \
    } \
    xs[gvector_len(xs)++] = x; \
    return xs; \
}

MAKE_PUSH(push_value, size_t)
MAKE_PUSH(push_source, inform_pid_source*)

static void free_source(inform_pid_source *src)
{
    if (src)
    {
        gvector_free(src->name);
        gvector_free(src->above);
        gvector_free(src->below);
        free(src);
    }
}

static void free_all_sources(inform_pid_source **srcs)
{
    if (srcs)
    {
        for (size_t i = 0; i < gvector_len(srcs); ++i)
        {
            free_source(srcs[i]);
        }
        gvector_free(srcs);
    }
}

static inform_pid_source *alloc_source(size_t *name,
        inform_error *err)
{
    if (!name)
    {
        INFORM_ERROR_RETURN(err, INFORM_EARG, NULL);
    }

    inform_pid_source *src = malloc(sizeof(inform_pid_source));
    if (!src)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    src->name = NULL;
    src->above = src->below = NULL;

    size_t *local_name = gvector_dup(name);
    if (!local_name)
    {
        free_source(src);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    src->name = local_name;

    local_name = gvector_shrink(src->name);
    if (!local_name)
    {
        free_source(src);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    src->name = local_name;
    src->size = gvector_len(src->name);

    src->above = gvector_alloc(0, 0, sizeof(inform_pid_source*));
    if (!src->above)
    {
        free_source(src);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    src->n_above = 0;

    src->below = gvector_alloc(0, 0, sizeof(inform_pid_source*));
    if (!src->below)
    {
        free_source(src);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    src->n_below = 0;

    src->imin = src->pi = 0.0;

    return src;
}

static inform_pid_source **sources_rec(size_t i, size_t m, size_t *c,
        inform_pid_source **srcs, inform_error *err)
{
    if (!c || !srcs)
    {
        INFORM_ERROR_RETURN(err, INFORM_EARG, NULL);
    }

    if (i < m)
    {
        size_t *d = gvector_dup(c);
        if (!d)
        {
            gvector_free(c);
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, srcs);
        }
        srcs = sources_rec(i + 1, m, d, srcs, err);
        if (FAILED(err))
        {
            gvector_free(c);
            return srcs;
        }
    }

    if (i <= m)
    {
        size_t z = 0;
        for (size_t j = 0; j < gvector_len(c); ++j)
        {
            z = i & c[j];
            if (z == i || z == c[j])
            {
                gvector_free(c);
                return srcs;
            }
        }

        size_t *d = push_value(c, i);
        if (!d)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, srcs);
        }
        c = d;

        inform_pid_source *src = alloc_source(c, err);
        if (FAILED(err))
        {
            gvector_free(c);
            return srcs;
        }

        inform_pid_source **ts = push_source(srcs, src);
        if (!ts)
        {
            free_source(src);
            gvector_free(c);
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, srcs);
        }
        srcs = ts;

        return sources_rec(i + 1, m, c, srcs, err);
    }
    else
    {
        gvector_free(c);
    }

    return srcs;
}

static inform_pid_source **sources(size_t n, inform_error *err)
{
    if (n < 1)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOSOURCES, NULL);
    }
    size_t const m = (1 << n) - 1;
    inform_pid_source **srcs = gvector_alloc(0, 0, sizeof(inform_pid_source*));
    if (!srcs)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    for (size_t i = 1; i <= m; ++i)
    {
        size_t *c = gvector_alloc(1, 1, sizeof(size_t));
        if (!c)
        {
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
        c[0] = i;

        inform_pid_source *src = alloc_source(c, err);
        if (FAILED(err))
        {
            gvector_free(c);
            return NULL;
        }

        inform_pid_source **ts = push_source(srcs, src);
        if (!ts)
        {
            free_source(src);
            free_all_sources(srcs);
            gvector_free(c);
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
        srcs = ts;

        srcs = sources_rec(i + 1, m, c, srcs, err);
        if (FAILED(err))
        {
            free_all_sources(srcs);
            return NULL;
        }
    }

    inform_pid_source **ts = gvector_shrink(srcs);
    if (!ts)
    {
        free_all_sources(srcs);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    return ts;
}

static bool name_below(size_t const *xs, size_t const *ys)
{
    size_t const m = gvector_len(xs);
    size_t const n = gvector_len(ys);

    bool is_below = true;
    for (size_t const *y = ys; y < ys + n && is_below; ++y)
    {
        bool is_valid = false;
        for (size_t const *x = xs; x < xs + m && !is_valid; ++x)
        {
            if ((*x & *y) == *x)
            {
                is_valid = true;
            }
        }
        if (!is_valid)
        {
            is_below = false;
        }
    }
    return is_below;
}

static bool below(inform_pid_source const *a, inform_pid_source const *b)
{
    return name_below(a->name, b->name);
}

static void toposort(inform_pid_source **srcs, inform_error *err)
{
    if (!srcs)
    {
        INFORM_ERROR_RETURN_VOID(err, INFORM_EARG);
    }
    size_t const n = gvector_len(srcs);
    size_t u = 0, v = 0;
    while (v < n - 1)
    {
        u = v;
        for (size_t i = u; i < n; ++i)
        {
            bool is_bottom = true;
            for (size_t j = u; j < n; ++j)
            {
                if (i != j && below(srcs[j], srcs[i]))
                {
                    is_bottom = false;
                    break;
                }
            }
            if (is_bottom)
            {
                inform_pid_source *tmp = srcs[v];
                srcs[v] = srcs[i];
                srcs[i] = tmp;
                v += 1;
            }
        }
    }
}

static inform_pid_lattice *inform_pid_lattice_alloc(inform_error *err)
{
    inform_pid_lattice *lattice = malloc(sizeof(inform_pid_lattice));
    if (!lattice)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    lattice->sources = NULL;
    lattice->top = NULL;
    lattice->bottom = NULL;

    return lattice;
}

void inform_pid_lattice_free(inform_pid_lattice *lattice)
{
    if (lattice)
    {
        free_all_sources(lattice->sources);

        lattice->sources = NULL;
        lattice->top = NULL;
        lattice->bottom = NULL;

        free(lattice);
    }
}

static inform_pid_lattice *build_hasse(inform_pid_source **srcs,
        inform_error *err)
{
    if (!srcs)
    {
        INFORM_ERROR_RETURN(err, INFORM_EARG, NULL);
    }

    size_t const n = gvector_len(srcs);
    if (n == 0)
    {
        INFORM_ERROR_RETURN(err, INFORM_EARG, NULL);
    }

    inform_pid_lattice *lattice = inform_pid_lattice_alloc(err);
    if (FAILED(err))
    {
        return NULL;
    }

    for (size_t i = 0; i < n; ++i)
    {
        for (size_t j = i + 1; j < n; ++j)
        {
            if (below(srcs[i], srcs[j]))
            {
                bool stop = false;
                for (size_t k = 0; k < gvector_len(srcs[i]->above); ++k)
                {
                    inform_pid_source *x = srcs[i]->above[k];
                    if (below(x, srcs[j]))
                    {
                        stop = true;
                        break;
                    }
                }
                if (stop)
                {
                    break;
                }
                else
                {
                    inform_pid_source **above, **below;

                    above = push_source(srcs[i]->above, srcs[j]);
                    if (!above)
                    {
                        free_all_sources(srcs);
                        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
                    }
                    srcs[i]->above = above;
                    srcs[i]->n_above++;

                    below = push_source(srcs[j]->below, srcs[i]);
                    if (!below)
                    {
                        free_all_sources(srcs);
                        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
                    }
                    srcs[j]->below = below;
                    srcs[j]->n_below++;
                }
            }
        }
    }

    lattice->sources = srcs;
    lattice->bottom = srcs[0];
    lattice->top = srcs[n-1];
    lattice->size = gvector_len(lattice->sources);

    return lattice;
}

static inform_pid_lattice *hasse(size_t n, inform_error *err)
{
    inform_pid_source **srcs = sources(n, err);
    if (FAILED(err))
    {
        return NULL;
    }

    toposort(srcs, err);
    if (FAILED(err))
    {
        return NULL;
    }

    inform_pid_lattice *lattice = build_hasse(srcs, err);
    if (FAILED(err))
    {
        return NULL;
    }
    return lattice;
}

static size_t **subsets(size_t n, inform_error *err)
{
    if (n < 1)
    {
        INFORM_ERROR_RETURN(err, INFORM_EARG, NULL);
    }
    size_t m = 1 << n;
    size_t **ss = gvector_alloc(m - 1, m - 1, sizeof(size_t*));
    memset(ss, 0, sizeof(size_t*)*gvector_len(ss));
    if (!ss)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    for (size_t i = 1; i < m; ++i)
    {
        size_t *s = gvector_alloc(n, 0, sizeof(size_t));
        if (!s)
        {
            for (size_t j = 0; j < gvector_len(ss); ++j)
            {
                gvector_free(ss[j]);
            }
            gvector_free(ss);
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
        for (size_t j = 0; j < n; ++j)
        {
            if ((i & (1 << j)) != 0)
            {
                size_t *t = push_value(s,j);
                if (!t)
                {
                    gvector_free(s);
                    for (size_t k = 0; k < gvector_len(ss); ++k)
                    {
                        gvector_free(ss[k]);
                    }
                    gvector_free(ss);
                    INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
                }
                s = t;
            }
        }
        size_t *t = gvector_shrink(s);
        if (!t)
        {
            gvector_free(s);
            for (size_t j = 0; j < gvector_len(ss); ++j)
            {
                gvector_free(ss[j]);
            }
            gvector_free(ss);
            INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
        }
        s = t;
        ss[i-1] = s;
    }
    return ss;
}

static double *specific_info(int const *stimulus, int const *responses,
        size_t l, size_t n, int bs, int const *br, size_t const *source,
        inform_dist const *s_dist, inform_error *err)
{
    size_t const u = gvector_len(source);

    int *box = gvector_alloc((u + 1) * n, (u + 1) * n, sizeof(int));
    if (box == NULL)
    {
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    for (size_t i = 0; i < u; ++i)
    {
        memcpy(box + i*n, responses + source[i]*n, n*sizeof(int));
    }
    inform_black_box(box, u, 1, n, br, NULL, NULL, box + u*n, err);
    if (inform_failed(err))
    {
        gvector_free(box);
        return NULL;
    }
    responses = box + u*n;
    int b = 1;
    for (size_t i = 0; i < u; ++i) b *= br[source[i]];

    size_t const j_size = bs * b;
    size_t const r_size = b;
    size_t const total_size = j_size + r_size;

    uint32_t *data = gvector_alloc(total_size, total_size, sizeof(uint32_t));
    if (data == NULL)
    {
        gvector_free(box);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    for (size_t i = 0; i < total_size; ++i) data[i] = 0;

    inform_dist j_dist = { data, j_size, n };
    inform_dist r_dist = { data + j_size, r_size, n };
    for (size_t i = 0; i < n; ++i)
    {
        r_dist.histogram[responses[i]]++;
        j_dist.histogram[stimulus[i] + bs * responses[i]]++;
    }

    double *si = gvector_alloc(bs, bs, sizeof(double));
    if (si == NULL)
    {
        gvector_free(data);
        gvector_free(box);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    int joint;
    double n_stimulus, n_response, n_joint;
    for (int s = 0; s < bs; ++s)
    {
        si[s] = 0.0;
        n_stimulus = s_dist->histogram[s];
        if (n_stimulus == 0)
        {
            continue;
        }
        for (int r = 0; r < b; ++r)
        {
            n_response = r_dist.histogram[r];
            if (n_response == 0)
            {
                continue;
            }
            joint = s + bs * r;
            n_joint = j_dist.histogram[joint];
            if (n_joint == 0)
            {
                continue;
            }
            si[s] += n_joint * log2((n * n_joint) / (n_stimulus * n_response));
        }
        si[s] /= n_stimulus;
    }

    gvector_free(data);
    gvector_free(box);
    return si;
}

static void cleanup(size_t **subsets, inform_dist *s_dist, double **info)
{
    if (subsets)
    {
        for (size_t i = 0; i < gvector_len(subsets); ++i)
        {
            gvector_free(subsets[i]);
        }
        gvector_free(subsets);
    }

    if (s_dist)
    {
        inform_dist_free(s_dist);
    }

    if (info)
    {
        for (size_t i = 0; i < gvector_len(info); ++i)
        {
            gvector_free(info[i]);
        }
        gvector_free(info);
    }
}

static bool check_arguments( int const *stimulus, int const *responses, size_t l, size_t n,
        int bs, int const *br, inform_error *err)
{
    if (!stimulus || !responses)
        INFORM_ERROR_RETURN(err, INFORM_ETIMESERIES, true);
    else if (l < 1)
        INFORM_ERROR_RETURN(err, INFORM_ENOSOURCES, true);
    else if (n < 1)
        INFORM_ERROR_RETURN(err, INFORM_ESHORTSERIES, true);
    else if (bs < 2)
        INFORM_ERROR_RETURN(err, INFORM_EBASE, true);
    else if (!br)
        INFORM_ERROR_RETURN(err, INFORM_EBASE, true);

    for (size_t i = 0; i < l; ++i)
        if (br[i] < 2)
            INFORM_ERROR_RETURN(err, INFORM_EBASE, true);

    for (size_t i = 0; i < n; ++i)
        if (stimulus[i] < 0)
            INFORM_ERROR_RETURN(err, INFORM_ENEGSTATE, true);
        else if (stimulus[i] >= bs)
            INFORM_ERROR_RETURN(err, INFORM_EBADSTATE, true);

    for (size_t i = 0; i < l; ++i)
        for (size_t j = 0; j < n; ++j)
            if (responses[j + i*n] < 0)
                INFORM_ERROR_RETURN(err, INFORM_ENEGSTATE, true);
            else if (responses[j + i*n] >= br[i])
                INFORM_ERROR_RETURN(err, INFORM_EBADSTATE, true);

    return false;
}

inform_pid_lattice *inform_pid(int const *stimulus, int const *responses,
        size_t l, size_t n, int bs, int const *br, inform_error *err)
{
    if (check_arguments(stimulus, responses, l, n, bs, br, err))
    {
        return NULL;
    }
    size_t **ss = subsets(l, err);
    if (FAILED(err))
    {
        return NULL;
    }

    size_t const m = gvector_len(ss);

    inform_dist *s_dist = inform_dist_infer(stimulus, n);
    if (s_dist == NULL)
    {
        cleanup(ss, NULL, NULL);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }

    double **si = gvector_alloc(m, m, sizeof(double*));
    if (si == NULL)
    {
        cleanup(ss, s_dist, si);
        INFORM_ERROR_RETURN(err, INFORM_ENOMEM, NULL);
    }
    for (size_t i = 0; i < m; ++i) si[i] = NULL;
    for (size_t i = 0; i < m; ++i)
    {
        si[i] = specific_info(stimulus, responses, l, n, bs, br, ss[i], s_dist, err);
        if (FAILED(err))
        {
            cleanup(ss, s_dist, si);
            return NULL;
        }
    }

    inform_pid_lattice *lattice = hasse(l, err);
    if (FAILED(err))
    {
        cleanup(ss, s_dist, si);
        return NULL;
    }

    for (size_t i = 0; i < lattice->size; ++i)
    {
        inform_pid_source *alpha = lattice->sources[i];
        alpha->imin = 0.0;
        for (size_t s = 0; s < (size_t)bs; ++s)
        {
            double x = si[alpha->name[0]-1][s];
            for (size_t k = 1; k < alpha->size; ++k)
            {
                x = MIN(x, si[alpha->name[k]-1][s]);
            }
            alpha->imin += s_dist->histogram[s] * x;
        }
        alpha->imin /= s_dist->counts;
    }

    for (size_t i = 0; i < lattice->size; ++i)
    {
        inform_pid_source *alpha = lattice->sources[i];
        for (size_t s = 0; s < (size_t)bs; ++s)
        {
            double u = -INFINITY;
            for (size_t j = 0; j < alpha->n_below; ++j)
            {
                inform_pid_source *beta = alpha->below[j];
                double x = si[beta->name[0]-1][s];
                for (size_t k = 1; k < beta->size; ++k)
                {
                    x = MIN(x, si[beta->name[k]-1][s]);
                }
                u = MAX(u, x);
            }
            if (isinf(u))
            {
                u = 0.0;
            }
            alpha->pi += s_dist->histogram[s] * u;
        }
        alpha->pi = alpha->imin - alpha->pi / s_dist->counts;
    }

    cleanup(ss, s_dist, si);

    return lattice;
}
