/*
 *  MulleObjCRootsParentIncludes.h
 *  MulleFoundation
 *
 *  Created by Nat! on 19.08.11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

/* THIS IS THE INCLUDE FILE USED BY "OUTSIDE OF PROJECT" FILES */

#ifndef ns_objc_include__h__
#define ns_objc_include__h__

// if the "real" foundation has defined this, don't use the builtin stuff

#ifndef MULLE_OBJC_FASTCLASSHASH_0
# import "ns_fastclassids.h"
#endif
#ifndef MULLE_OBJC_FASTMETHODHASH_8
# import "ns_fastmethodids.h"
#endif

// this is the only place where mulle_objc_runtime should be included

#include <mulle_objc_runtime/mulle_objc_runtime.h>
#include <mulle_container/mulle_container.h>
#include <mulle_allocator/mulle_allocator.h>

#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#if MULLE_OBJC_RUNTIME_VERSION < ((1 << 20) | (0 << 8) | 0)
# error "mulle_objc_runtime is too old"
#endif
#if MULLE_CONTAINER_VERSION < ((0 << 20) | (0 << 8) | 0)
# error "mulle_container is too old"
#endif
#if MULLE_ALLOCATOR_VERSION < ((0 << 20) | (1 << 8) | 0)
# error "mulle_allocator is too old"
#endif

#endif
