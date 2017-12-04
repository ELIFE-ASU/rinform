// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#pragma once

#include <inform/dist.h>
#include <math.h>

#ifdef __cplusplus
extern "C"
{
#endif

/**
 * Compute the Shannon self-information of an event given some distribution
 *
 * This function will return `NaN` if the distribution is not valid.
 *
 * @param[in] dist  the probability distribution
 * @param[in] event the event in question
 * @param[in] base  the logarithmic base
 * @return the self-information of the event
 */
EXPORT double inform_shannon_si(inform_dist const *dist, size_t event, double base);

/**
 * Compute the Shannon information of a distribution.
 *
 * This function will return `NaN` if the distribution is not valid,
 * i.e. `!inform_dist_is_valid(dist)`.
 *
 * @param[in] dist the probability distribution
 * @param[in] base the logarithmic base
 * @return the shannon information
 */
EXPORT double inform_shannon_entropy(inform_dist const *dist, double base);

/**
 * Compute the pointwise mutual information of an combination of events
 *
 * @param[in] joint       the joint distribution
 * @param[in] marginal_x  the x-marginal
 * @param[in] marginal_y  the y-marginal
 * @param[in] event_joint the joint event
 * @param[in] event_x     the corresponding event in the x-marginal
 * @param[in] event_y     the corresponding event in the y-marginal
 * @param[in] base        the logarithmic base
 * @return the pointwise mutual information of the events
 */
EXPORT double inform_shannon_pmi(inform_dist const *joint,
    inform_dist const *marginal_x, inform_dist const *marginal_y,
    size_t event_joint, size_t event_x, size_t event_y, double base);

/**
 * Compute the Shannon-based mutual information of a distribution and
 * two marginals.
 *
 * This function will return `NaN` if `inform_shannon` returns `NaN`
 * when applied to any of the distribution arguments.
 *
 * @param[in] joint      the joint probability distribution
 * @param[in] marginal_x a marginal distribution
 * @param[in] marginal_y a marginal distribution
 * @param[in] base       the logarithmic base
 * @return the mutual information
 */
EXPORT double inform_shannon_mi(inform_dist const *joint,
    inform_dist const *marginal_x, inform_dist const *marginal_y, double base);

/**
 * Compute the pointwise conditional entropy of a combination of events
 *
 * @param[in] joint          the joint probability distribution
 * @param[in] marginal       the marginal distribution
 * @param[in] event_joint    the joint event
 * @param[in] event_marginal the marginal event
 * @param[in] base           the logarithmic base
 * @return the pointwise conditional entropy of the events
 */
EXPORT double inform_shannon_pce(inform_dist const *joint, inform_dist const *marginal,
    size_t event_joint, size_t event_marginal, double base);

/**
 * Compute the Shannon-based conditional entropy of a joint distribution and
 * a marginal.
 *
 * This function will return `NaN` if `inform_shannon` returns `NaN`
 * when applied to any of the distribution arguments.
 *
 * @param[in] joint    the joint probability distribution
 * @param[in] marginal a marginal distribution
 * @param[in] base     the logarithmic base
 * @return the conditional information
 */
EXPORT double inform_shannon_ce(inform_dist const* joint, inform_dist const *marginal,
    double base);

/**
 * Compute the pointwise conditional mutual information of a combination of events
 *
 * @param[in] joint             the joint probability distribution
 * @param[in] marginal_xz       the xz-marginal
 * @param[in] marginal_yz       the yz-marginal
 * @param[in] marginal_z        the z-marginal
 * @param[in] event_joint       the joint event
 * @param[in] event_marginal_xz the xz event
 * @param[in] event_marginal_yz the yz event
 * @param[in] event_marginal_z  the z event
 * @param[in] base              the logarithmic base
 * @return the pointwise conditional mutual information
 */
EXPORT double inform_shannon_pcmi(inform_dist const *joint,
    inform_dist const *marginal_xz, inform_dist const *marginal_yz,
    inform_dist const *marginal_z, size_t event_joint,
    size_t event_marginal_xz, size_t event_marginal_yz,
    size_t event_marginal_z, double base);

/**
 * Compute the conditional mutual entropy of a joint distribution, and
 * the xz-, yz, and z-marginals.
 *
 * @param[in] joint       then joint probability distribution
 * @param[in] marginal_xz the xz-marginal
 * @param[in] marginal_yz the yz-marginal
 * @param[in] marginal_z  the z-marginal
 * @param[in] base        the logarithmic base
 * @return the conditional mutual information;
 */
EXPORT double inform_shannon_cmi(inform_dist const *joint,
    inform_dist const *marginal_xz, inform_dist const *marginal_yz,
    inform_dist const *marginal_z, double base);

/**
 * Compute the pointwise relative entropy between two distributions with equal
 * support size at some event.
 *
 * @param[in] p     the posterior distribution
 * @param[in] q     the prior distribution
 * @param[in] event the local event
 * @param[in] base  the logarithmic base
 * @return the relative entropy between p and q.
 */
EXPORT double inform_shannon_pre(inform_dist const *p, inform_dist const *q,
    size_t event, double base);

/**
 * Compute the relative entropy between two distributions with equal
 * support size.
 *
 * @param[in] p     the posterior distribution
 * @param[in] q     the prior distribution
 * @param[in] base  the logarithmic base
 * @return the relative entropy between p and q.
 */
EXPORT double inform_shannon_re(inform_dist const *p, inform_dist const *q,
    double base);

/**
 * Compute the cross entropy between two distributions with equal
 * support size.
 *
 * @param[in] p     the "true" distribution
 * @param[in] q     the "unnatural" distribution
 * @param[in] base  the logarithmic base
 * @return the cross entropy between p and q.
 */
EXPORT double inform_shannon_cross(inform_dist const *p, inform_dist const *q,
    double base);

/**
 * Compute the multivariate pointwise mutual information between a collection of
 * distributions.
 *
 * @param[in] joint           the joint distribution
 * @param[in] marginals       an array of marginal distributions
 * @param[in] n               the number of marginals
 * @param[in] joint_event     the joint event
 * @param[in] marginal_events an array of marginal events
 * @param[in] base            the logarithmic base
 * @return the multivariate pointwise mutual information of the events
 */
EXPORT double inform_shannon_multi_pmi(inform_dist const *joint,
    inform_dist const **marginals, size_t n, size_t joint_event,
    size_t const *marginal_events, double base);

/**
 * Compute the multivariate mutual information between a collection of
 * distributions.
 *
 * @param[in] joint           the joint distribution
 * @param[in] marginals       an array of marginal distributions
 * @param[in] n               the number of marginals
 * @param[in] base            the logarithmic base
 * @return the multivariate mutual information of the distributions
 */
EXPORT double inform_shannon_multi_mi(inform_dist const *joint,
    inform_dist const **marginals, size_t n, double base);

#ifdef __cplusplus
}
#endif
