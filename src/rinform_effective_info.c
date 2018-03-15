/*******************************************************************************/
// Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.
/*******************************************************************************/
#include "inform/effective_info.h"

void r_effective_info_(double *tpm, double *inter, int *n, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *rval = inform_effective_info(tpm, inter, *n, &ierr);
  *err  = ierr;
}

void r_effective_info_uniform_(double *tpm, int *n, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  *rval = inform_effective_info(tpm, NULL, *n, &ierr);
  *err  = ierr;
}


