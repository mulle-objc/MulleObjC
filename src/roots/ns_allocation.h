/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSAllocation.h is a part of MulleFoundation
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
#include <unistd.h>


extern struct mulle_allocator    mulle_allocator_objc;

// the '_' underscore is here, because these methods are not compatible
// with NS
__attribute__((const,returns_nonnull))
static inline void  *MulleObjCAllocator()
{
   struct _ns_rootconfiguration   *configuration;
   
   configuration = _ns_rootconfiguration();
   return( &configuration->allocator);
}


static inline void  *MulleObjCAllocateNonZeroedMemory( NSUInteger size)
{
   return( _mulle_allocator_malloc( MulleObjCAllocator(), size));
}


static inline void  *MulleObjCReallocateNonZeroedMemory( void *p, NSUInteger size)
{
   return( _mulle_allocator_realloc( MulleObjCAllocator(), p, size));
}


static inline void  *MulleObjCAllocateMemory( NSUInteger size)
{
   return( _mulle_allocator_calloc( MulleObjCAllocator(), 1, size));
}


static inline void  MulleObjCDeallocateMemory( void *p)
{
   _mulle_allocator_free( MulleObjCAllocator(), p);
}


char  *MulleObjCDuplicateCString( char *s);

void   *NSAllocateMemoryPages( NSUInteger size);
void   NSDeallocateMemoryPages( void *ptr, NSUInteger size);


static inline NSUInteger   NSPageSize()
{
   extern size_t   _ns_page_size;

   return( _ns_page_size);  // or let compiler determine it with ifdefs
}


static inline NSUInteger   NSLogPageSize()
{
   extern unsigned int   _ns_log_page_size;

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
