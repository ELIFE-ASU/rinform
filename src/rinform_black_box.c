#include "inform/utilities/black_boxing.h"

void r_black_box_(int *series, int *l, int *n, int *m, int *b, int *r, int *rNull,
		  int *s, int *sNull, int *box, int *err) {
  inform_error ierr = INFORM_SUCCESS;
  size_t R[*l], S[*l];

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
  size_t st_parts[*l];

  for (size_t i = 0; i < *l; ++i) {
    st_parts[i] = parts[i];
  }

  inform_black_box_parts(series, *l, *n, b, st_parts, *nparts, box, &ierr);
  *err = ierr;
}
