/*******************************************************************************/
// Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.
/*******************************************************************************/
#include <inform/utilities/tpm.h>

void r_series_to_tpm_(int *series, int *n, int *m, int *b, double *tpm, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  inform_tpm(series, *n, *m, *b, tpm, &ierr);
  *err = ierr;
}
