/*******************************************************************************/
// Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.
/*******************************************************************************/
#include "inform/active_info.h"

void r_active_info_(int *series, int *n, int *m, int *b, int *k, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *rval = inform_active_info(series, *n, *m, *b, *k, &ierr);
  *err  = ierr;
}

void r_local_active_info_(int *series, int *n, int *m, int *b, int *k, double *rval,
			  int *err) {
  inform_error ierr = INFORM_SUCCESS;

  inform_local_active_info(series, *n, *m, *b, *k, rval, &ierr);
  *err = ierr;
}


