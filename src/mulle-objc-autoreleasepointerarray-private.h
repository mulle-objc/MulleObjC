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


// MEMO: generalise for C.
//
// {
//    void   *current_free;
//    void   *current_context;
//    void   *default_free;
//    void   *default_context;
// }
//
// Objects stream... Assume that:
// a) mostly only C or only ObjC
// b) infrequent mix of different contexts for free routine
//
// change to C (remember last free_routine,
//    0x0x0 (return to default_free, default_context (objc))
//    0x0x1, free_routine, free_context, free_block
//    <other      just free
//
// setup:
// default_free    = current_free    = _mulle_objc_object_release2;
// default_context = current_context = NULL;
//
// add( obj, free, context)
//    if( context != current_context || free != current_free)
//       if( context == default_context && free == default_free))
//          *p++= 0x0;
//       else
//          *p++= 0x1;
//          *p++= current_free;
//          *p++= current_context;
//
//  *p++ = obj;
//
// release()
//    current_free = default_free;
//    current_free = default_context;
//    while( p < sentinel)
//       if( *p == 0)
//          current_free    = default_free;
//          current_context = default_context;
//          ++p
//       else
//          if( *p == 1)
//             ++p;
//             current_free    = *p++;
//             current_context = *p++;
//
//       (*current_free)( *p++, current_context);
//

#include <stdio.h>


// for an NSAutoreleasePool we'd like to allocate two memory pages (8k)
// so that's
//  sizeof( NSAutoreleasePool) == 2 * sizeof( intptr_t)
//  sizeof( struct _mulle_objc_objectheader) == 2 * sizeof( intptr_t))
//  sizeof( struct _mulle_autoreleasepointerarray)
// == 8192
//
#define MULLE_OBJC_TWOPAGES_LESS_AUTORELEASE_POOL    \
   (4096 * 2 - 4 * sizeof( intptr_t))

#define MULLE_AUTORELEASEPOINTERARRRAY_N_OBJECTS    \
   ((MULLE_OBJC_TWOPAGES_LESS_AUTORELEASE_POOL - 2 * sizeof( intptr_t)) / sizeof( id))



struct _mulle_autoreleasepointerarray
{
   struct _mulle_autoreleasepointerarray   *previous;

   NSUInteger   used;
   NSUInteger   count;
   id           objects[ MULLE_AUTORELEASEPOINTERARRRAY_N_OBJECTS];
};


static inline void
   _mulle_autoreleasepointerarray_init( struct _mulle_autoreleasepointerarray *array, 
                                        struct _mulle_autoreleasepointerarray *previous)
{
   array->used     = 0;
   array->count    = 0;
   array->previous = previous;
}



static inline struct _mulle_autoreleasepointerarray *
   _mulle_autoreleasepointerarray_create( struct _mulle_autoreleasepointerarray *previous)
{
   struct _mulle_autoreleasepointerarray  *array;

   array = mulle_malloc( sizeof( struct _mulle_autoreleasepointerarray));

#if AUTORELEASEPOOL_DEBUG
   fprintf( stderr, "[pool] _mulle_autoreleasepointerarray %p allocated (previous = %p)\n",
                     array,
                     previous);
#endif

   _mulle_autoreleasepointerarray_init( array, previous);

   return( array);
}



static inline BOOL
   _mulle_autoreleasepointerarray_is_full( struct _mulle_autoreleasepointerarray *array)
{
   return( array->used >= MULLE_AUTORELEASEPOINTERARRRAY_N_OBJECTS);
}


static inline BOOL
   _mulle_autoreleasepointerarray_can_add( struct _mulle_autoreleasepointerarray *array)
{
   return( array && ! _mulle_autoreleasepointerarray_is_full( array));
}


static inline size_t
   _mulle_autoreleasepointerarray_space_left( struct _mulle_autoreleasepointerarray *array)
{
   return( array ? MULLE_AUTORELEASEPOINTERARRRAY_N_OBJECTS - array->used : 0);
}


static inline void
   _mulle_autoreleasepointerarray_add( struct _mulle_autoreleasepointerarray *array,
                                       id p)
{
   assert( p);
   assert( array->used < MULLE_AUTORELEASEPOINTERARRRAY_N_OBJECTS);

   array->objects[ array->used++] = p;
   array->count++;
}


static inline int
   _mulle_autoreleasepointerarray_contains( struct _mulle_autoreleasepointerarray *array,
                                            id p)
{
   id   *q;
   id   *sentinel;

   do
   {
      sentinel = array->objects;
      q        = &array->objects[ array->used];
      while( q > sentinel)
         if( *--q == p)
            return( 1);
   }
   while( array = array->previous);

   return( 0);
}


static inline void
   _mulle_object_map_release_and_free( struct mulle_map *object_map,
                                       void *opfer)
{
   NSUInteger   value;

   value = (NSUInteger) mulle_map_get( object_map, opfer);
   assert( value && "object appeared in pool out of nowhere");
   --value;

   if( ! value)
      mulle_map_remove( object_map, opfer);
   else
      mulle_map_set( object_map, opfer, (void *) value);
}



//
// this is the standard function that wipes a NSAutoreleasePool
//
static inline void
   _mulle_autoreleasepointerarray_release_and_free(
                               struct _mulle_autoreleasepointerarray *end,
                               struct _mulle_autoreleasepointerarray *staticStorage,
                               struct mulle_map *object_map)
{
   struct _mulle_autoreleasepointerarray   *p, *q;
   id                                      *objects;
   id                                      *sentinel;
   id                                      opfer;

   for( p = end; p; p = q)
   {
      q            = p->previous;
      p->previous = NULL;

      // release in reverse fashion, because that should be better for the
      // memory manager
      objects  = &p->objects[ p->used];
      sentinel = p->objects;

      // We could avoid the if opfer check, if we precheck that count == used
      // if( p->count == p->used), meaning there are no holes
      if( object_map)
      {
         while( objects > sentinel)
         {
            opfer = *--objects;
            if( opfer)
            {
               _mulle_object_map_release_and_free( object_map, opfer);
               _mulle_objc_object_call_release( opfer);
            }
         }
      }
      else
      {
         while( objects > sentinel)
         {
            opfer = *--objects;
            _mulle_objc_object_call_release( opfer);
         }
      }

      if( p != staticStorage)
      {
#if AUTORELEASEPOOL_DEBUG
         fprintf( stderr, "[pool] _mulle_autoreleasepointerarray %p deallocated (previous = %p)\n",
                          p,
                          q);
#endif
         mulle_free( p);
      }
   }
}


//
// Specialized code for mulleReleasePoolObjects:
//
static inline void
   _mulle_autoreleasepointerarray_release_objects( struct _mulle_autoreleasepointerarray *array,
                                                   id *objects,
                                                   NSUInteger  count,
                                                   struct mulle_map *object_map)

{
   id   *q;
   id   *q_sentinel;
   id   *p;
   id   *p_sentinel;
   id   obj;

   // this doesn't change over the course of the loops
   p_sentinel = &objects[ count];

   do
   {
      q_sentinel = array->objects;
      q          = &array->objects[ array->used];

      while( q > q_sentinel)
      {
         obj = *--q;

         for( p = objects; p < p_sentinel; ++p)
         {
            if( *p == obj)
            {
               *q = NULL;
               array->count--;
               if( object_map)
                  _mulle_object_map_release_and_free( object_map, obj);
               _mulle_objc_object_release_inline( obj);
               break;
            }
         }
      }
   }
   while( array = array->previous);
}


//
// Debug helpers
//
static inline unsigned int
   _mulle_autoreleasepointerarray_count( struct _mulle_autoreleasepointerarray *array)
{
   unsigned int   count;

   for( count = 0; array; array = array->previous)
      count += array->count;

   return( count);
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
      sentinel = array->objects;
      q        = &array->objects[ array->used];
      while( q > sentinel)
         if( *--q == p)
            ++count;
   }
   while( array = array->previous);

   return( count);
}


static inline void
   _mulle_autoreleasepointerarray_dump_objects(
                               struct _mulle_autoreleasepointerarray *end,
                               char *verb)
{
   id                                      *objects;
   id                                      *sentinel;
   struct _mulle_autoreleasepointerarray   *p, *q;
   id                                      obj;

   for( p = end; p; p = q)
   {
      q = p->previous;

      objects  = p->objects;
      sentinel = &p->objects[ p->used];
      while( objects < sentinel)
      {
         obj = *objects++;
         if( obj)
         {
            fprintf( stderr, "[pool] %p %p (RC: %ld)\n",
                                 obj,
                                 verb,
                                 (long) mulle_objc_object_get_retaincount( obj));
         }
      }
   }
}


static inline
void   _mulle_autoreleasepointerarray_walk_objects(
                               struct _mulle_autoreleasepointerarray *end,
                               mulle_objc_walkcommand_t (*callback)( id obj, void *userinfo),
                               void *userinfo)
{
   id                                      *objects;
   id                                      *sentinel;
   struct _mulle_autoreleasepointerarray   *p, *q;
   id                                      obj;

   for( p = end; p; p = q)
   {
      q = p->previous;

      objects  = p->objects;
      sentinel = &p->objects[ p->used];
      while( objects < sentinel)
      {
         obj = *objects++;
         if( obj)
         {
            if( (*callback)( obj, userinfo) != mulle_objc_walk_ok)
               break;
         }
      }
   }
}


#endif
