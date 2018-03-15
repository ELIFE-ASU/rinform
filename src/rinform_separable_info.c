/*******************************************************************************/
// Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.
/*******************************************************************************/
#include "inform/separable_info.h"

void r_separable_info_(int *srcs, int *dest, int *l, int *n, int *m,
		       int *b, int *k, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  *rval = inform_separable_info(srcs, dest, *l, *n, *m, *b, *k, &ierr);
  *err = ierr;
}

void r_local_separable_info_(int *srcs, int *dest, int *l, int *n, int *m,
			     int *b, int *k, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  inform_local_separable_info(srcs, dest, *l, *n, *m, *b, *k, rval, &ierr);
  *err = ierr;
}
