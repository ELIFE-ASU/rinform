#include "inform/shannon.h"

void r_shannon_entropy_(int *histogram, int *size, double *b,
		       double *sen, int *err) {
  inform_dist *dist;
    
  dist = inform_dist_create((const uint32_t *) histogram, *size);
  
  if (dist != NULL) {
    *sen = inform_shannon_entropy(dist, *b);
    inform_dist_free(dist);      
  } else {
    *err = 1;
  }
}

void r_shannon_mutual_info_(int *histogram_xy, int *size_xy,
			    int *histogram_x, int *size_x,
			    int *histogram_y, int *size_y,
			    double *b, double *smi, int *err) {
  inform_dist *p_xy, *p_x, *p_y;
    
  p_xy = inform_dist_create((const uint32_t *) histogram_xy, *size_xy);
  p_x  = inform_dist_create((const uint32_t *) histogram_x, *size_x);
  p_y  = inform_dist_create((const uint32_t *) histogram_y, *size_y);
  
  if (p_xy != NULL && p_x != NULL && p_y != NULL) {
    *smi = inform_shannon_mi(p_xy, p_x, p_y, *b);
    inform_dist_free(p_xy);      
    inform_dist_free(p_x);      
    inform_dist_free(p_y);      
  } else {
    *err = 1;
    if (p_xy != NULL) inform_dist_free(p_xy);
    if (p_x != NULL)  inform_dist_free(p_x);
    if (p_y != NULL)  inform_dist_free(p_y);
  }
}

void r_shannon_conditional_entropy_(int *histogram_xy, int *size_xy,
			            int *histogram_y, int *size_y,
			            double *b, double *sce, int *err) {
  inform_dist *p_xy, *p_y;
    
  p_xy = inform_dist_create((const uint32_t *) histogram_xy, *size_xy);
  p_y  = inform_dist_create((const uint32_t *) histogram_y, *size_y);
  
  if (p_xy != NULL && p_y != NULL) {
    *sce = inform_shannon_ce(p_xy, p_y, *b);
    inform_dist_free(p_xy);      
    inform_dist_free(p_y);      
  } else {
    *err = 1;
    if (p_xy != NULL) inform_dist_free(p_xy);
    if (p_y != NULL)  inform_dist_free(p_y);
  }
}

void r_shannon_cond_mutual_info_(int *histogram_xyz, int *size_xyz,
			         int *histogram_xz, int *size_xz,
			         int *histogram_yz, int *size_yz,
			         int *histogram_z, int *size_z,
			         double *b, double *scmi, int *err) {
  inform_dist *p_xyz, *p_xz, *p_yz, *p_z;
    
  p_xyz = inform_dist_create((const uint32_t *) histogram_xyz, *size_xyz);
  p_xz  = inform_dist_create((const uint32_t *) histogram_xz, *size_xz);
  p_yz  = inform_dist_create((const uint32_t *) histogram_yz, *size_yz);
  p_z   = inform_dist_create((const uint32_t *) histogram_z, *size_z);
  
  if (p_xyz != NULL && p_xz != NULL && p_yz != NULL && p_z != NULL) {
    *scmi = inform_shannon_cmi(p_xyz, p_xz, p_yz, p_z, *b);
    inform_dist_free(p_xyz);      
    inform_dist_free(p_xz);      
    inform_dist_free(p_yz);      
  } else {
    *err = 1;
    if (p_xyz != NULL) inform_dist_free(p_xyz);
    if (p_xz != NULL)  inform_dist_free(p_xz);
    if (p_yz != NULL)  inform_dist_free(p_yz);
    if (p_z != NULL)   inform_dist_free(p_z);
  }
}

void r_shannon_relative_entropy_(int *histogram_p, int *size_p,
				 int *histogram_q, int *size_q,
				 double *b, double *sre, int *err) {
  inform_dist *p, *q;
    
  p = inform_dist_create((const uint32_t *) histogram_p, *size_p);
  q = inform_dist_create((const uint32_t *) histogram_q, *size_q);
  
  if (p != NULL && p != NULL) {
      *sre = inform_shannon_re(p, q, *b);
    inform_dist_free(p);      
    inform_dist_free(q);      
  } else {
    *err = 1;
    if (p != NULL)   inform_dist_free(p);
    if (q != NULL)   inform_dist_free(q);
  }
}

void r_shannon_cross_entropy_(int *histogram_p, int *size_p,
				 int *histogram_q, int *size_q,
				 double *b, double *sce, int *err) {
  inform_dist *p, *q;
    
  p = inform_dist_create((const uint32_t *) histogram_p, *size_p);
  q = inform_dist_create((const uint32_t *) histogram_q, *size_q);
  
  if (p != NULL && p != NULL) {
      *sce = inform_shannon_cross(p, q, *b);
    inform_dist_free(p);      
    inform_dist_free(q);      
  } else {
    *err = 1;
    if (p != NULL)   inform_dist_free(p);
    if (q != NULL)   inform_dist_free(q);
  }
}
