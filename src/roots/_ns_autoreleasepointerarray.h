/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  _ns_autoreleasepointerarray.h is a part of MulleFoundation
 *
 *  Copyright (C) 2012 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#ifndef _ns_autoreleasepointerarray__h___
#define _ns_autoreleasepointerarray__h___

/* rename this to not mention NSObject */

struct _ns_autoreleasepointerarray
{
   void           *objects_[ N_NS_OBJECT_C_ARRAY];
   unsigned int   used_;
   
   struct _ns_autoreleasepointerarray   *previous_;
};


static inline struct _ns_autoreleasepointerarray   *_ns_autoreleasepointerarray_create( struct _ns_autoreleasepointerarray *previous)
{
   struct _ns_autoreleasepointerarray  *array;
   
   array            = _NSAllocateMemory( sizeof( struct _ns_autoreleasepointerarray));
   array->used_     = 0;
   array->previous_ = previous;  
   
   return( array);
}


static inline void
_ns_autoreleasepointerarray_release_and_free(
                            struct _ns_autoreleasepointerarray *end,
                            struct _ns_autoreleasepointerarray *staticStorage)
{
   struct _ns_autoreleasepointerarray   *p, *q;
   
   for( p = end; p; p = q)
   {
      _mulle_objc_objects_call_release_and_zero( (void **) p->objects_, p->used_);

      q = p->previous_;
      if( p != staticStorage)
         _NSDeallocateMemory( p);
   }
}


static inline BOOL   _ns_autoreleasepointerarray_is_full( struct _ns_autoreleasepointerarray *array)
{
   return( array->used_ >= N_NS_OBJECT_C_ARRAY);
}


static inline BOOL   _ns_autoreleasepointerarray_can_add( struct _ns_autoreleasepointerarray *array)
{
   return( array && ! _ns_autoreleasepointerarray_is_full( array));
}


static inline size_t   _ns_autoreleasepointerarray_space_left( struct _ns_autoreleasepointerarray *array)
{
   return( array ? N_NS_OBJECT_C_ARRAY - array->used_ : 0);
}


static inline void   _ns_autoreleasepointerarray_add( struct _ns_autoreleasepointerarray *array, id p)
{
   assert( array->used_ < N_NS_OBJECT_C_ARRAY);
   array->objects_[ array->used_++] = p;
}

#endif

