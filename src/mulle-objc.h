//
//  mulle-objc.h
//  MulleObjC
//
//  Copyright (c) 2018 Nat! - Mulle kybernetiK.
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
#ifndef mulle_objc__h__
#define mulle_objc__h__

// load this before windows.h
#include <mulle-objc-runtime/mulle-objc-c-types.h>

#include "include.h"

//
// this file includes the runtime, it suitable for C and ObjC code
// that will link against the runtime.
//
// THIS IS THE ONLY PLACE THAT AN OBJC SOURCE SHOULD INCLUDE THE RUNTIME
//
#ifndef MULLE_OBJC_FASTCLASSHASH_0
# include "mulle-objc-fastclassid.h"
#endif
#ifndef MULLE_OBJC_FASTMETHODHASH_8
# include "mulle-objc-fastmethodid.h"
#endif

#include <mulle-objc-runtime/mulle-objc-runtime.h>


#include "minimal.h" 

// additional stuff requiring the runtime
#include "mulle-objc-atomicid.h"
#include "mulle-objc-classbit.h"
#include "mulle-objc-threadfoundationinfo.h"

//
// useful for asserts.. here for reasons...
//
static inline BOOL   MulleObjCClassMetaClass( Class cls)
{
   return( mulle_objc_class_is_metaclass( (struct _mulle_objc_class *) cls));
}


static inline BOOL   MulleObjCObjectIsClass( id obj)
{
   struct _mulle_objc_class  *cls;

   cls =  mulle_objc_object_get_isa( obj);
   return( mulle_objc_class_is_metaclass( cls));
}


static inline BOOL   MulleObjCObjectIsClassOrNil( id obj)
{
   struct _mulle_objc_class  *cls;

   cls =  mulle_objc_object_get_isa( obj);
   return( ! mulle_objc_class_is_infraclass( cls));
}


static inline BOOL   MulleObjCObjectIsInstance( id obj)
{
   struct _mulle_objc_class  *cls;

   cls = mulle_objc_object_get_isa( obj);
   return( mulle_objc_class_is_infraclass( cls));
}


static inline BOOL   MulleObjCObjectIsInstanceOrNil( id obj)
{
   struct _mulle_objc_class  *cls;

   cls =  mulle_objc_object_get_isa( obj);
   return( ! mulle_objc_class_is_metaclass( cls));
}


#include "MulleObjCAllocation.h"
#include "MulleObjCAutoreleasePool.h"
#include "MulleObjCExceptionHandler.h"
#include "MulleObjCFunctions.h"
#include "MulleObjCContainerObjectCallback.h"
#include "MulleObjCPrinting.h"
#include "MulleObjCUniverse.h"


#ifdef __has_include
# if __has_include( "_MulleObjC-versioncheck.h")
#  include "_MulleObjC-versioncheck.h"
# endif
#endif

#endif
