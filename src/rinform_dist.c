/*******************************************************************************/
// Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.
/*******************************************************************************/
#include "inform/dist.h"

void r_dist_(int *histogram, int *size, int *counts, int *err) {
  inform_dist *dist;
    
  dist = inform_dist_create((const uint32_t *) histogram, *size);
  
  if (dist != NULL) {
    *counts = dist->counts;
    inform_dist_free(dist);      
  } else {
    *err = 1;
  }
}

void r_length_(int *histogram, int *size, int *counts, int *rval, int *err) {
  inform_dist *dist;
    
  dist  = inform_dist_create((const uint32_t *) histogram, *size);
  if (dist != NULL) {
    *rval = inform_dist_size(dist);
    inform_dist_free(dist);
  } else {
    *err = 1;
  }    
}

void r_get_item_(int *histogram, int *size, int *counts, int *event, int *rval,
		 int *err) {
  inform_dist *dist;
    
  dist  = inform_dist_create((const uint32_t *) histogram, *size);
  if (dist != NULL) {
    *rval = inform_dist_get(dist, *event);
    inform_dist_free(dist);
  } else {
    *err = 1;
  }
}

void r_set_item_(int *histogram, int *size, int *counts, int *event, int *value,
		 int *err) {
  inform_dist *dist;

  dist = inform_dist_create((const uint32_t *) histogram, *size);
  if (dist != NULL) {
    inform_dist_set(dist, *event, *value);
    histogram[*event] = (int) dist->histogram[*event];
    *counts           = dist->counts;
    inform_dist_free(dist);
  } else {
    *err = 1;
  }
}

void r_resize_(int *histogram, int *size, int *counts, int *nhistogram,
	       int *n, int *err) {
  int i = 0;
  inform_dist *dist;
    
  dist = inform_dist_create((const uint32_t *) histogram, *size);
  if (dist != NULL) {
    dist = inform_dist_realloc(dist, *n);
    if (dist != NULL) {
      for (i = 0; i < *n; i++)
        nhistogram[i] = (int) dist->histogram[i];
      *size      = dist->size;
      *counts    = dist->counts;
      inform_dist_free(dist);        
    } else {
      *err = 1;
    }
  } else {
    *err = 1;
  }
}

void r_copy_(int *histogram, int *size, int *chistogram,
	     int *csize, int *ccounts, int *err) {
  int i = 0;    
  inform_dist *dist, *c_dist = NULL;

  dist   = inform_dist_create((const uint32_t *) histogram, *size);

  if (dist != NULL) {
    c_dist = inform_dist_copy(dist, c_dist);

    if (c_dist != NULL) {
      for (i = 0; i < *size; i++)      
        chistogram[i] = (int) c_dist->histogram[i];
      *csize     = c_dist->size;
      *ccounts   = c_dist->counts;
      inform_dist_free(c_dist);      
    } else {
      *err = 1;
    }
    
    inform_dist_free(dist);          
  } else {
    *err = 1;
  }
}

void r_infer_(int *n, int *events, int *histogram, int *err) {
  inform_dist *dist;
    
  dist = inform_dist_infer(events, *n);
  
  if (dist != NULL) {
    for (int i = 0; i < dist->size; i++)      
      histogram[i] = (int) dist->histogram[i];
    inform_dist_free(dist);      
  } else {
    *err = 1;
  }
}

void r_approximate_(double *probs, int *n, double *tol, int *histogram, int *err) {
  inform_dist *dist;
    
  dist = inform_dist_approximate(probs, *n, *tol);
  
  if (dist != NULL) {
    for (int i = 0; i < dist->size; i++)      
      histogram[i] = (int) dist->histogram[i];
    inform_dist_free(dist);      
  } else {
    *err = 1;
  }
}

void r_uniform_(int*n, int *histogram, int *size, int *counts, int *err) {
  inform_dist *dist;
    
  dist = inform_dist_uniform(*n);
  
  if (dist != NULL) {
    *size = dist->size;
    *counts = dist->counts;      
    for (int i = 0; i < *size; i++)      
      histogram[i] = (int) dist->histogram[i];
    inform_dist_free(dist);      
  } else {
    *err = 1;
  }
}


void r_counts_(int *histogram, int *size, int *rcounts, int *err) {
  inform_dist *dist;
    
  dist  = inform_dist_create((const uint32_t *) histogram, *size);
  if (dist != NULL) {
    *rcounts = inform_dist_counts(dist);
    inform_dist_free(dist);
  } else {
    *err = 1;
  }
}

void r_valid_(int *histogram, int *size, int *isvalid, int *err) {
  inform_dist *dist;
    
  dist  = inform_dist_create((const uint32_t *) histogram, *size);
  if (dist != NULL) {
    *isvalid = inform_dist_is_valid(dist);
    inform_dist_free(dist);
  } else {
    *err = 1;
  }
}

void r_tick_(int *histogram, int *size, int *counts, int *event, int *err) {
  inform_dist *dist;
  int new_occurencies;
    
  dist  = inform_dist_create((const uint32_t *) histogram, *size);
  if (dist != NULL) {
    new_occurencies = inform_dist_tick(dist, *event);
    histogram[*event] = new_occurencies;
    *counts = inform_dist_counts(dist);
    inform_dist_free(dist);
  } else {
    *err = 1;
  }
}

void r_accumulate_(int *histogram, int *size, int *counts, int *n, int *events, int *err) {
  inform_dist *dist;
  int new_occurencies;
    
  dist  = inform_dist_create((const uint32_t *) histogram, *size);  
  if (dist != NULL) {
    new_occurencies = inform_dist_accumulate(dist, events, *n);
    *counts   = dist->counts;
    *size     = dist->size;
    *n        = new_occurencies;    
    for (int i = 0; i < *size; i++)      
      histogram[i] = (int) dist->histogram[i];
    inform_dist_free(dist);
  } else {
    *err = 1;
  }
}

void r_probability_(int *histogram, int *size, int *event,
		    double *prob, int *err) {
  inform_dist *dist;
    
  dist  = inform_dist_create((const uint32_t *) histogram, *size);
  if (dist != NULL) {
    *prob = inform_dist_prob(dist, *event);
    inform_dist_free(dist);
  } else {
    *err = 1;
  }
}

void r_dump_(int *histogram, int *size, double *prob, int *err) {
  inform_dist *dist;
    
  dist  = inform_dist_create((const uint32_t *) histogram, *size);
  if (dist != NULL) {
    inform_dist_dump(dist, prob, *size);
    inform_dist_free(dist);
  } else {
    *err = 1;
  }
}
