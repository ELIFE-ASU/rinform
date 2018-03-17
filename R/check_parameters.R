################################################################################
# Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
# Use of this source code is governed by a MIT license that can be found in the
# LICENSE file.
################################################################################

.check_series <- function (x) {
  if (!is.numeric(x)) {
    stop("<", deparse(substitute(x)), "> is not numeric!", call. = !T)
  }
}

.check_series_num_variables <- function (x) {
  if (dim(x)[2] < 2) {
    stop("<", deparse(substitute(x)), "> has not enough variables!", call. = !T)
  }
}

.check_series_vector <- function (x) {
  if (!is.vector(x)) {
    stop("<", deparse(substitute(x)), "> is not a vector!", call. = !T)
  }
}

.check_series_array <- function (x) {
  if (!is.array(x)) {
    stop("<", deparse(substitute(x)), "> is not an array!", call. = !T)
  }
  if (length(dim(x)) != 3) {
    stop("<", deparse(substitute(x)), "> is not a 3-dimensional array!", call. = !T)
  }
}

.check_base <- function (x) {
  if (is.null(x)) {
    stop("<", deparse(substitute(x)), "> is NULL!", call. = !T)
  }
  if (!is.numeric(x)) {
    stop("<", deparse(substitute(x)), "> is not numeric!", call. = !T)
  }  
  if (length(x) > 1) {
    stop("<", deparse(substitute(x)), "> has length greater than 1!", call. = !T)
  }  
  if (length(x) < 1) {
    stop("<", deparse(substitute(x)), "> is of length zero!", call. = !T)
  }  
  if (x < 0) {
    stop("<", deparse(substitute(x)), "> must be non-negative!", call. = !T)
  }  
}

.check_partition <- function (x) {
  if (!is.numeric(x)) {
    stop("<", deparse(substitute(x)), "> is not numeric!", call. = !T)
  }
  if (!is.vector(x)) {
    stop("<", deparse(substitute(x)), "> is not a vector!", call. = !T)
  }
  if (!prod(x > 0)) {
    stop("<", deparse(substitute(x)), "> is not striclty-positive defined!", call. = !T)
  }
  for (i in 1:max(x)) {
    if (!(i %in% x)) {
      stop("<", deparse(substitute(x)), "> does not contain partition <",
           i, ">!", call. = !T)
    }
  }
}

.check_positive_integer <- function (x) {
  if (is.null(x)) {
    stop("<", deparse(substitute(x)), "> is NULL!", call. = !T)
  }
  if (!is.numeric(x)) {
    stop("<", deparse(substitute(x)), "> is not numeric!", call. = !T)
  }  
  if (length(x) > 1) {
    stop("<", deparse(substitute(x)), "> has length greater than 1!", call. = !T)
  }  
  if (length(x) < 1) {
    stop("<", deparse(substitute(x)), "> is of length zero!", call. = !T)
  }  
  if (x < 1) {
    stop("<", deparse(substitute(x)), "> must be greater than 0!", call. = !T)
  }  
}

.check_probability_vector <- function (p) {
  if (!is.numeric(p)) {
    stop("<", deparse(substitute(p)), "> is not numeric!", call. = !T)
  }
  if (!is.vector(p)) {
    stop("<", deparse(substitute(p)), "> is not a vector!", call. = !T)
  }
  if (!isTRUE(all.equal(sum(p), 1.0, tolerance = 1e-6))) {
    stop("<", deparse(substitute(p)), "> does not sum up to 1!", call. = !T)
  }
  if (sum(p >=  0) != length(p)) {
    stop("<", deparse(substitute(p)), "> contains negative values!", call. = !T)
  }
}

.check_tpm <- function (x) {
  if (!is.numeric(x)) {
    stop("<", deparse(substitute(x)), "> is not numeric!", call. = !T)
  }
  if (!is.matrix(x)) {
    stop("<", deparse(substitute(x)), "> is not a matrix!", call. = !T)
  }
  if (dim(x)[1] != dim(x)[2]) {
    stop("<", deparse(substitute(x)), "> is not a square matrix!", call. = !T)
  }
  for (i in 1:dim(x)[2]) {
    if (!isTRUE(all.equal(sum(x[, i]), 1.0, tolerance = 1e-6))) {
      stop("<", deparse(substitute(x)), ">'s column <", i ,"> does not sum up to 1!",
           call. = !T)
    }
  }
  if (sum(x >= 0) != dim(x)[1] * dim(x)[2]) {
    stop("<", deparse(substitute(x)), "> contains negative values!", call. = !T)
  }  
}

.check_history <- function (k) {
  if (!is.numeric(k)) {
    stop("<", deparse(substitute(k)), "> is not numeric!", call. = !T)
  }
  if (k < 1) {
    stop("<", deparse(substitute(k)), "> is less then 1!", call. = !T)
  }
}

.check_local <- function (local) {
  if (!is.logical(local)) {
    stop("<", deparse(substitute(local)), "> is not logical!", call. = !T)
  }
}

.check_distribution <- function (d) {
  if (!valid(d)) {
    stop("<", deparse(substitute(d)), "> is not a valid distribution!", call. = !T)
  }
}

.check_is_not_corrupted <- function(d, only_warning = !T) {
  rval <- T
  
  if(!is_not_corrupted(d)) {
    if (only_warning) {
      rval <- !T
    } else {
      stop("<", deparse(substitute(d)), "> object is corrupted!", call. = !T)
    }
  }
  rval
}

.check_event <- function(event, n) {
  if (!is.numeric(event)) {
    stop("<", deparse(substitute(event)), "> is not numeric!", call. = !T)
  }
  if (!is.vector(event)) {
    stop("<", deparse(substitute(event)), "> is multidimensional!", call. = !T)
  }
  if (length(event) > 1) {
    stop("<", deparse(substitute(event)), "> is a vector!", call. = !T)
  }
  if (event <= 0 | event > n) {
    stop("<", deparse(substitute(event)), "> out of bound!", call. = !T)
  }
}

.check_inform_error <- function(code) {
  INFORM_SUCCESS      <- 0      # no error occurred
  INFORM_FAILURE      <- -1     # an unspecified error occurred
  INFORM_EFAULT       <- 1      # invalid pointer
  INFORM_EARG         <- 2      # invalid argument
  INFORM_ENOMEM       <- 3      # malloc/calloc/realloc failed
  INFORM_ETIMESERIES  <- 4      # time series is NULL
  INFORM_ENOSOURCES   <- 5      # timeseries has no sources
  INFORM_ENOINITS     <- 6      # time series has no initial conditions
  INFORM_ESHORTSERIES <- 7      # time series has less than two timesteps
  INFORM_EKZERO       <- 8      # history length is zero
  INFORM_EKLONG       <- 9      # history is too long for the time series
  INFORM_EBASE        <- 10     # the provided base is invalid
  INFORM_ENEGSTATE    <- 11     # time series has negative state
  INFORM_EBADSTATE    <- 12     # time series has states inconsistent with expected base
  INFORM_EDIST        <- 13     # invalid distribution
  INFORM_EBIN         <- 14     # invalid binning
  INFORM_EENCODE      <- 15     # cannot encode state
  INFORM_ETPM         <- 16     # invalid TPM
  INFORM_ETPMROW      <- 17     # all zero row in transition probability matrix
  INFORM_ESIZE        <- 18     # invalid size,
  INFORM_EPARTS       <- 19     # invalid partitioning
  rval                <- INFORM_FAILURE

  if (code == INFORM_SUCCESS) {
    rval <- INFORM_SUCCESS
  } else if (code == INFORM_FAILURE) {
    stop("inform error - an unspecified error occurred", call. = !T)
  } else if (code == INFORM_FAILURE) {
    stop("inform error - an unspecified error occurred", call. = !T)
  } else if (code == INFORM_EFAULT) {
    stop("inform error - invalid pointer", call. = !T)
  } else if (code == INFORM_EARG) {
    stop("inform error - invalid argument", call. = !T)
  } else if (code == INFORM_ENOMEM) {
    stop("inform error - malloc/calloc/realloc failed", call. = !T)
  } else if (code == INFORM_ETIMESERIES) {
    stop("inform error - time series is NULL", call. = !T)
  } else if (code == INFORM_ENOSOURCES) {
    stop("inform error - timeseries has no sources", call. = !T)
  } else if (code == INFORM_ENOINITS) {
    stop("inform error - time series has no initial conditions", call. = !T)
  } else if (code == INFORM_ESHORTSERIES) {
    stop("inform error - time series has less than two timesteps", call. = !T)
  } else if (code == INFORM_EKZERO) {
    stop("inform error - history length is zero", call. = !T)
  } else if (code == INFORM_EKLONG) {
    stop("inform error - history is too long for the time series", call. = !T)
  } else if (code == INFORM_EBASE) {
    stop("inform error - the provided base is invalid", call. = !T)
  } else if (code == INFORM_ENEGSTATE) {
    stop("inform error - time series has negative state", call. = !T)
  } else if (code == INFORM_EBADSTATE) {
    stop("inform error - time series has states inconsistent with expected base",
         call. = !T)
  } else if (code == INFORM_EDIST) {
    stop("inform error - invalid distribution", call. = !T)
  } else if (code == INFORM_EBIN) {
    stop("inform error - invalid binning", call. = !T)
  } else if (code == INFORM_EENCODE) {
    stop("inform error - cannot encode state", call. = !T)
  } else if (code == INFORM_ETPM) {
    stop("inform error - invalid TPM", call. = !T)
  } else if (code == INFORM_ETPMROW) {
    stop("inform error - all zero row in transition probability matrix", call. = !T)
  } else if (code == INFORM_ESIZE) {
    stop("inform error - invalid size", call. = !T)
  } else if (code == INFORM_EPARTS) {
    stop("inform error - invalid partitioning", call. = !T)
  }

  rval
}