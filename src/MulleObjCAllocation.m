//
//  MulleObjCAllocation.m
//  MulleObjC
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

#include "MulleObjCAllocation.h"

// other files in this library

// std-c and dependencies


int   _MulleObjCObjectReleaseProperty( struct _mulle_objc_property *property,
                                       struct _mulle_objc_infraclass *cls,
                                       void *self);

int   _MulleObjCObjectReleaseProperty( struct _mulle_objc_property *property,
                                       struct _mulle_objc_infraclass *cls,
                                       void *self)
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

   mulle_objc_throw_allocation_exception( size);
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

   mulle_objc_throw_allocation_exception( size);
   return( NULL);
}


struct mulle_allocator    mulle_allocator_objc =
{
   calloc_or_raise,
   realloc_or_raise,
   free,
   0,
   0,
   0
};
