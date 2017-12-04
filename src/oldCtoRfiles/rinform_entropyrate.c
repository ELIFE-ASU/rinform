#include "inform/entropy_rate.h"

void r_entropy_rate_(int *series, int *n, int *m, int *b, int *k, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *rval = inform_entropy_rate(series, *n, *m, *b, *k, &ierr);
  *err = ierr;
}

void r_local_entropy_rate_(int *series, int *n, int *m, int *b, int *k, double *rval,
			   int *err) {
  inform_error ierr = INFORM_SUCCESS;

  inform_local_entropy_rate(series, *n, *m, *b, *k, rval, &ierr);
  *err = ierr;
}

