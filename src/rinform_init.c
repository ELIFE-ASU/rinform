/*******************************************************************************/
// Copyright 2017-2018 Gabriele Valentini, Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.
/*******************************************************************************/
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>
#include "rinform_init.h"

static const R_CMethodDef CEntries[] = {
    {"r_accumulate_",                      (DL_FUNC) &r_accumulate_,                       6},
    {"r_active_info_",                     (DL_FUNC) &r_active_info_,                      7},
    {"r_approximate_",                     (DL_FUNC) &r_approximate_,                      5},
    {"r_bin_series_bin_",                  (DL_FUNC) &r_bin_series_bin_,                   6},
    {"r_bin_series_bounds_",               (DL_FUNC) &r_bin_series_bounds_,                7},
    {"r_bin_series_step_",                 (DL_FUNC) &r_bin_series_step_,                  6},
    {"r_black_box_",                       (DL_FUNC) &r_black_box_,                       11},
    {"r_black_box_parts_",                 (DL_FUNC) &r_black_box_parts_,                  8},
    {"r_block_entropy_",                   (DL_FUNC) &r_block_entropy_,                    7},
    {"r_coalesce_",                        (DL_FUNC) &r_coalesce_,                         5},
    {"r_complete_transfer_entropy_",       (DL_FUNC) &r_complete_transfer_entropy_,       10},
    {"r_conditional_entropy_",             (DL_FUNC) &r_conditional_entropy_,              7},
    {"r_copy_",                            (DL_FUNC) &r_copy_,                             6},
    {"r_counts_",                          (DL_FUNC) &r_counts_,                           4},
    {"r_cross_entropy_",                   (DL_FUNC) &r_cross_entropy_,                    6},
    {"r_decode_",                          (DL_FUNC) &r_decode_,                           5},
    {"r_dist_",                            (DL_FUNC) &r_dist_,                             4},
    {"r_dump_",                            (DL_FUNC) &r_dump_,                             4},
    {"r_effective_info_",                  (DL_FUNC) &r_effective_info_,                   5},
    {"r_effective_info_uniform_",          (DL_FUNC) &r_effective_info_uniform_,           4},
    {"r_encode_",                          (DL_FUNC) &r_encode_,                           5},
    {"r_entropy_rate_",                    (DL_FUNC) &r_entropy_rate_,                     7},
    {"r_excess_entropy_",                  (DL_FUNC) &r_excess_entropy_,                   7},
    {"r_get_item_",                        (DL_FUNC) &r_get_item_,                         6},
    {"r_infer_",                           (DL_FUNC) &r_infer_,                            4},
    {"r_info_flow_",                       (DL_FUNC) &r_info_flow_,                        9},
    {"r_info_flow_back_",                  (DL_FUNC) &r_info_flow_back_,                  11},
    {"r_integration_evidence_",            (DL_FUNC) &r_integration_evidence_,             6},
    {"r_integration_evidence_parts_",      (DL_FUNC) &r_integration_evidence_parts_,       8},
    {"r_length_",                          (DL_FUNC) &r_length_,                           5},
    {"r_local_active_info_",               (DL_FUNC) &r_local_active_info_,                7},
    {"r_local_block_entropy_",             (DL_FUNC) &r_local_block_entropy_,              7},
    {"r_local_complete_transfer_entropy_", (DL_FUNC) &r_local_complete_transfer_entropy_, 10},
    {"r_local_conditional_entropy_",       (DL_FUNC) &r_local_conditional_entropy_,        7},
    {"r_local_entropy_rate_",              (DL_FUNC) &r_local_entropy_rate_,               7},
    {"r_local_excess_entropy_",            (DL_FUNC) &r_local_excess_entropy_,             7},
    {"r_local_mutual_info_",               (DL_FUNC) &r_local_mutual_info_,                6},
    {"r_local_predictive_info_",           (DL_FUNC) &r_local_predictive_info_,            8},
    {"r_local_relative_entropy_",          (DL_FUNC) &r_local_relative_entropy_,           6},
    {"r_local_separable_info_",            (DL_FUNC) &r_local_separable_info_,             9},
    {"r_local_transfer_entropy_",          (DL_FUNC) &r_local_transfer_entropy_,           8},
    {"r_mutual_info_",                     (DL_FUNC) &r_mutual_info_,                      6},
    {"r_partitioning_",                    (DL_FUNC) &r_partitioning_,                     2},
    {"r_predictive_info_",                 (DL_FUNC) &r_predictive_info_,                  8},
    {"r_probability_",                     (DL_FUNC) &r_probability_,                      5},
    {"r_relative_entropy_",                (DL_FUNC) &r_relative_entropy_,                 6},
    {"r_resize_",                          (DL_FUNC) &r_resize_,                           6},
    {"r_separable_info_",                  (DL_FUNC) &r_separable_info_,                   9},
    {"r_series_range_",                    (DL_FUNC) &r_series_range_,                     6},
    {"r_series_to_tpm_",                   (DL_FUNC) &r_series_to_tpm_,                    6},
    {"r_set_item_",                        (DL_FUNC) &r_set_item_,                         6},
    {"r_shannon_cond_mutual_info_",        (DL_FUNC) &r_shannon_cond_mutual_info_,        11},
    {"r_shannon_conditional_entropy_",     (DL_FUNC) &r_shannon_conditional_entropy_,      7},
    {"r_shannon_cross_entropy_",           (DL_FUNC) &r_shannon_cross_entropy_,            7},
    {"r_shannon_entropy_",                 (DL_FUNC) &r_shannon_entropy_,                  5},
    {"r_shannon_mutual_info_",             (DL_FUNC) &r_shannon_mutual_info_,              9},
    {"r_shannon_relative_entropy_",        (DL_FUNC) &r_shannon_relative_entropy_,         7},
    {"r_tick_",                            (DL_FUNC) &r_tick_,                             5},
    {"r_transfer_entropy_",                (DL_FUNC) &r_transfer_entropy_,                 8},
    {"r_uniform_",                         (DL_FUNC) &r_uniform_,                          5},
    {"r_valid_",                           (DL_FUNC) &r_valid_,                            4},
    {NULL, NULL, 0}
};

void R_init_rinform(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
