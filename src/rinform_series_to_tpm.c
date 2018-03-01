#include <inform/utilities/tpm.h>

void r_series_to_tpm_(int *series, int *n, int *m, int *b, double *tpm, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  inform_tpm(series, *n, *m, *b, tpm, &ierr);
  *err = ierr;
}
