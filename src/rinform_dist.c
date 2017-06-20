#include "inform/dist.h"

void r_dist_(int *histogram, int *size, int *counts, int *err) {
  inform_dist *dist;
    
  dist = inform_dist_create((const uint32_t *) histogram, *size);
  
  if (dist != NULL) {
    *counts = dist->counts;
  } else {
    *err = 1;
  }
}

void r_length_(int *histogram, int *size, int *counts, int *rval) {
  inform_dist *dist;
    
  dist  = inform_dist_create((const uint32_t *) histogram, *size);
  *rval = inform_dist_size(dist);
  // dealloc dist!!!
}

void r_get_item_(int *histogram, int *size, int *counts, int *event, int *rval) {
  inform_dist *dist;
    
  dist  = inform_dist_create((const uint32_t *) histogram, *size);
  *rval = inform_dist_get(dist, *event);  
}

void r_set_item_(int *histogram, int *size, int *counts, int *event, int *value) {
  inform_dist *dist;

  dist  = inform_dist_create((const uint32_t *) histogram, *size);
  inform_dist_set(dist, *event, *value);
  histogram[*event] = (int) dist->histogram[*event];
  *counts           = dist->counts;
}
