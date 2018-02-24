#include "inform/transfer_entropy.h"

void r_transfer_entropy_(int *ys, int *xs, int *n, int *m,
			 int *b, int *k, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  *rval = inform_transfer_entropy(ys, xs, NULL, 0, *n, *m, *b, *k, &ierr);
  *err = ierr;
}

void r_complete_transfer_entropy_(int *ys, int *xs, int *ws, int *l, int *n, int *m,
			 int *b, int *k, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  *rval = inform_transfer_entropy(ys, xs, ws, *l, *n, *m, *b, *k, &ierr);
  *err = ierr;
}

void r_local_transfer_entropy_(int *ys, int *xs, int *n, int *m,
			       int *b, int *k, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  inform_local_transfer_entropy(ys, xs, NULL, 0, *n, *m, *b, *k, rval, &ierr);
  *err = ierr;
}

void r_local_complete_transfer_entropy_(int *ys, int *xs, int *ws, int *l, int *n, int *m,
			       int *b, int *k, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  inform_local_transfer_entropy(ys, xs, ws, *l, *n, *m, *b, *k, rval, &ierr);
  *err = ierr;
}


