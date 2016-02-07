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

#ifndef MULLE_OBJC_FASTCLASSID_0
# import "ns_fastclassids.h"
#endif
#ifndef MULLE_OBJC_FASTMETHODID_4
# import "ns_fastmethodids.h"
#endif

// this is the only place where mulle_objc_runtime should be included

#include <mulle_objc_runtime/mulle_objc_runtime.h>
#include <mulle_container/mulle_container.h>

#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#endif
