#include "inform/mutual_info.h"

void r_mutual_info_(int *xs, int *ys, int *n, int *bx, int *by, double *b,
			    double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *rval = inform_mutual_info(xs, ys, *n, *bx, *by, *b, &ierr);
  *err = ierr;
}

void r_local_mutual_info_(int *xs, int *ys, int *n, int *bx, int *by, double *b,
			          double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  inform_local_mutual_info(xs, ys, *n, *bx, *by, *b, rval, &ierr);
  *err = ierr;
}


