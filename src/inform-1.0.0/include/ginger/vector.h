// Copyright 2016-2017 Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#pragma once

#include <assert.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C"
{
#endif

// The `gvector` is a "fat pointer" implementation of a resizable array. To
// facilitate this, every `gvector` begins with a `gvector_header` containing
// structural information including its capacity, element size, and length.
//
// # Example
//
// ```c
// int *xs = gvector_alloc(5, 3, sizeof(int));
// struct gvector_header *hdr = ((struct gvector_header*)v) - 1;
// assert(hdr->capacity == 5);
// assert(hdr->size == sizeof(int));
// assert(hdr->length == 3);
// ```
struct gvector_header
{
  size_t capacity;
  size_t size;
  size_t length;
};

// The `gvector` type is just an alias for a `void *`.
typedef void* gvector;
// The `gvector` type is just an alias for a `void const*`.
typedef void const* gvector_const;

// Get the capacity of the `gvector`.
#define gvector_cap(v) ((struct gvector_header*)v)[-1].capacity
// Get the element size of the `gvector`.
#define gvector_size(v) ((struct gvector_header*)v)[-1].size
// Get the length of the `gvector`.
#define gvector_len(v) ((struct gvector_header*)v)[-1].length
// Is the `gvector` empty?
#define gvector_isempty(v) !(v && gvector_len(v))

// Allocate an uninitialized `gvector` with a given capacity, length and element
// size.
//
// # Exceptional Cases
// 1. If array is tructated to the capacity if `length > capacity`.
// 2. If `size == 0`, no memory is allocated and `NULL` is returned.
// 3. If memory allocation failed, `NULL` is returned.
//
// # Example
// ```c
// int *xs = gvector_alloc(5, 3, sizeof(int));
// assert(xs != NULL);
// assert(gvector_cap(xs) == 5);
// assert(gvector_size(xs) == 3);
// assert(gvector_len(xs) == sizeof(int));
// ```
gvector gvector_alloc(size_t capacity, size_t length, size_t size);

// Deallocate a `gvector`.
//
// # Example
// ```c
// gvector_free(NULL); // NOOP
//
// int *xs = gvector_alloc(5, 0, sizeof(int));
// gvector_free(xs); // succeeds even if xs == NULL
// ```
void gvector_free(gvector v);

// Duplicate a `gvector` in memory and return a pointer to the duplicate.
//
// # Exceptional Cases
// If the memory cannot be allocated, NULL is returned.
//
// # Example
// ```c
// gvector_dup(NULL); // NOOP
//
// int *xs = gvector_alloc(5, 3, sizeof(int));
// for (size_t i = 0; i < 3; ++i) xs[i] = i;
// int *ys = gvector_dup(ys);
// assert(xs != ys);
// assert(gvector_cap(xs) == gvector_cap(ys));
// assert(gvector_size(xs) == gvector_size(ys));
// assert(gvector_len(xs) == gvector_len(ys));
// for (size_t i = 0; i < 3; ++i) assert(xs[i] == ys[i]);
// ```
gvector gvector_dup(gvector_const v);

// Copy the contents of one `gvector` to another, and return the number of
// elements copied.
//
// The number of elements copied is the smaller of the lengths of the vectors.
//
// # Example
// ```c
// gvector_copy(NULL, NULL); // NOOP
//
// int *xs = gvector_alloc(5, 3, sizeof(int));
// for (size_t i = 0; i < 3; ++i) xs[i] = i;
// gvector_copy(NULL, xs); // NOOP
// gvector_copy(xs, NULL); // NOOP
//
// int *ys = gvector_alloc(3, 2, sizeof(int));
// assert(gvector_copy(ys, xs) == 2);
// for (size_t i = 0; i < 2; ++i) assert(ys[i] == i);
//
// for (size_t i = 0; i < 2; ++i) ys[i] = 2 + i;
// assert(gvector_copy(xs, ys) == 2);
// for (size_t i = 0; i < 2; ++i) assert(xs[i] == 2 + i);
// ```
size_t gvector_copy(gvector dst, gvector_const src);

// Change the capacity of the `gvector`, returning a pointer to the newly
// resized `gvector`.
//
// # Exceptional Case
// If the reallocation failed, NULL is returned.
//
// # Example
// ```c
// gvector_reserve(NULL); // NOOP
//
// int *xs = gvector(3, 3, sizeof(int));
// for (size_t i = 0; i < 3; ++i) xs[i] = i;
//
// xs = gvector_reserve(xs, 6);
// assert(gvector_cap(xs) == 6);
// assert(gvector_len(xs) == 3);
// for (size_t i = 0; i < 3; ++i) assert(xs[i] == i);
//
// xs = gvector_reserve(xs, 2);
// assert(gvector_cap(xs) == 2);
// assert(gvector_len(xs) == 2);
// for (size_t i = 0; i < 2; ++i) assert(xs[i] == i);
// ```
gvector gvector_reserve(gvector v, size_t capacity);

// Reduce the amount of memory used by the `gvector` to the amount required by
// its length. The resized `gvector` is returned.
//
// # Exceptional Case
// If the reallocation failed, NULL is returned.
//
// # Example
// ```c
// gvector_shrink(NULL); // NOOP
//
// int *xs = gvector_alloc(5, 3, sizeof(int));
// for (size_t i = 0; i < 3; ++i) xs[i] = i;
// xs = gvector_shrink(xs);
// assert(gvector_cap(xs) == 3);
// assert(gvector_len(xs) == 3);
// for (size_t i = 0; i < 3; ++i) assert(xs[i] == i);
// ```
gvector gvector_shrink(gvector v);

// Push an element onto the back of the `gvector`.
//
// If the vector exceeds its capacity, the capacity is doubled.
//
// # Exceptional Cases
// 1. If the `gvector` is NULL, a segmentation fault is raised.
// 2. If the resizing fails, then a segmentation fault is raised.
//
// # Example
// ```c
// int *xs = gvector_alloc(1, 1, sizeof(int));
// for (size_t i = 1; i < 5; ++i) gvector_push(xs, i);
// assert(gvector_cap(xs) == 8);
// assert(gvector_len(xs) == 5);
// for (size_t i = 0; i < 5; ++i) assert(xs[i] == i);
// ```
#define gvector_push(v, x) \
if (v && gvector_len(v) >= gvector_cap(v)) { \
  size_t cap = (v && gvector_cap(v)) ? 2*gvector_cap(v) : 1; \
  v = gvector_reserve(v, cap); \
} \
if (v) { v[gvector_len(v)++] = x; } else { raise(SIGSEGV); }

// Pop an element off of the back of the `gvector`.
//
// # Example
// ```c
// gvector_pop(NULL); // NOOP
//
// int *xs = gvector_alloc(3, 0, sizeof(int));
// gvector_pop(NULL); // NOOP
// gvector_free(xs);
//
// *xs = gvector_alloc(3, 3, sizeof(int));
// assert(gvector_cap(xs) == 3);
// assert(gvector_len(xs) == 3);
//
// gvector_pop(xs);
// assert(gvector_cap(xs) == 3);
// assert(gvector_len(xs) == 2);
// ```
#define gvector_pop(v) if (v && gvector_len(v) > 0) { --gvector_len(v); }

#ifdef __cplusplus
}
#endif