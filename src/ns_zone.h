//
//  ns_zone.h
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
