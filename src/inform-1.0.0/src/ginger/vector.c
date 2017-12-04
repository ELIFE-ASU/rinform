// Copyright 2016-2017 Douglas G. Moore. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#include <ginger/vector.h>
#include <math.h>
#include <string.h>

#define MIN(x,y) (x < y) ? x : y;

gvector gvector_alloc(size_t capacity, size_t length, size_t size)
{
  if (size)
  {
    length = (length > capacity) ? capacity : length;
    struct gvector_header *v = malloc(sizeof(struct gvector_header) + capacity * size);
    if (v)
    {
      v->capacity = capacity; 
      v->size = size;
      v->length = length;
      ++v;
    }
    return v;
  }
  return NULL;
}

void gvector_free(gvector v)
{
  if (v)
  {
    struct gvector_header *w = v;
    --w;
    free(w);
  }
}

gvector gvector_dup(gvector_const v)
{
  if (v)
  {
    gvector *w = gvector_alloc(gvector_cap(v), gvector_len(v), gvector_size(v));
    if (w)
    {
      memcpy(w, v, gvector_len(v) * gvector_size(v));
    }
    return w;
  }
  return NULL;
}

size_t gvector_copy(gvector dst, gvector_const src)
{
  if (dst && src)
  {
    if (gvector_size(dst) == gvector_size(src))
    {
      size_t len = MIN(gvector_len(dst), gvector_len(src));
      memcpy(dst, src, len * gvector_size(src));
      return len;
    }
  }
  return 0;
}

gvector gvector_reserve(gvector v, size_t capacity)
{
  if (v)
  {
    struct gvector_header *w = ((struct gvector_header*)v) - 1;
    struct gvector_header *u = realloc(w, sizeof(struct gvector_header) + capacity * w->size);
    if (u)
    {
      u->capacity = capacity;
      if (u->length > u->capacity)
      {
        u->length = u->capacity;
      }
      ++u;
    }
    return u;
  }
  return NULL;
}

gvector gvector_shrink(gvector v)
{
  if (v)
  {
    return gvector_reserve(v, gvector_len(v));
  }
  return NULL;
}
