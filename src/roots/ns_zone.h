/*
 *  MulleFoundation - A tiny Foundation replacement
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
#ifndef NS_ZONE__H__
#define NS_ZONE__H__
 
#include "ns_type.h"
#include "ns_allocation.h"
#include "ns_exception.h"



// these are just here for compatibilty, they pretty much vanish due to
// inlining

typedef struct _NSZone 
{
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


static inline NSZone   *__NSZoneFromObject( void *p)
{
   return( NULL);
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
   return( _NSAllocateNonZeroedMemory( size));
}


static inline void   *NSZoneCalloc( NSZone *zone, NSUInteger numElems, NSUInteger byteSize)
{
   return( _NSAllocateMemory( numElems * byteSize));
}


static inline void   *NSZoneRealloc( NSZone *zone, void *p, NSUInteger size)
{
   return( _NSReallocateNonZeroedMemory( p, size));
}


static inline void   NSZoneFree( NSZone *zone, void *p)
{
   _NSDeallocateMemory( p);
}

#endif
