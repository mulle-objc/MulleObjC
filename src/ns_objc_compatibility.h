//
//  ns_objc_compatibility.h
//  MulleObjC
//
//  Created by Nat! on 07.08.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#ifndef ns_objc_compatibility_h__
#define ns_objc_compatibility_h__

#include "ns_objc_include.h"


// define some often used "Apple" runtime functions
static inline void   objc_setClass( id obj, Class cls)
{
   _mulle_objc_object_set_isa( obj, (struct _mulle_objc_class *) cls);
}


static inline Class   objc_getClass( id obj)
{
   return( (Class) _mulle_objc_object_get_isa( obj));
}

#endif /* mulle_apple_compatibility_h */
