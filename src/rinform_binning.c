#include <inform/utilities/binning.h>

void r_series_range_(double *series, int *n, double *srange, double *smin,
		     double *smax, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *srange = inform_range(series, *n, smin, smax, &ierr);
  *err    = ierr;
}

void r_bin_series_(double *series, int *n, double *srange, double *smin,
		     double *smax, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *srange = inform_range(series, *n, smin, smax, &ierr);
  *err    = ierr;
}
