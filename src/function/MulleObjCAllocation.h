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
#include "mulle-objc.h"

#include <stdarg.h>


#ifndef MULLE_OBJC_EMBEDDED_ALLOCATOR
MULLE_C_CONST_RETURN
#endif
static inline struct mulle_allocator   *MulleObjCInstanceGetAllocator( id obj)
{
   struct mulle_allocator   *allocator;

   if( ! obj)
      return( NULL);

#ifdef MULLE_OBJC_EMBEDDED_ALLOCATOR
   void   **p_allocator;

   // the embedded allocator has to be the top entry in the
   // extended object header
   p_allocator = *(void **) _mulle_objc_objectheader_get_alloc( obj);
   // if the objectheader is at the same address, the metaheader is too small
   assert( (uintptr_t) p_allocator < (uintptr_t) _mulle_objc_object_get_objectheader( obj));
   allocator = *p_allocator;
#else
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_infraclass   *infra;

   cls       = _mulle_objc_object_get_isa( obj);
   infra     = _mulle_objc_class_as_infraclass( cls);
   allocator = _mulle_objc_infraclass_get_allocator( infra);
#endif

   assert( allocator);
   return( allocator);
}


#ifndef MULLE_OBJC_EMBEDDED_ALLOCATOR
MULLE_C_CONST_RETURN
#endif
static inline struct mulle_allocator   *MulleObjCClassGetAllocator( Class cls)
{
   struct mulle_allocator   *allocator;

   if( ! cls)
      return( NULL);

#ifdef MULLE_OBJC_EMBEDDED_ALLOCATOR
   struct _mulle_objc_threadfoundationinfo   *info;
   struct _mulle_objc_universe               *universe;

   universe  = _mulle_objc_infraclass_get_universe( cls);
   info      = mulle_objc_thread_get_threadfoundationinfo( universe);
   allocator = info->instance_allocator;
   if( allocator)
      return( allocator);
#endif
   allocator = _mulle_objc_infraclass_get_allocator( cls);
   return( allocator);
}


static inline void   MulleObjCThreadSetAllocator( struct mulle_allocator *allocator)
{
   struct _mulle_objc_threadfoundationinfo   *info;
   struct _mulle_objc_universe               *universe;

   universe = mulle_objc_global_get_universe_inline( __MULLE_OBJC_UNIVERSEID__);
   info     = mulle_objc_thread_get_threadfoundationinfo( universe);

   info->instance_allocator = allocator;
}


MULLE_C_CONST_RETURN
static inline struct mulle_allocator   *MulleObjCThreadGetAllocator( void)
{
   struct _mulle_objc_threadfoundationinfo   *info;
   struct _mulle_objc_universe               *universe;

   universe = mulle_objc_global_get_universe_inline( __MULLE_OBJC_UNIVERSEID__);
   info     = mulle_objc_thread_get_threadfoundationinfo( universe);

   return( info->instance_allocator);
}


#pragma mark - allocate memory to return char * autoreleased

MULLE_OBJC_GLOBAL
void   *MulleObjCCallocAutoreleased( NSUInteger n,
                                     NSUInteger size);


#pragma mark - allocate memory for objects

static inline void  *MulleObjCInstanceAllocateNonZeroedMemory( id self, NSUInteger size)
{
   return( _mulle_allocator_malloc( MulleObjCInstanceGetAllocator( self), size));
}


static inline void  *MulleObjCInstanceReallocateNonZeroedMemory( id self, void *p, NSUInteger size)
{
   return( _mulle_allocator_realloc( MulleObjCInstanceGetAllocator( self), p, size));
}


static inline void  *MulleObjCInstanceAllocateMemory( id self, NSUInteger size)
{
   return( _mulle_allocator_calloc( MulleObjCInstanceGetAllocator( self), 1, size));
}


static inline void  *MulleObjCInstanceDuplicateUTF8String( id self, char *s)
{
   return( _mulle_allocator_strdup( MulleObjCInstanceGetAllocator( self), s));
}


static inline void  MulleObjCInstanceDeallocateMemory( id self, void *p)
{
   if( p)
      _mulle_allocator_free( MulleObjCInstanceGetAllocator( self), p);
}


#pragma mark - allocate memory for class methods

static inline void  *MulleObjCClassAllocateNonZeroedMemory( Class cls, NSUInteger size)
{
   return( _mulle_allocator_malloc( MulleObjCClassGetAllocator( cls), size));
}


static inline void  *MulleObjCClassReallocateNonZeroedMemory( Class cls, void *p, NSUInteger size)
{
   return( _mulle_allocator_realloc( MulleObjCClassGetAllocator( cls), p, size));
}


static inline void  *MulleObjCClassAllocateMemory( Class cls, NSUInteger size)
{
   return( _mulle_allocator_calloc( MulleObjCClassGetAllocator( cls), 1, size));
}


static inline void  *MulleObjCClassDuplicateUTF8String( Class cls, char *s)
{
   return( _mulle_allocator_strdup( MulleObjCClassGetAllocator( cls), s));
}


static inline void  MulleObjCClassDeallocateMemory( Class cls, void *p)
{
   if( p)
      _mulle_allocator_free( MulleObjCClassGetAllocator( cls), p);
}


#pragma mark - object creation

// resist the urge to add placeholder detection code here
// resist the urge to add _mulle_objc_class_setup here
MULLE_C_NONNULL_RETURN
static inline id    _MulleObjCClassAllocateInstance( Class infraCls, NSUInteger extra)
{
   struct mulle_allocator   *allocator;
   void                     *obj;

   allocator = MulleObjCClassGetAllocator( infraCls);
   obj       = _mulle_objc_infraclass_allocator_alloc_instance_extra( infraCls,
                                                                      extra,
                                                                      allocator);
   return( (id) obj);
}


MULLE_C_NONNULL_RETURN
static inline id    _MulleObjCClassAllocateNonZeroedObject( Class infraCls,
                                                            NSUInteger extra)
{
   struct mulle_allocator   *allocator;
   void                     *obj;

   allocator = MulleObjCClassGetAllocator( infraCls);
   obj       = _mulle_objc_infraclass_allocator_alloc_instance_extra_nonzeroed( infraCls,
                                                                                extra,
                                                                                allocator);
   return( (id) obj);
}

// this does not zero properties
MULLE_OBJC_GLOBAL
void   _MulleObjCInstanceFree( id obj);


// resist the urge to add placeholder detection code here
// resist the urge to add _mulle_objc_class_setup here
MULLE_C_NONNULL_RETURN
static inline id    _MulleObjCClassAllocateInstanceWithAllocator( Class infraCls,
                                                                  NSUInteger extra,
                                                                  struct mulle_allocator *allocator)
{
   void   *obj;

   obj = _mulle_objc_infraclass_allocator_alloc_instance_extra( infraCls,
                                                                extra,
                                                                allocator);
   return( (id) obj);
}


MULLE_C_NONNULL_RETURN
static inline id    _MulleObjCClassAllocateNonZeroedObjectWithAllocator( Class infraCls,
                                                                         NSUInteger extra,
                                                                         struct mulle_allocator *allocator)
{
   void   *obj;

   obj = _mulle_objc_infraclass_allocator_alloc_instance_extra_nonzeroed( infraCls,
                                                                          extra,
                                                                          allocator);
   return( (id) obj);
}


// legacy naming scheme, should be AllocateInstance really
static inline id   NSAllocateObject( Class infra, NSUInteger extra, NSZone *zone)
{
   return( infra ? _MulleObjCClassAllocateInstance( infra, extra) : nil);
}


// legacy naming scheme, should be DeallocateInstance really
MULLE_OBJC_GLOBAL
void   NSDeallocateObject( id obj);



//
// The returned value is the size you need to provde to create an instance
// The start address is not the address of the object though! The object
// lives at an offset. See function below.
//
static inline NSUInteger  MulleObjCClassGetInstanceSize( Class infra)
{
   if( ! infra)
      return( 0);
   return( _mulle_objc_infraclass_get_allocationsize( infra));
}


static inline id   MulleObjCClassConstructInstance( Class infra,
                                                    void *bytes,
                                                    size_t length,
                                                    BOOL isZeroed)
{
   void                             *obj;
   struct _mulle_objc_objectheader  *header;
   struct _mulle_objc_class         *cls;

   if( ! infra)
      return( nil);

   assert( length >= _mulle_objc_infraclass_get_allocationsize( infra));

   cls = _mulle_objc_infraclass_as_class( infra);
   header = _mulle_objc_alloc_get_objectheader( bytes, cls->headerextrasize);
   _mulle_objc_objectheader_init( header, cls, cls->headerextrasize, isZeroed);
   obj    = _mulle_objc_objectheader_get_object( header);
   if( ! isZeroed)
      memset( obj, 0, length - cls->headerextrasize - sizeof( struct _mulle_objc_objectheader));
   return( obj);
}


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
   return( (BOOL) (obj ? _mulle_objc_object_decrement_retaincount_waszero( obj) : 0));
}


static inline NSUInteger   NSExtraRefCount( id obj)
{
   return( (NSUInteger) mulle_objc_object_get_retaincount( obj));
}


static inline BOOL    NSShouldRetainWithZone( id p, NSZone *zone)
{
   return( NO);
}


// TODO: these should die
// convenience function for implementing _getOwnedObjects:length:
//
static inline NSUInteger   MulleObjCCopyObjects( id *objects,
                                                 NSUInteger length,
                                                 NSUInteger count, ...)
{
   va_list      args;
   id           *sentinel;
   id           obj;
   NSUInteger   n;

   assert( objects || ! length);

   sentinel = &objects[ length];
   n        = 0;

   va_start( args, count);
   while( count)
   {
      obj = va_arg( args, id);
      if( obj)
      {
         ++n;
         if( objects < sentinel)
            *objects++ = obj;
      }
      --count;
   }
   va_end( args);

   return( n);
}


static inline NSUInteger   MulleObjCCopyObjectArray( id *objects,
                                                     NSUInteger length,
                                                     id *array,
                                                     NSUInteger count)
{
   id           *sentinel;
   id           obj;
   NSUInteger   n;

   assert( objects || ! length);

   sentinel = &objects[ length];
   n        = 0;

   while( count)
   {
      obj = *array++;
      if( obj)
      {
         ++n;
         if( objects < sentinel)
            *objects++ = obj;
      }
      --count;
   }

   return( n);
}

