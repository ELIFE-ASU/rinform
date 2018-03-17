# rinform 1.0.1

* Bug solved in `inform_predictive_info` which was causing an invalid read of
  4 bytes. Developers of 'Inform' have been made aware of this bug.

* Bug solved in memory menagement for functions `r_integration_evidence_parts_`
  and `r_black_box_parts_`.

* The `R/check_parameters.R` file is now compliant with noLD compilation
  mode.

* The `src/inform-1.0.0/Makevars` file is now fully POSIX compliant.

* The copyright of all files contained in the folders `R/` `src/` and
  `tests/` has been changed to the package author and contributor
  Gabriele Valentini and Douglas G. Moore as ELIFE@ASU is not a
  legal organization.

# rinform 1.0.0

* First official release of the _rinform_ package wrapping the C
  library _Inform_ version 1.0.0.