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
#pragma clang diagnostic ignored "-Wparentheses"

#import "import-private.h"

#import "MulleObjCAllocation.h"

// other files in this library
#import "NSDebug.h"
#import "MulleObjCExceptionHandler.h"
#import "MulleObjCExceptionHandler-Private.h"
#import "mulle-objc-exceptionhandlertable-private.h"
#import "mulle-objc-universefoundationinfo-private.h"

// std-c and dependencies
#include <stdarg.h>


// this does not zero properties
void   _MulleObjCInstanceFree( id obj)
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_infraclass               *infra;
   struct _mulle_objc_class                    *cls;
   struct mulle_allocator                      *allocator;

   cls      = _mulle_objc_object_get_isa( obj);
   universe = _mulle_objc_class_get_universe( cls);
   config   = _mulle_objc_universe_get_universefoundationinfo( universe);

   assert( ! _mulle_objc_object_is_constant( obj));

   if( config->object.zombieenabled)
   {
      MulleObjCZombifyObject( obj, config->object.shredzombie);
      if( ! config->object.deallocatezombie)
         return;
   }

   // if it's a meta class it's an error during debug
   assert( _mulle_objc_class_is_infraclass( cls));

   infra     = _mulle_objc_class_as_infraclass( cls);
   allocator = MulleObjCInstanceGetAllocator( obj);
   _mulle_objc_infraclass_allocator_free_instance( infra, obj, allocator);
}


void   NSDeallocateObject( id self)
{
   if( self)
      _MulleObjCInstanceFree( self);
}





void   *MulleObjCCallocAutoreleased( NSUInteger n,
                                     NSUInteger size)
{
   size_t   total;

   total = n * size;
   assert( ! total || (total >= size && total >= n));

   return( [_MulleObjCClassAllocateInstance( [NSObject class], total) autorelease]);
}
