//
//  ns_objc_include.h
//  MulleObjC
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//

/* THIS IS THE INCLUDE FILE USED BY "OUTSIDE OF PROJECT" FILES */

#ifndef ns_objc_include__h__
#define ns_objc_include__h__

// if the "real" foundation has defined this, don't use the builtin stuff

#ifndef MULLE_OBJC_FASTCLASSHASH_0
# include "ns_fastclassids.h"
#endif
#ifndef MULLE_OBJC_FASTMETHODHASH_8
# include "ns_fastmethodids.h"
#endif

// this is the only place where mulle_objc_runtime should be included

#include <mulle-objc-runtime/mulle-objc-runtime.h>

#include "dependencies.h"
#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <limits.h>


#ifdef __clang__
# if defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) && ((__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__-0) <= 1040)
#  if ! __DARWIN_UNIX03
#   warning "compiling for 10.4 (not __DARWIN_UNIX03), with __eprintf"
#  endif
# endif
#endif

#if MULLE_OBJC_RUNTIME_VERSION < ((0 << 20) | (8 << 8) | 3)
# error "mulle_objc_runtume is too old"
#endif
#if MULLE_CONCURRENT_VERSION < ((1 << 20) | (3 << 8) | 0)
# error "mulle_concurrent is too old"
#endif
#if MULLE_CONTAINER_VERSION < ((0 << 20) | (8 << 8) | 0)
# error "mulle_container is too old"
#endif
#if MULLE_ALLOCATOR_VERSION < ((2 << 20) | (1 << 8) | 0)
# error "mulle_allocator is too old"
#endif
#if MULLE_VARARG_VERSION < ((0 << 20) | (5 << 8) | 0)
# error "mulle_allocator is too old"
#endif
#if MULLE_THREAD_VERSION < ((3 << 20) | (3 << 8) | 0)
# error "mulle_thread is too old"
#endif


#endif
