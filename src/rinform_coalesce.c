/*******************************************************************************/
// Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.
/*******************************************************************************/
#include <inform/utilities/coalesce.h>

void r_coalesce_(int *series, int *n, int *coal, int *b, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *b   = inform_coalesce(series, *n, coal, &ierr);
  *err = ierr;
}
