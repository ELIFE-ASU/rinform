#include "inform/conditional_entropy.h"

void r_conditional_entropy_(int *xs, int *ys, int *n, int *bx, int *by, double *b,
			    double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *rval = inform_conditional_entropy(xs, ys, *n, *bx, *by, *b, &ierr);
  *err = ierr;
}

void r_local_conditional_entropy_(int *xs, int *ys, int *n, int *bx, int *by, double *b,
			          double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  inform_local_conditional_entropy(xs, ys, *n, *bx, *by, *b, rval, &ierr);
  *err = ierr;

}


