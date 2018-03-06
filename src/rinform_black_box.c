#include "inform/utilities/black_boxing.h"
#include <stdio.h>

void r_black_box_(int *series, int *l, int *n, int *m, int *b, size_t *r,
		  size_t *s, int *box, int *err) {
  inform_error ierr = INFORM_SUCCESS;
  
  printf("%d\n", *r);
  inform_black_box(series, *l, *n, *m, b, (*r == 0) ? (NULL) : (r),
		   (*s == 0) ? (NULL) : (s), box, &ierr);
  
  *err = ierr;
}

void r_black_box_parts_(int *series, int *l, int *n, int *m, int *b, int *r,
			int *s, int *parts, int *nparts, int *box, int *err) {
    
  inform_error ierr = INFORM_SUCCESS;

  //  *rval = inform_transfer_entropy(ys, xs, ws, *l, *n, *m, *b, *k, &ierr);
  *err = ierr;
}
