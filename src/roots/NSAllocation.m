//
//  NSAllocation.c
//  MulleObjC
//
//  Created by Nat! on 07.02.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#include "NSAllocation.h"


static int   zero_property( struct _mulle_objc_property *property, struct _mulle_objc_class *cls, void *self)
{
   switch( *_mulle_objc_property_get_signature( property))
   {
   case _C_COPY_ID   :
   case _C_RETAIN_ID :
      mulle_objc_object_call_no_fastmethod( self, property->setter, nil);
   }
   return( 0);
}


id   NSAllocateObject( Class meta, NSUInteger extra, NSZone *zone)
{
   return( _NSAllocateObject( meta, 0, NULL));
}


void   NSDeallocateObject( id self)
{
   // walk through properties and release them
   struct _mulle_objc_class   *cls;
   
   cls = _mulle_objc_object_get_isa( self);
   _mulle_objc_class_walk_properties( cls, _mulle_objc_class_get_inheritance( cls), zero_property, self);
   _NSDeallocateObject( self);
}
