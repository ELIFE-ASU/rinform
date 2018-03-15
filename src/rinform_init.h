/*******************************************************************************/
// Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.
/*******************************************************************************/

/* rinform_active_info.c */
extern void r_active_info_(int *series, int *n, int *m, int *b, int *k,
			   double *rval, int *err);
extern void r_local_active_info_(int *series, int *n, int *m, int *b, int *k,
				 double *rval, int *err);

/* rinform_binning.c */
extern void r_series_range_(double *series, int *n, double *srange, double *smin,
			    double *smax, int *err);
extern void r_bin_series_bin_(double *series, int *n, int *b, int *binned,
			    double *bin_size, int *err);
extern void r_bin_series_step_(double *series, int *n, int *b, int *binned,
			    double *step, int *err);
extern void r_bin_series_bounds_(double *series, int *n, int *b, double *bounds, int *m,
		            int *binned, int *err);

/* rinform_black_box.c */
extern void r_black_box_(int *series, int *l, int *n, int *m, int *b, int *r, int *rNull,
			 int *s, int *sNull, int *box, int *err);
extern void r_black_box_parts_(int *series, int *l, int *n, int *b, int *parts,
			       int *nparts, int *box, int *err);

/* rinform_block_entropy.c */
extern void r_block_entropy_(int *series, int *n, int *m, int *b, int *k,
			     double *rval, int *err);
extern void r_local_block_entropy_(int *series, int *n, int *m, int *b, int *k,
				   double *rval, int *err);

/* rinform_coalesce.c */
extern void r_coalesce_(int *series, int *n, int *coal, int *b, int *err);

/* rinform_conditional_entropy.c */
extern void r_conditional_entropy_(int *xs, int *ys, int *n, int *bx, int *by,
				   double *rval, int *err);
extern void r_local_conditional_entropy_(int *xs, int *ys, int *n, int *bx, int *by,
					 double *rval, int *err);

/* rinform_cross_entropy.c */
extern void r_cross_entropy_(int *ps, int *qs, int *n, int *b, double *rval, int *err);

/* rinform_dist.c */
extern void r_dist_(int *histogram, int *size, int *counts, int *err);
extern void r_length_(int *histogram, int *size, int *counts, int *rval, int *err);
extern void r_get_item_(int *histogram, int *size, int *counts, int *event,
			int *rval, int *err);
extern void r_set_item_(int *histogram, int *size, int *counts, int *event,
			int *value, int *err);
extern void r_resize_(int *histogram, int *size, int *counts, int *nhistogram,
		      int *n, int *err);
extern void r_copy_(int *histogram, int *size, int *chistogram, int *csize,
		    int *ccounts, int *err);
extern void r_infer_(int *n, int *events, int *histogram, int *err);
extern void r_approximate_(double *probs, int *n, double *tol, int *histogram, int *err);
extern void r_uniform_(int *n, int *histogram, int *size, int *counts, int *err);
extern void r_counts_(int *histogram, int *size, int *rcounts, int *err);
extern void r_valid_(int *histogram, int *size, int *isvalid, int *err);
extern void r_tick_(int *histogram, int *size, int *counts, int *event, int *err);
extern void r_accumulate_(int *histogram, int *size, int *counts, int *n,
			  int *events, int *err);
extern void r_probability_(int *histogram, int *size, int *event, double *prob, int *err);
extern void r_dump_(int *histogram, int *size, double *prob, int *err);

/* rinform_effective_info.c */
extern void r_effective_info_(double *tpm, double *inter, int *n, double *rval, int *err);
extern void r_effective_info_uniform_(double *tpm, int *n, double *rval, int *err);

/* rinform_encoding.c */
extern void r_encode_(int *state, int *n, int *b, int *encoded, int *err);
extern void r_decode_(int *encoding, int *b, int *state, int *n, int *err);

/* rinform_entropyrate.c */
extern void r_entropy_rate_(int *series, int *n, int *m, int *b, int *k,
			    double *rval, int *err);
extern void r_local_entropy_rate_(int *series, int *n, int *m, int *b, int *k,
				  double *rval, int *err);

/* rinform_excess_entropy.c */
extern void r_excess_entropy_(int *series, int *n, int *m, int *b, int *k,
			      double *rval, int *err);
extern void r_local_excess_entropy_(int *series, int *n, int *m, int *b, int *k,
				    double *rval, int *err);

/* rinform_info_flow.c */
extern void r_info_flow_(int *src, int *dst, int *lsrc, int *ldst, int *n, int *m, int *b,
			 double *rval, int *err);
extern void r_info_flow_back_(int *src, int *dst, int *back, int *lsrc, int *ldst,
			      int *lback, int *n, int *m, int *b, double *rval, int *err);

/* rinform_integration_evidence.c */
extern void r_integration_evidence_(int *series, int *l, int *n, int *b,
			            double *evidence, int *err);
extern void r_integration_evidence_parts_(int *series, int *l, int *n, int *b, int *parts,
					  int *nparts, double *evidence, int *err);

/* rinform_mutual_info.c */
extern void r_mutual_info_(int *series, int *l, int *n, int *b, double *rval, int *err);
extern void r_local_mutual_info_(int *series, int *l, int *n, int *b,
				 double *rval, int *err);

/* rinform_partitioning.c */
extern void r_partitioning_(int *n, int *P);

/* rinform_predictive_info.c */
extern void r_predictive_info_(int *series, int *n, int *m, int *b, int *kpast,
			       int *kfuture, double *rval, int *err);
extern void r_local_predictive_info_(int *series, int *n, int *m, int *b, int *kpast,
				     int *kfuture, double *rval, int *err);

/* rinform_relativeentropy.c */
extern void r_relative_entropy_(int *xs, int *ys, int *n, int *b, double *rval, int *err);
extern void r_local_relative_entropy_(int *xs, int *ys, int *n, int *b, double *rval,
				      int *err);

/* rinform_separable_info.c */
extern void r_separable_info_(int *srcs, int *dest, int *l, int *n, int *m,
			      int *b, int *k, double *rval, int *err);
extern void r_local_separable_info_(int *srcs, int *dest, int *l, int *n, int *m,
				    int *b, int *k, double *rval, int *err);

/* rinform_series_to_tpm.c */
extern void r_series_to_tpm_(int *series, int *n, int *m, int *b, double *tpm, int *err);

/* rinform_shannon.c */
extern void r_shannon_entropy_(int *histogram, int *size, double *b, double *sen, int *err);
extern void r_shannon_mutual_info_(int *histogram_xy, int *size_xy, int *histogram_x,
				   int *size_x, int *histogram_y, int *size_y, double *b,
				   double *smi, int *err);
extern void r_shannon_conditional_entropy_(int *histogram_xy, int *size_xy,
					   int *histogram_y, int *size_y, double *b,
					   double *sce, int *err);
extern void r_shannon_cond_mutual_info_(int *histogram_xyz, int *size_xyz,
					int *histogram_xz, int *size_xz, int *histogram_yz,
					int *size_yz, int *histogram_z, int *size_z,
					double *b, double *scmi, int *err);
extern void r_shannon_relative_entropy_(int *histogram_p, int *size_p, int *histogram_q,
					int *size_q, double *b, double *sre, int *err);
extern void r_shannon_cross_entropy_(int *histogram_p, int *size_p, int *histogram_q,
				     int *size_q, double *b, double *sce, int *err);

/* rinform_transfer_entropy.c */
extern void r_transfer_entropy_(int *ys, int *xs, int *n, int *m, int *b, int *k,
				double *rval, int *err);
extern void r_complete_transfer_entropy_(int *ys, int *xs, int *ws, int *l, int *n,
					 int *m, int *b, int *k, double *rval, int *err);
extern void r_local_transfer_entropy_(int *ys, int *xs, int *n, int *m, int *b, int *k,
				      double *rval, int *err);
extern void r_local_complete_transfer_entropy_(int *ys, int *xs, int *ws, int *l, int *n,
					       int *m, int *b, int *k, double *rval,
					       int *err);
