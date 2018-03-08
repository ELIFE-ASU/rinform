#include "inform/information_flow.h"

void r_info_flow_(int *src, int *dst, int *lsrc, int *ldst, int *n, int *m, int *b,
		  double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  *rval = inform_information_flow(src, dst, NULL, *lsrc, *ldst, 0,  *n, *m, *b, &ierr);
  *err  = ierr;
}

void r_info_flow_back_(int *src, int *dst, int *back, int *lsrc, int *ldst, int *lback,
		       int *n, int *m, int *b, double *rval, int *err) {
  inform_error ierr = INFORM_SUCCESS;

  *rval = inform_information_flow(src, dst, back, *lsrc, *ldst, *lback,  *n, *m, *b, &ierr);
  *err  = ierr;
}

