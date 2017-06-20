// Copyright 2016 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <inform/shannon.h>
#include <inform/error.h>

double inform_shannon_si(inform_dist const *dist, size_t event, double base)
{
    if (inform_dist_is_valid(dist))
    {
        return -log2(inform_dist_prob(dist, event)) / log2(base);
    }
    return NAN;
}

double inform_shannon(inform_dist const *dist, double base)
{
    // ensure that the distribution is valid
    if (inform_dist_is_valid(dist))
    {
        // get the size of the distribution's support
        size_t const n = inform_dist_size(dist);
        double h = 0.;
        // for each element of the distribution's support
        for (size_t i = 0; i < n; ++i)
        {
            // the observation_count is non-zero
            if (dist->histogram[i] != 0)
            {
                // get the probability
                double const p = (double) dist->histogram[i] / dist->counts;
                // accumulate the weighted self-information of the event
                h -= p * log2(p);
            }
        }
        // return the entropy
        return h / log2(base);
    }
    // return NaN if the distribution is invalid
    return NAN;
}

double inform_shannon_pmi(inform_dist const *joint,
    inform_dist const * marginal_x, inform_dist const *marginal_y,
    size_t event_joint, size_t event_x, size_t event_y, double base)
{
    return inform_shannon_si(marginal_x, event_x, base) +
        inform_shannon_si(marginal_y, event_y, base) -
        inform_shannon_si(joint, event_joint, base);
}

double inform_shannon_mi(inform_dist const *joint,
    inform_dist const *marginal_x, inform_dist const *marginal_y, double base)
{
    return inform_shannon(marginal_x, base) + inform_shannon(marginal_y, base)
        - inform_shannon(joint, base);
}

double inform_shannon_pce(inform_dist const *joint, inform_dist const *marginal,
    size_t event_joint,size_t event_marginal, double base)
{
    return inform_shannon_si(joint, event_joint, base) -
        inform_shannon_si(marginal, event_marginal, base);
}

double inform_shannon_ce(inform_dist const *joint, inform_dist const *marginal,
    double base)
{
    return inform_shannon(joint, base) - inform_shannon(marginal, base);
}

double inform_shannon_pcmi(inform_dist const *joint,
    inform_dist const *marginal_xz, inform_dist const *marginal_yz,
    inform_dist const *marginal_z, size_t event_joint,
    size_t event_marginal_xz, size_t event_marginal_yz,
    size_t event_marginal_z, double base)
{
    return inform_shannon_si(marginal_xz, event_marginal_xz, base) +
        inform_shannon_si(marginal_yz, event_marginal_yz, base) -
        inform_shannon_si(joint, event_joint, base) -
        inform_shannon_si(marginal_z, event_marginal_z, base);
}

double inform_shannon_cmi(inform_dist const *joint,
    inform_dist const *marginal_xz, inform_dist const *marginal_yz,
    inform_dist const *marginal_z, double base)
{
    return inform_shannon(marginal_xz, base) +
        inform_shannon(marginal_yz, base) -
        inform_shannon(joint, base) -
        inform_shannon(marginal_z, base);
}

double inform_shannon_pre(inform_dist const *p, inform_dist const *q,
    size_t event, double base)
{
    if (inform_dist_is_valid(p) && inform_dist_is_valid(q) && p->size == q->size)
    {
        double u = inform_dist_prob(p, event);
        double v = inform_dist_prob(q, event);
        return log2(u/v) / log2(base);
    }
    return NAN;
}

double inform_shannon_re(inform_dist const *p, inform_dist const *q,
    double base)
{
    if (inform_dist_is_valid(p) && inform_dist_is_valid(q) && p->size == q->size)
    {
        double re = 0.;
        for (size_t i = 0; i < p->size; ++i)
        {
            if (p->histogram[i] != 0 && q->histogram[i] != 0)
            {
                double u = (double) p->histogram[i] / p->counts;
                double v = (double) q->histogram[i] / q->counts;
                re += u * log2(u / v);
            }
            else if (p->histogram[i] != 0 && q->histogram[i] == 0)
            {
                return NAN;
            }
        }
        return re / log2(base);
    }
    return NAN;
}