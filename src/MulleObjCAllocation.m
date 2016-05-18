//
//  MulleObjCAllocation.c
//  MulleObjC
//
//  Created by Nat! on 07.02.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#include "MulleObjCAllocation.h"

// other files in this library

// std-c and dependencies


int   _MulleObjCObjectReleaseProperty( struct _mulle_objc_property *property, struct _mulle_objc_class *cls, void *self);

int   _MulleObjCObjectReleaseProperty( struct _mulle_objc_property *property, struct _mulle_objc_class *cls, void *self)
{
   if( property->clearer)
      mulle_objc_object_inline_variable_methodid_call( self, property->clearer, NULL);
   return( 0);
}


void   NSDeallocateObject( id self)
{
   if( self)
      _MulleObjCObjectFree( self);
}


#pragma mark -
#pragma mark allocator for

static void  *calloc_or_raise( size_t n, size_t size)
{
   void     *p;
   
   p = calloc( n, size);
   if( p)
      return( p);

   size *= n;
   if( ! size)
      return( p);
   
   MulleObjCThrowAllocationException( size);
   return( NULL);
}


static void  *realloc_or_raise( void *block, size_t size)
{
   void   *p;
   
   p = realloc( block, size);
   if( p)
      return( p);

   if( ! size)
      return( p);
   
   MulleObjCThrowAllocationException( size);
   return( NULL);
}


struct mulle_allocator    mulle_allocator_objc =
{
   calloc_or_raise,
   realloc_or_raise,
   free,
   0,
   0
};


