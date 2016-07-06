/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSZone.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#ifndef ns_zone__h__
#define ns_zone__h__
 
#include "ns_type.h"
#include "ns_exception.h"


//
// this is created by the compiler when using
// -zone
//
static inline void  *mulle_objc_object_zone( void)
{
   return( NULL);
}


// these are just here for compatibilty, they pretty much vanish due to
// inlining

typedef struct  
{
   void   *unused;  // empty would be not C11
} NSZone;


static inline NSZone   *NSDefaultMallocZone()
{
   return( NULL);
}


static inline NSZone   *NSCreateZone( NSUInteger startSize, NSUInteger granularity, BOOL canFree)
{
   return( NULL);
}


static inline void    NSRecycleZone( NSZone *zone)
{
}


static inline void   NSSetZoneName( NSZone *zone, void *name)
{
}


static inline NSZone   *NSZoneFromPointer( void *p)
{
   return( NULL);
}


//
//
//
static inline void   *NSZoneMalloc( NSZone *zone, NSUInteger size)
{
   return( mulle_malloc( size));
}


static inline void   *NSZoneCalloc( NSZone *zone, NSUInteger numElems, NSUInteger byteSize)
{
   return( mulle_calloc( numElems, byteSize));
}


static inline void   *NSZoneRealloc( NSZone *zone, void *p, NSUInteger size)
{
   return( mulle_realloc( p, size));
}


static inline void   NSZoneFree( NSZone *zone, void *p)
{
   if( p)
      mulle_free( p);
}

#endif
