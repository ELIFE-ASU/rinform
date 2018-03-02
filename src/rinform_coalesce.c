#include <inform/utilities/coalesce.h>

void r_coalesce_(int *series, int *n, int *coal, int *b, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *b   = inform_coalesce(series, *n, coal, &ierr);
  *err = ierr;
}
