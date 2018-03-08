#include <stdlib.h>
#include <inform/utilities/partitions.h>

void r_partitioning_(int *n, int *P) {
  size_t idx = 0;
  size_t *part = inform_first_partitioning(*n);

  do {
    for (size_t i = 0; i < *n; ++i) {
      P[idx] = part[i];
      ++idx;
    }
  } while (inform_next_partitioning(part, *n));

  free(part);
}
