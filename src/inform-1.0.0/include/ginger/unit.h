// Copyright 2016-2017 Douglas G. Moore. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.
#pragma once

#include <assert.h>
#include <float.h>
#include <inttypes.h>
#include <math.h>
#include <setjmp.h>
#include <signal.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef __cplusplus
extern "C"
{
#endif

struct unit
{
  char const *name;
  void (*run)(void);
};

struct unit_suite
{
  char const *name;
  int total;
  int num_ok;
  int num_failed;
  struct unit *units[];
};

extern jmp_buf __unit_err;

inline static int run_unit(struct unit_suite *suite, struct unit *u)
{
  if (u == NULL) return 1;

  printf("  [TEST] %s ", u->name);

  assert(u->run != NULL);

  ++suite->total;

  int result = setjmp(__unit_err);
  if (result == 0)
  {
    u->run();
    printf(" [OK]\n");
    ++suite->num_ok;
  }
  else
  {
    printf(" [FAIL]\n");
    ++suite->num_failed;
  }
  return 0;
}

inline static void run_unit_suite(struct unit_suite *suite)
{
  if (suite == NULL) return;

  printf("[SUITE] %s\n", suite->name);

  struct unit **u = suite->units;
  while (*u != NULL)
  {
    if (run_unit(suite, *u) != 0)
    {
      printf("[FRAMEWORK FAILURE]\n");
      abort();
    }
    ++u;
  }
}

#define __FUNCNAME(NAME) __unit_test_##NAME##_body
#define __UNITNAME(NAME) __unit_test_##NAME
#define UNIT(NAME) \
  static void __FUNCNAME(NAME)(void); \
  static struct unit __UNITNAME(NAME) = { \
    .name = #NAME, \
    .run  = __FUNCNAME(NAME) \
  }; \
  static void __FUNCNAME(NAME)(void)

#define __SUITENAME(NAME) __unit_suite_##NAME
#define BEGIN_SUITE(NAME) \
  struct unit_suite __SUITENAME(NAME) = { \
    .name = #NAME, \
    .total = 0, \
    .num_ok = 0, \
    .num_failed = 0, \
    .units = {
#define ADD_UNIT(NAME) &__UNITNAME(NAME),
#define END_SUITE NULL }};

#define IMPORT_SUITE(NAME) extern struct unit_suite __SUITENAME(NAME)
#define BEGIN_REGISTRATION \
  jmp_buf __unit_err; \
  static struct unit_suite *__unit_suites[] = {
#define REGISTER(NAME) &__SUITENAME(NAME),
#define END_REGISTRATION NULL };

#define UNIT_MAIN() \
  int main(int argc, char **argv) \
  { \
    int total = 0, num_ok = 0, num_failed = 0, run = 0; \
    size_t n = sizeof(__unit_suites) / sizeof(struct unit_suite *); \
    size_t i, j; \
    for (i = 0; i < n; ++i) \
    { \
      if (__unit_suites[i] == NULL) break; \
      run = (argc == 1); \
      for (j = 1; !run && j < (size_t)argc; ++j) \
      { \
        run = strcmp(__unit_suites[i]->name, argv[j]) == 0; \
      } \
      if (run) \
      { \
        run_unit_suite(__unit_suites[i]); \
        total += __unit_suites[i]->total; \
        num_ok += __unit_suites[i]->num_ok; \
        num_failed += __unit_suites[i]->num_failed; \
      } \
    } \
    printf("RESULTS: %d tests (%d ok, %d failed)\n", total, num_ok, num_failed); \
    return num_failed; \
  }

inline static void unit_error(char const *fmt, ...)
{
  va_list args;
  va_start(args, fmt);
  vprintf(fmt, args);
  va_end(args);
  longjmp(__unit_err, 1);
}

inline static void assert_equal(intmax_t exp, intmax_t real, char const *caller, int line);
#define ASSERT_EQUAL(exp, real) assert_equal(exp, real, __FILE__, __LINE__)

inline static void assert_not_equal(intmax_t nexp, intmax_t real, char const *caller, int line);
#define ASSERT_NOT_EQUAL(nexp, real) assert_not_equal(nexp, real, __FILE__, __LINE__)

inline static void assert_equal_u(uintmax_t exp, uintmax_t real, char const *caller, int line);
#define ASSERT_EQUAL_U(exp, real) assert_equal_u(exp, real, __FILE__, __LINE__)

inline static void assert_equal_p(void *exp, void *real, char const *caller, int line);
#define ASSERT_EQUAL_P(exp, real) assert_equal_p(exp, real, __FILE__, __LINE__)

inline static void assert_true(int real, char const *caller, int line);
#define ASSERT_TRUE(real) assert_true(real, __FILE__, __LINE__)

inline static void assert_false(int real, char const *caller, int line);
#define ASSERT_FALSE(real) assert_false(real, __FILE__, __LINE__)

inline static void assert_null(void *real, char const *caller, int line);
#define ASSERT_NULL(real) assert_null(real, __FILE__, __LINE__)

inline static void assert_not_null(void *real, char const *caller, int line);
#define ASSERT_NOT_NULL(real) assert_not_null(real, __FILE__, __LINE__)

inline static void assert_not_nan(double real, char const *caller, int line);
#define ASSERT_NOT_NAN(real) assert_not_nan(real, __FILE__, __LINE__);

inline static void assert_nan(double real, char const *caller, int line);
#define ASSERT_NAN(real) assert_nan(real, __FILE__, __LINE__);

inline static void assert_not_inf(double real, char const *caller, int line);
#define ASSERT_NOT_INF(real) assert_not_inf(real, __FILE__, __LINE__);

inline static void assert_inf(double real, char const *caller, int line);
#define ASSERT_INF(real) assert_inf(real, __FILE__, __LINE__);

inline static void assert_dbl_near(double exp, double real, double tol, char const *caller, int line);
#define ASSERT_DBL_NEAR_TOL(exp, real, tol) assert_dbl_near(exp, real, tol, __FILE__, __LINE__)
#define ASSERT_DBL_NEAR(exp, real) assert_dbl_near(exp, real, DBL_EPSILON, __FILE__, __LINE__)

static sig_atomic_t signal_code = 0;
static inline void signal_handler(int sig) { signal_code = sig; }
static inline void assert_signal(int sig, char const *caller, int line);
#define ASSERT_SIGNAL(sig, code) ASSERT_SIGNAL_(sig, code, __FILE__, __LINE__)
#define ASSERT_SIGNAL_(sig, code, file, line) \
  { \
    void *current_signal_handler = signal(sig, signal_handler); \
    { code; } \
    assert_signal(sig, file, line); \
    signal(sig, current_signal_handler); \
  }

inline static void assert_dbl_array_near(double *exp, double *real, size_t n, double tol, char const *caller, int line);
#define ASSERT_DBL_ARRAY_NEAR_TOL(exp, real, n, tol) assert_dbl_array_near(exp, real, n, tol, __FILE__, __LINE__)
#define ASSERT_DBL_ARRAY_NEAR(exp, real, n) assert_dbl_array_near(exp, real, n, DBL_EPSILON, __FILE__, __LINE__)

inline static void assert_equal(intmax_t exp, intmax_t real, char const *caller, int line)
{
  if (exp != real)
  {
    unit_error("%s:%d - expected %" PRIdMAX ", got %" PRIdMAX, caller, line, exp, real);
  }
}

inline static void assert_not_equal(intmax_t nexp, intmax_t real, char const *caller, int line)
{
  if (nexp == real)
  {
    unit_error("%s:%d - did not expect %" PRIdMAX, caller, line, nexp);
  }
}

inline static void assert_equal_u(uintmax_t exp, uintmax_t real, char const *caller, int line)
{
  if (exp != real)
  {
    unit_error("%s:%d - expected %" PRIdMAX ", got %" PRIdMAX, caller, line, exp, real);
  }
}

inline static void assert_equal_p(void *exp, void *real, char const *caller, int line)
{
  if (exp != real)
  {
    unit_error("%s:%d - expected %p, got %p", caller, line, exp, real);
  }
}

inline static void assert_true(int real, char const *caller, int line)
{
  if (real == 0)
  {
    unit_error("%s:%d should be true", caller, line);
  }
}

inline static void assert_false(int real, char const *caller, int line)
{
  if (real != 0)
  {
    unit_error("%s:%d should be false", caller, line);
  }
}

inline static void assert_null(void *real, const char *caller, int line)
{
  if (real != NULL)
  {
    unit_error("%s:%d should be NULL", caller, line);
  }
}

inline static void assert_not_null(void *real, const char *caller, int line)
{
  if (real == NULL)
  {
    unit_error("%s:%d should not be NULL", caller, line);
  }
}

inline static void assert_not_inf(double real, char const *caller, int line)
{
  if (isinf(real))
  {
    unit_error("%s: %d unexpected INFINITY", caller, line);
  }
}

inline static void assert_inf(double real, char const *caller, int line)
{
  if (!isinf(real))
  {
    unit_error("%s: %d expected INFINITY, got %0.3e", real, caller, line);
  }
}

inline static void assert_not_nan(double real, char const *caller, int line)
{
  if (isnan(real))
  {
    unit_error("%s: %d unexpected NAN", caller, line);
  }
}

inline static void assert_nan(double real, char const *caller, int line)
{
  if (!isnan(real))
  {
    unit_error("%s: %d expected NAN, got %0.3e", real, caller, line);
  }
}

inline static void assert_dbl_near(double exp, double real, double tol, char const *caller, int line)
{
  if (isnan(exp))
  {
    if (!isnan(real))
    {
      unit_error("%s:%d expected NAN, got %0.3e", caller, line, real);
    }
  }
  else if (isnan(real))
  {
    unit_error("%s:%d expected %0.3e, got NAN", caller, line, exp);
  }
  if (isinf(exp))
  {
    if (!isinf(real))
    {
      unit_error("%s:%d expected INFINITY, got %0.3e", caller, line, real);
    }
  }
  else if (isinf(real))
  {
    unit_error("%s:%d expected %0.3e, got INFINITY", caller, line, exp);
  }
  double diff = exp - real;
  tol += DBL_EPSILON;
  double absdiff = (diff < 0.) ? -diff : diff;
  if (absdiff > tol)
  {
    unit_error("%s:%d expected %0.3e, got %0.3e (diff %0.3e, tol %0.3e)", caller, line, exp, real, diff, tol);
  }
}

inline static void assert_signal(int sig, char const *caller, int line)
{
  if (signal_code != sig)
  {
    unit_error("%s:%d expected signal %d, got %d\n", caller, line, sig, signal_code);
  }
  signal_code = 0;
}

inline static void assert_dbl_array_near(double *exp, double *real, size_t n, double tol, char const *caller, int line)
{
  for (size_t i = 0; i < n; ++i)
  {
    assert_dbl_near(exp[i], real[i], tol, caller, line);
  }
}

#ifdef __cplusplus
}
#endif