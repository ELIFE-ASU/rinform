#include "inform/relative_entropy.h"

void r_relative_entropy_(int *xs, int *ys, int *n, int *b, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *rval = inform_relative_entropy(xs, ys, *n, *b, &ierr);
  *err = ierr;
}

void r_local_relative_entropy_(int *xs, int *ys, int *n, int *b, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  inform_local_relative_entropy(xs, ys, *n, *b, rval, &ierr);
  *err = ierr;
}


