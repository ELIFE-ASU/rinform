#include <inform/utilities.h>
#include <inform/utilities/partitions.h>

void r_partitioning_series_(int *size, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  inform_first_partitioning(*size);
  *err = ierr;
}
