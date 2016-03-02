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
#ifndef ns_zone__h__
#define ns_zone__h__
 
#include "ns_type.h"
#include "ns_allocation.h"
#include "ns_exception.h"



// these are just here for compatibilty, they pretty much vanish due to
// inlining

typedef struct  
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


static inline NSZone   *NSZoneFromPointer( void *p)
{
   return( NULL);
}


//
//
//
static inline void   *NSZoneMalloc( NSZone *zone, NSUInteger size)
{
   return( MulleObjCAllocateNonZeroedMemory( size));
}


static inline void   *NSZoneCalloc( NSZone *zone, NSUInteger numElems, NSUInteger byteSize)
{
   return( MulleObjCAllocateMemory( numElems * byteSize));
}


static inline void   *NSZoneRealloc( NSZone *zone, void *p, NSUInteger size)
{
   return( MulleObjCReallocateNonZeroedMemory( p, size));
}


static inline void   NSZoneFree( NSZone *zone, void *p)
{
   MulleObjCDeallocateMemory( p);
}

#endif
