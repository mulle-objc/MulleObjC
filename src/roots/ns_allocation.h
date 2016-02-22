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


__attribute__((const,returns_nonnull))
static inline void  *_NSAllocator()
{
#if ! MULLE_OBJC_HAVE_THREAD_LOCAL_RUNTIME
   extern struct mulle_allocator   mulle_allocator_objc;
   
   return( &mulle_allocator_objc);
#else
   return( &_ns_rootconfiguration()->allocator);
#endif
}


static inline void  *_NSAllocateNonZeroedMemory( NSUInteger size)
{
   return( mulle_allocator_malloc( _NSAllocator(), size));
}


static inline void  *_NSReallocateNonZeroedMemory( void *p, NSUInteger size)
{
   return( mulle_allocator_realloc( _NSAllocator(), p, size));
}


static inline void  *_NSAllocateMemory( NSUInteger size)
{
   return( mulle_allocator_calloc( _NSAllocator(), 1, size));
}


static inline void  _NSDeallocateMemory( void *p)
{
   mulle_allocator_free( _NSAllocator(), p);
}


char  *_NSDuplicateCString( char *s);

void   *NSAllocateMemoryPages( NSUInteger size);
void   NSDeallocateMemoryPages( void *ptr, NSUInteger size);


// only use this in asserts.
// It will produce UINT_MAX on Linux
size_t   _NSMallocedBlockSize( void *p);


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
