// Copyright 2016-2017 ELIFE. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.
#pragma once

#ifdef _WIN32
    #ifdef LIBRARY_EXPORTS
        #define EXPORT __declspec(dllexport)
    #else
        #define EXPORT
    #endif
#else
    #define EXPORT
#endif
