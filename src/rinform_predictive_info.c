#include "inform/predictive_info.h"

void r_predictive_info_(int *series, int *n, int *m, int *b, int *kpast,
			int *kfuture, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *rval = inform_predictive_info(series, *n, *m, *b, *kpast, *kfuture, &ierr);
  *err  = ierr;
}

void r_local_predictive_info_(int *series, int *n, int *m, int *b, int *kpast,
			      int *kfuture, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  inform_local_predictive_info(series, *n, *m, *b, *kpast, *kfuture, rval, &ierr);
  *err = ierr;
}


