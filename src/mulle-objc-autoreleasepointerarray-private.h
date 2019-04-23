//
//  _ns-autoreleasepointerarray.h
//  MulleObjC
//
//  Copyright (c) 2012 Nat! - Mulle kybernetiK.
//  Copyright (c) 2012 Codeon GmbH.
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
#ifndef mulle_objc_autoreleasepointerarray__h___
#define mulle_objc_autoreleasepointerarray__h___


#include <stdio.h>


// for an NSAutoreleasePool we'd like to allocate two memory pages (8k)
// so that's
//  sizeof( NSAutoreleasePool) == 2 * sizeof( intptr_t)
//  sizeof( struct _mulle_objc_objectheader) == 2 * sizeof( intptr_t))
//  sizeof( struct _mulle_autoreleasepointerarray)
// == 8192
//
#define MULLE_OBJC_TWOPAGES_LESS_AUTORELEASE_POOL   (4096 * 2 - 4 * sizeof( intptr_t))

#define MULLE_AUTORELEASEPOINTERARRRAY_N_OBJECTS    ((MULLE_OBJC_TWOPAGES_LESS_AUTORELEASE_POOL - 2 * sizeof( intptr_t)) / sizeof( id))



struct _mulle_autoreleasepointerarray
{
   struct _mulle_autoreleasepointerarray   *previous_;
   NSUInteger                              used_;
   id                                      objects_[ MULLE_AUTORELEASEPOINTERARRRAY_N_OBJECTS];
};


static inline struct _mulle_autoreleasepointerarray *
   _mulle_autoreleasepointerarray_create( struct _mulle_autoreleasepointerarray *previous)
{
   struct _mulle_autoreleasepointerarray  *array;

   array = mulle_malloc( sizeof( struct _mulle_autoreleasepointerarray));

#if AUTORELEASEPOOL_DEBUG
   fprintf( stderr, "[pool] _mulle_autoreleasepointerarray %p allocated (previous = %p)\n", array, previous);
#endif

   array->used_     = 0;
   array->previous_ = previous;

   return( array);
}


static inline void
   _mulle_autoreleasepointerarray_release_and_free(
                               struct _mulle_autoreleasepointerarray *end,
                               struct _mulle_autoreleasepointerarray *staticStorage,
                               struct mulle_map *object_map)
{
   struct _mulle_autoreleasepointerarray   *p, *q;
   id                                      *objects;
   id                                      *sentinel;
   NSUInteger                              value;
   id                                      opfer;

   for( p = end; p; p = q)
   {
      q            = p->previous_;
      p->previous_ = NULL;

      // release in reverse fashion, because that should be better for the
      // memory manager
      objects  = &p->objects_[ p->used_];
      sentinel = p->objects_;

      if( object_map)
      {
         while( objects > sentinel)
         {
            opfer = *--objects;
            value = (NSUInteger) mulle_map_get( object_map, opfer);
            assert( value && "object appeared in pool out of nowhere");
            --value;

            if( ! value)
               mulle_map_remove( object_map, opfer);
            else
               mulle_map_set( object_map, opfer, (void *) value);
            mulle_objc_object_release( opfer);
         }
      }
      else
         while( objects > sentinel)
            mulle_objc_object_release( *--objects);

      if( p != staticStorage)
      {
#if AUTORELEASEPOOL_DEBUG
         fprintf( stderr, "[pool] _mulle_autoreleasepointerarray %p deallocated (previous = %p)\n", p, q);
#endif
         mulle_free( p);
      }
   }
}


static inline void
   _mulle_autoreleasepointerarray_dump_objects(
                               struct _mulle_autoreleasepointerarray *end,
                               struct _mulle_autoreleasepointerarray *staticStorage)
{
   id                                      *objects;
   id                                      *sentinel;
   struct _mulle_autoreleasepointerarray   *p, *q;

   for( p = end; p; p = q)
   {
      q = p->previous_;

      objects  = p->objects_;
      sentinel = &p->objects_[ p->used_];
      while( objects < sentinel)
      {
         fprintf( stderr, "[pool] %p released (RC: %ld)\n",
                              *objects,
                              mulle_objc_object_get_retaincount( *objects));
         objects++;
      }
   }
}



static inline BOOL
   _mulle_autoreleasepointerarray_is_full( struct _mulle_autoreleasepointerarray *array)
{
   return( array->used_ >= MULLE_AUTORELEASEPOINTERARRRAY_N_OBJECTS);
}


static inline BOOL
   _mulle_autoreleasepointerarray_can_add( struct _mulle_autoreleasepointerarray *array)
{
   return( array && ! _mulle_autoreleasepointerarray_is_full( array));
}


static inline size_t
   _mulle_autoreleasepointerarray_space_left( struct _mulle_autoreleasepointerarray *array)
{
   return( array ? MULLE_AUTORELEASEPOINTERARRRAY_N_OBJECTS - array->used_ : 0);
}


static inline void
   _mulle_autoreleasepointerarray_add( struct _mulle_autoreleasepointerarray *array,
                                       id p)
{
   assert( array->used_ < MULLE_AUTORELEASEPOINTERARRRAY_N_OBJECTS);
   array->objects_[ array->used_++] = p;
}



static inline int
   _mulle_autoreleasepointerarray_contains( struct _mulle_autoreleasepointerarray *array,
                                            id p)
{
   id   *q;
   id   *sentinel;

   do
   {
      sentinel = array->objects_;
      q        = &array->objects_[ array->used_];
      while( q > sentinel)
         if( *--q == p)
            return( 1);
   }
   while( array = array->previous_);

   return( 0);
}


static inline unsigned int
   _mulle_autoreleasepointerarray_count_object( struct _mulle_autoreleasepointerarray *array,
                                                id p)
{
   id             *q;
   id             *sentinel;
   unsigned int   count;

   count = 0;
   do
   {
      sentinel = array->objects_;
      q        = &array->objects_[ array->used_];
      while( q > sentinel)
         if( *--q == p)
            ++count;
   }
   while( array = array->previous_);

   return( count);
}

#endif
