/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSAllocation+ObjectiveC.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#ifndef NSALLOCATION_OBJECTIVE_C_H___
#define NSALLOCATION_OBJECTIVE_C_H___

#import "ns_type.h"
#import "ns_debug.h"
#import "ns_zone.h"

#import "NSDebug.h"


extern struct mulle_allocator    mulle_allocator_objc;


__attribute__((const))
static inline struct mulle_allocator   *MulleObjCObjectGetAllocator( id obj)
{
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_runtime      *runtime;
   struct _mulle_objc_foundation   *foundation;
   
   if( ! obj)
      return( NULL);
   
   cls        = _mulle_objc_object_get_isa( obj);
   runtime    = _mulle_objc_class_get_runtime( cls);
   foundation = _mulle_objc_runtime_get_foundation( runtime);
   return( &foundation->allocator);
}


__attribute__((const))
static inline struct mulle_allocator   *MulleObjCClassGetAllocator( Class cls)
{
   struct _mulle_objc_runtime      *runtime;
   struct _mulle_objc_foundation   *foundation;

   if( ! cls)
      return( NULL);
   
   runtime    = _mulle_objc_class_get_runtime( (struct _mulle_objc_class *) cls);
   foundation = _mulle_objc_runtime_get_foundation( runtime);
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
static inline id    _MulleObjCClassAllocateObject( Class cls, NSUInteger extra)
{
   struct _mulle_objc_objectheader   *header;
   struct mulle_allocator            *allocator;
   NSUInteger                        size;
   
   assert( cls);
   assert( _mulle_objc_class_is_infraclass( cls));

   allocator = _mulle_objc_class_get_allocator( cls);
   
   size      = _mulle_objc_class_get_instance_and_header_size( cls) + extra;
   header    = _mulle_allocator_calloc( allocator, 1, size);

   _mulle_objc_objectheader_set_isa( header, cls);
   return( (id) _mulle_objc_objectheader_get_object( header));
}


__attribute__((returns_nonnull))
static inline id    _MulleObjCClassAllocateNonZeroedObject( Class cls, NSUInteger extra)
{
   struct _mulle_objc_objectheader   *header;
   struct mulle_allocator            *allocator;
   NSUInteger                        size;
   
   assert( cls);
   assert( _mulle_objc_class_is_infraclass( cls));
   
   allocator = _mulle_objc_class_get_allocator( cls);

   size   = _mulle_objc_class_get_instance_and_header_size( cls) + extra;
   header = _mulle_allocator_malloc( allocator, size);
   
   _mulle_atomic_pointer_nonatomic_write( &header->_retaincount_1, 0);
   _mulle_objc_objectheader_set_isa( header, cls);
   return( (id) _mulle_objc_objectheader_get_object( header));
}


static inline void   _MulleObjCObjectReleaseProperties( id obj)
{
   extern int   _MulleObjCObjectReleaseProperty( struct _mulle_objc_property *, struct _mulle_objc_class *, void *);
   struct _mulle_objc_class   *cls;
   
   // walk through properties and release them
   cls = _mulle_objc_object_get_isa( obj);
   _mulle_objc_class_walk_properties( cls, _mulle_objc_class_get_inheritance( cls), _MulleObjCObjectReleaseProperty, obj);
}


// this does not zero properties
static inline void   _MulleObjCObjectFree( id obj)
{
   struct _mulle_objc_objectheader   *header;
   struct _ns_rootconfiguration      *config;
   struct mulle_allocator            *allocator;
   struct _mulle_objc_runtime        *runtime;
   
   runtime = _mulle_objc_object_get_runtime( obj);
   config  = _mulle_objc_runtime_get_foundationdata( runtime);
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
   memset( obj, 0xad, _mulle_objc_class_get_instance_size( header->_isa));
   
   header->_isa           = (void *) (intptr_t) 0xDEADDEADDEADDEAD;
   header->_retaincount_1 = (void *) (intptr_t) 0x0; // sic
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

