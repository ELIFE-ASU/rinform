################################################################################
# Copyright 2017 ELIFE. All rights reserved.
# Use of this source code is governed by a MIT
# license that can be found in the LICENSE file.
################################################################################



################################################################################
#' Shannon Entropy
#'
#' Compute the base-\code{b} Shannon entropy of the distribution \code{p}.
#'
#' @param p Dist specifying the distribution.
#' @param b Numeric giving the base of the logarithm.
#'
#' @return Numeric giving the Shannon entropy of the distribution.
#'
#' @example inst/examples/ex_shannon_entropy.R
#'
#' @export
#'
#' @useDynLib rinform r_shannon_entropy_
################################################################################
shannon_entropy <- function(p, b = 2.0) {
  sen <- 0
  err <- 0

  .check_distribution(p)
  .check_base(b)

  x <- .C("r_shannon_entropy_",
          histogram = p$histogram,
	  size      = p$size,
	  b         = as.double(b),
	  sen       = as.double(sen),
          err       = as.integer(err))

  if (.check_inform_error(x$err) == 0) {
    sen <- x$sen
  }

  sen
}

################################################################################
#' Shannon Mutual Information
#'
#' Compute the base-\code{b} mutual information between two random variables.
#'
#' @param p_xy Dist specifying the joint distribution.
#' @param p_x Dist specifying the \code{x}-marginal distribution.
#' @param p_y Dist specifying the \code{y}-marginal distribution.
#' @param b Numeric giving the base of the logarithm.
#'
#' @return Numeric giving the Shannon mutual information.
#'
#' @example inst/examples/ex_shannon_mutual_info.R
#'
#' @export
#'
#' @useDynLib rinform r_shannon_mutual_info_
################################################################################
shannon_mutual_info <- function(p_xy, p_x, p_y, b = 2.0) {
  smi <- 0
  err <- 0

  .check_distribution(p_xy)
  .check_distribution(p_x)
  .check_distribution(p_y)
  .check_base(b)

  x <- .C("r_shannon_mutual_info_",
          histogram_xy = p_xy$histogram,
	  size_xy      = p_xy$size,
          histogram_x  = p_x$histogram,
	  size_x       = p_x$size,
          histogram_y  = p_y$histogram,
	  size_y       = p_y$size,
	  b            = as.double(b),
	  smi          = as.double(smi),
          err          = as.integer(err))

  if (.check_inform_error(x$err) == 0) {
    smi <- x$smi
  }

  smi
}

################################################################################
#' Shannon Conditional Entropy
#'
#' Compute the base-\code{b} conditional entropy given joint \code{p_xy} and
#' marginal \code{p_y} distributions.
#'
#' @param p_xy Dist specifying the joint distribution.
#' @param p_y Dist specifying the \code{y}-marginal distribution.
#' @param b Numeric giving the base of the logarithm.
#'
#' @return Numeric giving the Shannon conditional entropy.
#'
#' @example inst/examples/ex_shannon_conditional_entropy.R
#'
#' @export
#'
#' @useDynLib rinform r_shannon_conditional_entropy_
################################################################################
shannon_conditional_entropy <- function(p_xy, p_y, b = 2.0) {
  sce <- 0
  err <- 0

  .check_distribution(p_xy)
  .check_distribution(p_y)
  .check_base(b)

  x <- .C("r_shannon_conditional_entropy_",
          histogram_xy = p_xy$histogram,
	  size_xy      = p_xy$size,
          histogram_y  = p_y$histogram,
	  size_y       = p_y$size,
	  b            = as.double(b),
	  sce          = as.double(sce),
          err          = as.integer(err))

  if (.check_inform_error(x$err) == 0) {
    sce <- x$sce
  }

  sce
}

################################################################################
#' Shannon Conditional Mutual Information
#'
#' Compute the base-\code{b} conditional mutual information given joint
#' \code{p_xyz} and marginal \code{p_xz}, \code{p_yz}, \code{p_z} distributions.
#'
#' @param p_xyz Dist specifying the joint distribution.
#' @param p_xz Dist specifying the \code{x,z}-marginal distribution.
#' @param p_yz Dist specifying the \code{y,z}-marginal distribution.
#' @param p_z Dist specifying the \code{z}-marginal distribution.
#' @param b Numeric giving the base of the logarithm.
#'
#' @return Numeric giving the Shannon conditional mutual information.
#'
#' @example inst/examples/ex_shannon_cond_mutual_info.R
#'
#' @export
#'
#' @useDynLib rinform r_shannon_cond_mutual_info_
################################################################################
shannon_cond_mutual_info <- function(p_xyz, p_xz, p_yz, p_z, b = 2.0) {
  scmi <- 0
  err  <- 0

  .check_distribution(p_xyz)
  .check_distribution(p_xz)
  .check_distribution(p_yz)
  .check_distribution(p_z)
  .check_base(b)

  x <- .C("r_shannon_cond_mutual_info_",
          histogram_xyz = p_xyz$histogram,
	  size_xyz      = p_xyz$size,
          histogram_xz  = p_xz$histogram,
	  size_xz       = p_xz$size,	  
          histogram_yz  = p_yz$histogram,
	  size_yz       = p_yz$size,
          histogram_z   = p_z$histogram,
	  size_z        = p_z$size,
	  b             = as.double(b),
	  scmi          = as.double(scmi),
          err           = as.integer(err))

  if (.check_inform_error(x$err) == 0) {
    scmi <- x$scmi
  }

  scmi
}

################################################################################
#' Shannon Relative Entropy
#'
#' Compute the base-\code{b} Shannon relative entropy between posterior
#' \code{p} and prior \code{q} distributions.
#'
#' @param p Dist specifying the posterior distribution.
#' @param q Dist specifying the prior distribution.
#' @param b Numeric giving the base of the logarithm.
#'
#' @return Numeric giving the Shannon relative entropy.
#'
#' @example inst/examples/ex_shannon_relative_entropy.R
#'
#' @export
#'
#' @useDynLib rinform r_shannon_relative_entropy_
################################################################################
shannon_relative_entropy <- function(p, q, b = 2.0) {
  sre <- 0
  err <- 0

  .check_distribution(p)
  .check_distribution(q)
  .check_base(b)

  x <- .C("r_shannon_relative_entropy_",
          histogram_p = p$histogram,
	  size_p      = p$size,
          histogram_q = q$histogram,
	  size_q      = q$size,
	  b           = as.double(b),
	  sre         = as.double(sre),
          err         = as.integer(err))
	  
  if (.check_inform_error(x$err) == 0) {
    sre <- x$sre
  }

  sre
}

################################################################################
#' Shannon Cross Entropy
#'
#' Compute the base-\code{b} Shannon cross entropy between a true distribution
#' \code{p} and an unnatural distribution \code{q}.
#'
#' @param p Dist specifying the true distribution.
#' @param q Dist specifying the unnatural distribution.
#' @param b Numeric giving the base of the logarithm.
#'
#' @return Numeric giving the Shannon cross entropy.
#'
#' @example inst/examples/ex_shannon_cross_entropy.R
#'
#' @export
#'
#' @useDynLib rinform r_shannon_cross_entropy_
################################################################################
shannon_cross_entropy <- function(p, q, b = 2.0) {
  sce <- 0
  err <- 0

  .check_distribution(p)
  .check_distribution(q)
  .check_base(b)

  x <- .C("r_shannon_cross_entropy_",
          histogram_p = p$histogram,
	  size_p      = p$size,
          histogram_q = q$histogram,
	  size_q      = q$size,
	  b           = as.double(b),
	  sce         = as.double(sce),
          err         = as.integer(err))
	  
  if (.check_inform_error(x$err) == 0) {
    sce <- x$sce
  }

  sce
}
