#include "inform/transfer_entropy.h"

void r_transfer_entropy_(int *ys, int *xs, int *n, int *m, int *b, int *k, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *rval = inform_transfer_entropy(ys, xs, *n, *m, *b, *k, &ierr);
  *err = ierr;
}

void r_local_transfer_entropy_(int *ys, int *xs, int *n, int *m, int *b, int *k, int *mwindow,
			  double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  if (*mwindow) {
    inform_local_transfer_entropy2(ys, xs, *n, *m, *b, *k, rval, &ierr);
  } else {
    inform_local_transfer_entropy(ys, xs, *n, *m, *b, *k, rval, &ierr);
  }
  *err = ierr;
}


