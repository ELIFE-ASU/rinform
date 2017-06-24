#include <inform/utilities/encoding.h>

void r_encode_(int *state, int *n, int *b, int *encoded, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  *encoded = inform_encode(state, *n, *b, &ierr);
  *err     = ierr;
}

void r_decode_(int *encoding, int *b, int *state, int *n, int *err) {
  inform_error ierr = INFORM_SUCCESS;
    
  inform_decode(*encoding, *b, state, *n, &ierr);
  *err = ierr;
}
