/*******************************************************************************/
// Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.
/*******************************************************************************/
#include <stdlib.h>
#include "inform/integration.h"

void r_integration_evidence_(int *series, int *l, int *n, int *b,
			     double *evidence, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  inform_integration_evidence(series, *l, *n, b, evidence, &ierr);
  *err = ierr;
}

void r_integration_evidence_parts_(int *series, int *l, int *n, int *b,
				   int *parts, int *nparts, double *evidence, int *err) {
  inform_error ierr = INFORM_SUCCESS;
  size_t *st_parts = malloc((*l) * sizeof(size_t));

  for (size_t i = 0; i < *l; ++i) {
    st_parts[i] = parts[i];
  }

  inform_integration_evidence_part(series, *l, *n, b, st_parts, *nparts, evidence, &ierr);
  *err = ierr;
  free(st_parts);
}

