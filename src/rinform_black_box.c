/*******************************************************************************/
// Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.
/*******************************************************************************/
#include <R.h>
#include "inform/utilities/black_boxing.h"

void r_black_box_(int *series, int *l, int *n, int *m, int *b, int *r, int *rNull,
		  int *s, int *sNull, int *box, int *err) {
  inform_error ierr = INFORM_SUCCESS;
  size_t *R = (size_t *) R_alloc(*l, sizeof(size_t));
  size_t *S = (size_t *) R_alloc(*l, sizeof(size_t));

  for (size_t i = 0; i < *l; ++i) {
    if (*rNull == 0) { R[i] = r[i]; }
    if (*sNull == 0) { S[i] = s[i]; }
  }

  inform_black_box(series, *l, *n, *m, b, *rNull ? NULL : R,
		   *sNull ? NULL : S, box, &ierr);  
  *err = ierr;
}

void r_black_box_parts_(int *series, int *l, int *n, int *b, int *parts,
			int *nparts, int *box, int *err) {    
  inform_error ierr = INFORM_SUCCESS;
  size_t *st_parts = (size_t *) R_alloc(*l, sizeof(size_t));

  for (size_t i = 0; i < *l; ++i) {
    st_parts[i] = parts[i];
  }

  inform_black_box_parts(series, *l, *n, b, st_parts, *nparts, box, &ierr);
  *err = ierr;  
}
