/*******************************************************************************/
// Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.
/*******************************************************************************/
#include "inform/conditional_entropy.h"

void r_conditional_entropy_(int *xs, int *ys, int *n, int *bx, int *by,
			    double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *rval = inform_conditional_entropy(xs, ys, *n, *bx, *by, &ierr);
  *err = ierr;
}

void r_local_conditional_entropy_(int *xs, int *ys, int *n, int *bx, int *by,
			          double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  inform_local_conditional_entropy(xs, ys, *n, *bx, *by, rval, &ierr);
  *err = ierr;
}


