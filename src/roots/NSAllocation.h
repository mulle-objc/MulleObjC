/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSAllocation+ObjectiveC.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#ifndef NSALLOCATION_OBJECTIVE_C_H___
#define NSALLOCATION_OBJECTIVE_C_H___

#import "ns_type.h"
#import "ns_allocation.h"
#import "ns_zone.h"


static inline id    NSAllocateObject( Class isa, NSUInteger extra, NSZone *zone)
{
   return( (id) mulle_objc_class_alloc_instance_extra( isa, extra));
}


static inline id    _NSAllocateNonZeroedObject( Class isa, NSUInteger extra, NSZone *zone)
{
   // future for now its still just zeroed
   return( (id) mulle_objc_class_alloc_instance_extra( isa, extra));
}



static inline void   NSDeallocateObject( id obj)
{
   mulle_objc_instance_free( obj);
}


// implement the convenience stuff
// we don't go through a configuration, because we later have atomicity
// which is "harmless" as its faster than a function call
//
static inline void   NSIncrementExtraRefCount( id obj)
{
   _mulle_objc_object_increment_retain_count( obj);
}


static inline BOOL  NSDecrementExtraRefCountWasZero( id obj)
{
   return( (BOOL) (obj ? _mulle_objc_object_decrement_retain_count_was_zero( obj) : 0));
}


static inline NSUInteger   NSExtraRefCount( id obj)
{
   return( (NSUInteger) (obj ? _mulle_objc_object_retain_count( obj) : 0));
}


static inline BOOL    NSShouldRetainWithZone( id p, NSZone *zone)
{
   return( YES);
}

#endif

