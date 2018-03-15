/*******************************************************************************/
// Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.
/*******************************************************************************/
#include "inform/information_flow.h"

void r_info_flow_(int *src, int *dst, int *lsrc, int *ldst, int *n, int *m, int *b,
		  double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  *rval = inform_information_flow(src, dst, NULL, *lsrc, *ldst, 0,  *n, *m, *b, &ierr);
  *err  = ierr;
}

void r_info_flow_back_(int *src, int *dst, int *back, int *lsrc, int *ldst, int *lback,
		       int *n, int *m, int *b, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  *rval = inform_information_flow(src, dst, back, *lsrc, *ldst, *lback,  *n, *m, *b, &ierr);
  *err  = ierr;
}

