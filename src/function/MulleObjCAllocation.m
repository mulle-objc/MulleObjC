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


// the parameters are shuffled this way, because its a walk callback

int   _MulleObjCInstanceClearProperty( struct _mulle_objc_property *property,
                                       struct _mulle_objc_infraclass *cls,
                                       void *self);

int   _MulleObjCInstanceClearProperty( struct _mulle_objc_property *property,
                                       struct _mulle_objc_infraclass *cls,
                                       void *self)
{
   uint32_t                   bits;
   ptrdiff_t                  offset;
   struct _mulle_objc_ivar    *ivar;
   mulle_objc_ivarid_t        ivarid;

   // don't clear readonly properties for (seems incompatible with Apple)
   bits = _mulle_objc_property_get_bits( property);
   if( bits & _mulle_objc_property_readonly)
      return( 0);

   if( bits & _mulle_objc_property_setterclear)
   {
      mulle_objc_object_call_variablemethodid_inline( self, property->setter, NULL);
      return( 0);
   }

   //
   // This happens for readonly properties, which have no setter.
   // They are penalized with a bsearch for the ivar.
   //
   // Why ?
   //    Readonly properties are unneccessary. Use a regular accessor.
   //    The property has no direct link to the ivar. The compiler can't emit
   //    this as the ivar could reside in the superclass.
   //    Adding the ivar at runtime into the loaded structure breaks the
   //    constness of the setup, which I'd like to keep and blows up the
   //    runtime for supporting readonly, which I find superflous and
   //    likely to be removed.
   //
   // Remedy?
   //    Compiler emits setter code for readonly properties. Let the compiler
   //    complain/warn about the missing setter.
   //
   if( bits & _mulle_objc_property_autoreleaseclear)
   {
      ivarid = _mulle_objc_property_get_ivarid( property);
      ivar   = mulle_objc_infraclass_search_ivar( cls, ivarid);
      offset = _mulle_objc_ivar_get_offset( ivar);
      mulle_objc_object_set_property_value( self, 0, offset, NULL, 0, 0);
   }
   return( 0);
}


# pragma mark - improve dealloc speed for classes that don't have properties that need to be released


int   _MulleObjCClassWalkClearableProperties( struct _mulle_objc_infraclass *infra,
                                              mulle_objc_walkpropertiescallback_t f,
                                              void *userinfo);

int   _MulleObjCClassWalkClearableProperties( struct _mulle_objc_infraclass *infra,
                                              mulle_objc_walkpropertiescallback_t f,
                                              void *userinfo)
{
   struct _mulle_objc_propertylist   *list;
   struct _mulle_objc_infraclass     *superclass;
   unsigned int                      n;
   int                               rval;

   // protocol properties are part of the class
   if( _mulle_objc_infraclass_get_state_bit( infra, MULLE_OBJC_INFRACLASS_HAS_CLEARABLE_PROPERTY))
   {
      n = mulle_concurrent_pointerarray_get_count( &infra->propertylists);
      assert( n);
      if( infra->base.inheritance & MULLE_OBJC_CLASS_DONT_INHERIT_CATEGORIES)
         n = 1;

      mulle_concurrent_pointerarray_for_reverse( &infra->propertylists, n, list)
      {
         if( (rval = _mulle_objc_propertylist_walk( list, f, infra, userinfo)))
            return( rval);
      }
   }

   // in MulleObjC the superclass is always searched
   superclass = _mulle_objc_infraclass_get_superclass( infra);
   if( superclass && superclass != infra)
      return( _MulleObjCClassWalkClearableProperties( superclass, f, userinfo));

   return( 0);
}


void   _MulleObjCInstanceClearProperties( id obj)
{
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_infraclass   *infra;

   // walk through properties and release them
   cls  = _mulle_objc_object_get_isa( obj);
   // if it's a meta class it's an error during debug
   infra = _mulle_objc_class_as_infraclass( cls);
   _MulleObjCClassWalkClearableProperties( infra,
                                           _MulleObjCInstanceClearProperty,
                                           obj);
}


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



void   MulleObjCObjectSetDuplicatedUTF8String( id self, char **ivar, char *s)
{
   struct mulle_allocator  *allocator;

   if( s == *ivar)
      return;

   allocator = MulleObjCInstanceGetAllocator( self);
   if( s)
      s = mulle_allocator_strdup( allocator, s);

   mulle_allocator_free( allocator, *ivar);
   *ivar = s;
}


void   *MulleObjCCallocAutoreleased( NSUInteger n,
                                     NSUInteger size)
{
   size_t   total;

   total = n * size;
   assert( ! total || (total >= size && total >= n));

   return( [_MulleObjCClassAllocateInstance( [NSObject class], total) autorelease]);
}
