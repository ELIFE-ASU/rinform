#include "inform/block_entropy.h"

void r_block_entropy_(int *series, int *n, int *m, int *b, int *k, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *rval = inform_block_entropy(series, *n, *m, *b, *k, &ierr);
  *err = ierr;
}

void r_local_block_entropy_(int *series, int *n, int *m, int *b, int *k,
			  double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  inform_local_block_entropy(series, *n, *m, *b, *k, rval, &ierr);
  *err = ierr;
}


