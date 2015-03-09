/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSAllocation.c is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#include "ns_allocation.h"

#include "ns_exception.h"


# pragma mark -
# pragma mark Allocations

#ifndef __APPLE__
static size_t   no_size( void *p)
{
   return( UINT_MAX);  // make it huge, some algorithms depend on it
}
#endif



//
// it's tempting to remove this global, but stuff gets too slow
//
struct _mulle_objc_allocation_function_table   __NSAllocationFunctionTable =
{
   malloc,
   realloc,
   calloc,
   free,
   
#ifndef __APPLE__
   no_size,
#else
   (void *) malloc_size
#endif
};


void   *_NSAllocateNonZeroedMemory( NSUInteger size)
{
   void   *p;
   
   p = __NSAllocateNonZeroedMemory( size);
   if( ! p)
      __NSThrowAllocationException( size);
   return( p);
}


void   *_NSAllocateMemory( NSUInteger size)
{
   void   *p;
   
   p = __NSAllocateMemory( size);
   if( ! p)
      __NSThrowAllocationException( size);
   return( p);
}


void   *_NSReallocateNonZeroedMemory( void *p, NSUInteger size)
{
   void   *q;
   
   q = __NSReallocateNonZeroedMemory( p, size);
   if( ! q && size)
      __NSThrowAllocationException( size);
   return( q);
}


//
// for now just use malloc ... 
// later use mmap or some such
//
void   *NSAllocateMemoryPages( NSUInteger size)
{
   void   *p;
   
   size = NSRoundUpToMultipleOfPageSize( size);
   p = __NSAllocateMemory( size);
   if( ! p)
      __NSThrowInvalidArgumentException( "size %ld too large", size);
   return( p);
}


void   NSDeallocateMemoryPages( void *ptr, NSUInteger size)
{
   return( _NSDeallocateMemory( ptr));
}


size_t   _NSMallocedBlockSize( void *p)
{
#ifdef __APPLE__
   return( malloc_size( p));
#else
   return( UINT_MAX);
#endif   
}
