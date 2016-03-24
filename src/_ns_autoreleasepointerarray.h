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

/* rename this to not mention NSObject */

struct _mulle_autoreleasepointerarray
{
   id             objects_[ N_MULLE_OBJECT_C_ARRAY];
   unsigned int   used_;
   
   struct _mulle_autoreleasepointerarray   *previous_;
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
      _mulle_objc_objects_call_release_and_zero( (void **) p->objects_, p->used_);

      q = p->previous_;
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
      objects = p->objects_;
      sentinel = &p->objects_[ p->used_];
      while( objects < sentinel)
         fprintf( stderr, "\t%p\n", *objects++);

      q = p->previous_;
      if( p != staticStorage)
         MulleObjCDeallocateMemory( p);
   }
}


static inline BOOL   _mulle_autoreleasepointerarray_is_full( struct _mulle_autoreleasepointerarray *array)
{
   return( array->used_ >= N_MULLE_OBJECT_C_ARRAY);
}


static inline BOOL   _mulle_autoreleasepointerarray_can_add( struct _mulle_autoreleasepointerarray *array)
{
   return( array && ! _mulle_autoreleasepointerarray_is_full( array));
}


static inline size_t   _mulle_autoreleasepointerarray_space_left( struct _mulle_autoreleasepointerarray *array)
{
   return( array ? N_MULLE_OBJECT_C_ARRAY - array->used_ : 0);
}


static inline void   _mulle_autoreleasepointerarray_add( struct _mulle_autoreleasepointerarray *array, id p)
{
   assert( array->used_ < N_MULLE_OBJECT_C_ARRAY);
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

