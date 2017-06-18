//
//  MulleObjCAllocation.h
//  MulleObjC
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#ifndef NSALLOCATION_OBJECTIVE_C_H___
#define NSALLOCATION_OBJECTIVE_C_H___

#include "ns_objc_type.h"
#include "ns_int_type.h"
#include "ns_debug.h"
#include "ns_zone.h"
#include "ns_rootconfiguration.h"

#import "NSDebug.h"


extern struct mulle_allocator    mulle_allocator_objc;


__attribute__((const))
static inline struct mulle_allocator   *MulleObjCObjectGetAllocator( id obj)
{
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_universe      *universe;
   struct _mulle_objc_foundation   *foundation;

   if( ! obj)
      return( NULL);

   cls        = _mulle_objc_object_get_isa( obj);
   universe    = _mulle_objc_class_get_universe( cls);
   foundation = _mulle_objc_universe_get_foundation( universe);
   return( &foundation->allocator);
}


__attribute__((const))
static inline struct mulle_allocator   *MulleObjCClassGetAllocator( Class cls)
{
   struct _mulle_objc_universe      *universe;
   struct _mulle_objc_foundation   *foundation;

   if( ! cls)
      return( NULL);

   universe    = _mulle_objc_class_get_universe( (struct _mulle_objc_class *) cls);
   foundation = _mulle_objc_universe_get_foundation( universe);
   return( &foundation->allocator);
}


#pragma mark -
#pragma mark allocate memory for objects

static inline void  *MulleObjCObjectAllocateNonZeroedMemory( id self, NSUInteger size)
{
   return( _mulle_allocator_malloc( MulleObjCObjectGetAllocator( self), size));
}


static inline void  *MulleObjCObjectReallocateNonZeroedMemory( id self, void *p, NSUInteger size)
{
   return( _mulle_allocator_realloc( MulleObjCObjectGetAllocator( self), p, size));
}


static inline void  *MulleObjCObjectAllocateMemory( id self, NSUInteger size)
{
   return( _mulle_allocator_calloc( MulleObjCObjectGetAllocator( self), 1, size));
}


static inline void  *MulleObjCObjectDuplicateCString( id self, char *s)
{
   return( _mulle_allocator_strdup( MulleObjCObjectGetAllocator( self), s));
}


static inline void  MulleObjCObjectDeallocateMemory( id self, void *p)
{
   if( p)
      _mulle_allocator_free( MulleObjCObjectGetAllocator( self), p);
}


#pragma mark -
#pragma mark object creation

__attribute__((returns_nonnull))
static inline id    _MulleObjCClassAllocateObject( Class infraCls, NSUInteger extra)
{
   struct mulle_allocator     *allocator;

   allocator = _mulle_objc_infraclass_get_allocator( infraCls);
   return( (id) _mulle_objc_infraclass_alloc_instance_extra( infraCls, extra, allocator));
}


__attribute__((returns_nonnull))
static inline id    _MulleObjCClassAllocateNonZeroedObject( Class infraCls,
                                                            NSUInteger extra)
{
   struct _mulle_objc_objectheader   *header;
   struct mulle_allocator            *allocator;
   NSUInteger                        size;
   struct _mulle_objc_class          *cls;

   cls = _mulle_objc_infraclass_as_class( infraCls);

   assert( cls);
   assert( _mulle_objc_class_is_infraclass( cls));

   allocator = _mulle_objc_class_get_allocator( cls);

   size   = _mulle_objc_class_get_allocationsize( cls) + extra;
   header = _mulle_allocator_malloc( allocator, size);

   _mulle_atomic_pointer_nonatomic_write( &header->_retaincount_1, 0);
   _mulle_objc_objectheader_set_isa( header, cls);
   return( (id) _mulle_objc_objectheader_get_object( header));
}


static inline void   _MulleObjCObjectReleaseProperties( id obj)
{
   extern int   _MulleObjCObjectReleaseProperty( struct _mulle_objc_property *,
                                                 struct _mulle_objc_infraclass *cls,
                                                 void *);
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_infraclass   *infra;

   // walk through properties and release them
   cls  = _mulle_objc_object_get_isa( obj);

   // if it's a meta class it's an error during debug
   assert( _mulle_objc_class_is_infraclass( cls));

   if( _mulle_objc_class_is_infraclass( cls))
   {
      infra = _mulle_objc_class_as_infraclass( cls);
      _mulle_objc_infraclass_walk_properties( infra,
                                             _mulle_objc_class_get_inheritance( cls),
                                             _MulleObjCObjectReleaseProperty,
                                             obj);
   }
}


// this does not zero properties
static inline void   _MulleObjCObjectFree( id obj)
{
   struct _mulle_objc_objectheader   *header;
   struct _ns_rootconfiguration      *config;
   struct mulle_allocator            *allocator;
   struct _mulle_objc_universe        *universe;

   universe = _mulle_objc_object_get_universe( obj);
   config  = _mulle_objc_universe_get_foundationdata( universe);
   if( config->object.zombieenabled)
   {
      MulleObjCZombifyObject( obj);
      if( ! config->object.deallocatezombies)
         return;
   }

   allocator = _mulle_objc_class_get_allocator( _mulle_objc_object_get_isa( obj));
   header    = _mulle_objc_object_get_objectheader( obj);
#if DEBUG
   // malloc scribble will kill it though
   memset( obj, 0xad, _mulle_objc_class_get_instancesize( header->_isa));

   header->_isa = (void *) (intptr_t) 0xDEADDEADDEADDEAD;
   _mulle_atomic_pointer_nonatomic_write( &header->_retaincount_1, 0x0); // sic
#endif
   _mulle_allocator_free( allocator, header);
}


static inline id     NSAllocateObject( Class infra, NSUInteger extra, NSZone *zone)
{
   return( _MulleObjCClassAllocateObject( infra, extra));
}


void   NSDeallocateObject( id obj);


// implement the convenience stuff
// we don't go through a configuration, because we later have atomicity
// which is "harmless" as its faster than a function call
//
static inline void   NSIncrementExtraRefCount( id obj)
{
   _mulle_objc_object_increment_retaincount( obj);
}


static inline BOOL  NSDecrementExtraRefCountWasZero( id obj)
{
   return( (BOOL) (obj ? _mulle_objc_object_decrement_retaincount_was_zero( obj) : 0));
}


static inline NSUInteger   NSExtraRefCount( id obj)
{
   return( (NSUInteger) mulle_objc_object_get_retaincount( obj));
}


static inline BOOL    NSShouldRetainWithZone( id p, NSZone *zone)
{
   return( YES);
}

#endif
