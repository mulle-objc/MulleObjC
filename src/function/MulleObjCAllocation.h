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


__attribute__((const))
static inline struct mulle_allocator   *MulleObjCInstanceGetAllocator( id obj)
{
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_infraclass   *infra;
   struct mulle_allocator          *allocator;

   if( ! obj)
      return( NULL);

   cls   = _mulle_objc_object_get_isa( obj);
   infra = _mulle_objc_class_as_infraclass( cls);

   allocator  = _mulle_objc_infraclass_get_allocator( infra);
   return( allocator);
}


__attribute__((const))
static inline struct mulle_allocator   *MulleObjCClassGetAllocator( Class cls)
{
   struct mulle_allocator   *allocator;

   if( ! cls)
      return( NULL);

   allocator = _mulle_objc_infraclass_get_allocator( cls);
   return( allocator);
}



#pragma mark -
#pragma mark allocate memory to return char * autoreleased

void   *MulleObjCCallocAutoreleased( NSUInteger n,
                                     NSUInteger size);

#pragma mark -
#pragma mark allocate memory for objects

static inline void  *MulleObjCObjectAllocateNonZeroedMemory( id self, NSUInteger size)
{
   return( _mulle_allocator_malloc( MulleObjCInstanceGetAllocator( self), size));
}


static inline void  *MulleObjCObjectReallocateNonZeroedMemory( id self, void *p, NSUInteger size)
{
   return( _mulle_allocator_realloc( MulleObjCInstanceGetAllocator( self), p, size));
}


static inline void  *MulleObjCObjectAllocateMemory( id self, NSUInteger size)
{
   return( _mulle_allocator_calloc( MulleObjCInstanceGetAllocator( self), 1, size));
}


static inline void  *MulleObjCObjectDuplicateCString( id self, char *s)
{
   return( _mulle_allocator_strdup( MulleObjCInstanceGetAllocator( self), s));
}


static inline void  MulleObjCObjectDeallocateMemory( id self, void *p)
{
   if( p)
      _mulle_allocator_free( MulleObjCInstanceGetAllocator( self), p);
}


#pragma mark -
#pragma mark object creation


// resist the urge to add placeholder detection code here
// resist the urge to add _mulle_objc_class_setup here
__attribute__((returns_nonnull))
static inline id    _MulleObjCClassAllocateObject( Class infraCls, NSUInteger extra)
{
   return( (id) _mulle_objc_infraclass_alloc_instance_extra( infraCls, extra));
}


__attribute__((returns_nonnull))
static inline id    _MulleObjCClassAllocateNonZeroedObject( Class infraCls,
                                                            NSUInteger extra)
{
   struct _mulle_objc_objectheader   *header;
   struct mulle_allocator            *allocator;
   NSUInteger                        size;

   allocator = _mulle_objc_infraclass_get_allocator( infraCls);
   assert( allocator->realloc && "foundation has not installed an allocator");

   size   = _mulle_objc_infraclass_get_allocationsize( infraCls) + extra;
   header = _mulle_allocator_malloc( allocator, size);

   _mulle_atomic_pointer_nonatomic_write( &header->_retaincount_1, 0);
   _mulle_objc_objectheader_set_isa( header,
                                     _mulle_objc_infraclass_as_class( infraCls));
   return( (id) _mulle_objc_objectheader_get_object( header));
}


void   _MulleObjCInstanceClearProperties( id obj);


// this does not zero properties
void   _MulleObjCInstanceFree( id obj);


static inline id   NSAllocateObject( Class infra, NSUInteger extra, NSZone *zone)
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
   return( (BOOL) (obj ? _mulle_objc_object_decrement_retaincount_waszero( obj) : 0));
}


static inline NSUInteger   NSExtraRefCount( id obj)
{
   return( (NSUInteger) mulle_objc_object_get_retaincount( obj));
}


static inline BOOL    NSShouldRetainWithZone( id p, NSZone *zone)
{
   return( YES);
}


//
// convenience function for implementing _getOwnedObjects:length:
//
NSUInteger   MulleObjCCopyObjects( id *dst,
                                   NSUInteger dstCount,
                                   NSUInteger srcCount, ...);
NSUInteger   MulleObjCCopyObjectArray( id *dst,
                                       NSUInteger dstCount,
                                       id *src,
                                       NSUInteger srcCount);


// will not duplicate if *ivar == s
void   MulleObjCObjectSetDuplicatedCString( id self, char **ivar, char *s);
