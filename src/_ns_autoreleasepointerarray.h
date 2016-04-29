/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  _mulle_autoreleasepointerarray.h is a part of MulleFoundation
 *
 *  Copyright (C) 2012 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#ifndef _mulle_autoreleasepointerarray__h___
#define _mulle_autoreleasepointerarray__h___


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


static inline struct _mulle_autoreleasepointerarray   *_mulle_autoreleasepointerarray_create( struct _mulle_autoreleasepointerarray *previous)
{
   struct _mulle_autoreleasepointerarray  *array;
   
   array            = MulleObjCAllocateMemory( sizeof( struct _mulle_autoreleasepointerarray));
   array->used_     = 0;
   array->previous_ = previous;  
   
   return( array);
}


static inline void
_mulle_autoreleasepointerarray_release_and_free(
                            struct _mulle_autoreleasepointerarray *end,
                            struct _mulle_autoreleasepointerarray *staticStorage)
{
   struct _mulle_autoreleasepointerarray   *p, *q;
   
   for( p = end; p; p = q)
   {
      q = p->previous_;
      
      _mulle_objc_objects_call_release_and_zero( (void **) p->objects_, p->used_);

      if( p != staticStorage)
         MulleObjCDeallocateMemory( p);
   }
}


static inline void
_mulle_autoreleasepointerarray_dump_objects(
                            struct _mulle_autoreleasepointerarray *end,
                            struct _mulle_autoreleasepointerarray *staticStorage)
{
   struct _mulle_autoreleasepointerarray   *p, *q;
   id   *objects;
   id   *sentinel;
   
   for( p = end; p; p = q)
   {
      q = p->previous_;

      objects  = p->objects_;
      sentinel = &p->objects_[ p->used_];
      while( objects < sentinel)
         fprintf( stderr, "\t%p\n", *objects++);

      if( p != staticStorage)
         MulleObjCDeallocateMemory( p);
   }
}


static inline BOOL   _mulle_autoreleasepointerarray_is_full( struct _mulle_autoreleasepointerarray *array)
{
   return( array->used_ >= MULLE_AUTORELEASEPOINTERARRRAY_N_OBJECTS);
}


static inline BOOL   _mulle_autoreleasepointerarray_can_add( struct _mulle_autoreleasepointerarray *array)
{
   return( array && ! _mulle_autoreleasepointerarray_is_full( array));
}


static inline size_t   _mulle_autoreleasepointerarray_space_left( struct _mulle_autoreleasepointerarray *array)
{
   return( array ? MULLE_AUTORELEASEPOINTERARRRAY_N_OBJECTS - array->used_ : 0);
}


static inline void   _mulle_autoreleasepointerarray_add( struct _mulle_autoreleasepointerarray *array, id p)
{
   assert( array->used_ < MULLE_AUTORELEASEPOINTERARRRAY_N_OBJECTS);
   array->objects_[ array->used_++] = p;
}



static inline int   _mulle_autoreleasepointerarray_contains( struct _mulle_autoreleasepointerarray *array, id p)
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

#endif

