/*******************************************************************************/
// Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.
/*******************************************************************************/
#include "inform/mutual_info.h"

void r_mutual_info_(int *series, int *l, int *n, int *b, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *rval = inform_mutual_info(series, *l, *n, b, &ierr);
  *err = ierr;
}

void r_local_mutual_info_(int *series, int *l, int *n, int *b, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  inform_local_mutual_info(series, *l, *n, b, rval, &ierr);
  *err = ierr;
}


