/*******************************************************************************/
// Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.
/*******************************************************************************/
#include <inform/utilities/binning.h>

void r_series_range_(double *series, int *n, double *srange, double *smin,
		     double *smax, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *srange = inform_range(series, *n, smin, smax, &ierr);
  *err    = ierr;
}

void r_bin_series_bin_(double *series, int *n, int *b, int *binned,
		       double *bin_size, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *bin_size = inform_bin(series, *n, *b, binned, &ierr);
  *err      = ierr;
}

void r_bin_series_step_(double *series, int *n, int *b, int *binned,
		        double *step, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *b   = inform_bin_step(series, *n, *step, binned, &ierr);
  *err = ierr;
}

void r_bin_series_bounds_(double *series, int *n, int *b, double *bounds, int *m,
		          int *binned, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *b   = inform_bin_bounds(series, *n, bounds, *m, binned, &ierr);
  *err = ierr;
}
