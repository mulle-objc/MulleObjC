/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  MulleObjCAllocation.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#ifndef ns_allocation__h__
#define ns_allocation__h__

#include "ns_type.h"

#include "ns_rootconfiguration.h"

#include <stddef.h>

void   *NSAllocateMemoryPages( NSUInteger size);
void   NSDeallocateMemoryPages( void *ptr, NSUInteger size);


static inline NSUInteger   NSPageSize()
{
   extern NSUInteger   _ns_page_size;

   return( _ns_page_size);  // or let compiler determine it with ifdefs
}


static inline NSUInteger   NSLogPageSize()
{
   extern NSUInteger   _ns_log_page_size;

   return( _ns_log_page_size);
}


static inline NSUInteger   NSRoundDownToMultipleOfPageSize(NSUInteger bytes)
{
   return( bytes & ~(NSPageSize() - 1));
}


static inline NSUInteger   NSRoundUpToMultipleOfPageSize( NSUInteger bytes)
{
   return( NSRoundDownToMultipleOfPageSize( bytes + NSPageSize() - 1));
}

#endif
