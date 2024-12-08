#ifndef mulle_objc__h__
#define mulle_objc__h__

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
