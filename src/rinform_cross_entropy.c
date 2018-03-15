/*******************************************************************************/
// Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.
/*******************************************************************************/
#include "inform/cross_entropy.h"

void r_cross_entropy_(int *ps, int *qs, int *n, int *b, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *rval = inform_cross_entropy(ps, qs, *n, *b, &ierr);
  *err = ierr;
}


