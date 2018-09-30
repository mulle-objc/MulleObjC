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


int   _MulleObjCObjectClearProperty( struct _mulle_objc_property *property,
                                     struct _mulle_objc_infraclass *cls,
                                     void *self);

int   _MulleObjCObjectClearProperty( struct _mulle_objc_property *property,
                                     struct _mulle_objc_infraclass *cls,
                                     void *self)
{
   if( property->clearer)
      mulle_objc_object_inlinecall_variablemethodid( self, property->clearer, NULL);
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

   __mulle_objc_universe_raise_failedallocation( NULL, size);
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

   __mulle_objc_universe_raise_failedallocation( NULL, size);
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


# pragma mark - improve dealloc speed for classes that don't have properties that need to be released


int   _MulleObjCInfraclassWalkClearableProperties( struct _mulle_objc_infraclass *infra,
                                                    mulle_objc_walkpropertiescallback f,
                                                    void *userinfo);

int   _MulleObjCInfraclassWalkClearableProperties( struct _mulle_objc_infraclass *infra,
                                                    mulle_objc_walkpropertiescallback f,
                                                    void *userinfo)
{
   int                                                     rval;
   struct _mulle_objc_propertylist                         *list;
   struct mulle_concurrent_pointerarrayreverseenumerator   rover;
   unsigned int                                            n;
   struct _mulle_objc_infraclass                           *superclass;

   // protocol properties are part of the class
   if( _mulle_objc_infraclass_get_state_bit( infra, MULLE_OBJC_INFRACLASS_HAS_CLEARABLE_PROPERTY))
   {
      n = mulle_concurrent_pointerarray_get_count( &infra->propertylists);
      assert( n);
      if( infra->base.inheritance & MULLE_OBJC_CLASS_DONT_INHERIT_CATEGORIES)
         n = 1;

      rover = mulle_concurrent_pointerarray_reverseenumerate( &infra->propertylists, n);
      while( list = _mulle_concurrent_pointerarrayreverseenumerator_next( &rover))
      {
         if( rval = _mulle_objc_propertylist_walk( list, f, infra, userinfo))
            return( rval);
      }
   }

   // in MulleObjC the superclass is always searched
   superclass = _mulle_objc_infraclass_get_superclass( infra);
   if( superclass && superclass != infra)
      return( _MulleObjCInfraclassWalkClearableProperties( superclass, f, userinfo));

   return( 0);
}



void   _MulleObjCObjectClearProperties( id obj)
{
   extern int   _MulleObjCObjectClearProperty( struct _mulle_objc_property *,
                                               struct _mulle_objc_infraclass *cls,
                                               void *);
   extern int   _MulleObjCInfraclassWalkClearableProperties( struct _mulle_objc_infraclass *,
                                                             mulle_objc_walkpropertiescallback,
                                                             void *);

   struct _mulle_objc_class        *cls;
   struct _mulle_objc_infraclass   *infra;

   // walk through properties and release them
   cls  = _mulle_objc_object_get_isa( obj);
   // if it's a meta class it's an error during debug
   infra = _mulle_objc_class_as_infraclass( cls);
   _MulleObjCInfraclassWalkClearableProperties( infra,
                                                 _MulleObjCObjectClearProperty,
                                                 obj);
}


// this does not zero properties
void   _MulleObjCObjectFree( id obj)
{
   struct _mulle_objc_objectheader   *header;
   struct _mulle_objc_universefoundationinfo      *config;
   struct mulle_allocator            *allocator;
   struct _mulle_objc_universe       *universe;
   struct _mulle_objc_infraclass     *infra;
   struct _mulle_objc_class          *cls;

   cls      = _mulle_objc_object_get_isa( obj);
   universe = _mulle_objc_class_get_universe( cls);
   config   = _mulle_objc_universe_get_universefoundationinfo( universe);
   if( config->object.zombieenabled)
   {
      MulleObjCZombifyObject( obj);
      if( ! config->object.deallocatezombies)
         return;
   }

   // if it's a meta class it's an error during debug
   assert( _mulle_objc_class_is_infraclass( cls));
   infra     = _mulle_objc_class_as_infraclass( cls);
   allocator = _mulle_objc_infraclass_get_allocator( infra);
   header    = _mulle_objc_object_get_objectheader( obj);
#if DEBUG
   // malloc scribble will kill it though
   memset( obj, 0xad, _mulle_objc_class_get_instancesize( header->_isa));

   header->_isa = (void *) (intptr_t) 0xDEADDEADDEADDEAD;
   _mulle_atomic_pointer_nonatomic_write( &header->_retaincount_1, 0x0); // sic
#endif
   _mulle_allocator_free( allocator, header);
}
