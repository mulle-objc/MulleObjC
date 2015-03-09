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
#ifndef NS_ALLOCATION__H__
#define NS_ALLOCATION__H__

#include "ns_type.h"

#include "mulle_objc_root_configuration.h"

#include <stddef.h>


struct _mulle_objc_allocation_function_table
{
   void     *(*malloc)( size_t);
   void     *(*realloc)( void *, size_t);
   void     *(*calloc)( size_t, size_t);
   
   void     (*free)( void *);
   
   size_t   (*malloc_size)( void *p);  // not necessarily supported(!)
};


//
// remnant from trying to move this into config, but it's too slow
//
static inline struct _mulle_objc_allocation_function_table   *_NSAllocationFunctionTable( void)
{
   extern struct _mulle_objc_allocation_function_table   __NSAllocationFunctionTable;
   
   return( &__NSAllocationFunctionTable);
}


static inline void  *__NSAllocateNonZeroedMemory( NSUInteger size)
{
   return( _NSAllocationFunctionTable()->malloc( size));
}


static inline void  *__NSReallocateNonZeroedMemory( void *p, NSUInteger size)
{
   return( _NSAllocationFunctionTable()->realloc( p, size));
}


static inline void  *__NSAllocateMemory( NSUInteger size)
{
   return( _NSAllocationFunctionTable()->calloc( 1, size));
}


static inline size_t  __NSSizeOfMemory( void *p)
{
   return( _NSAllocationFunctionTable()->malloc_size( p));
}


static inline void  __NSDeallocateMemory( void *p)
{
   _NSAllocationFunctionTable()->free( p);
}


static inline size_t  _NSSizeOfMemory( void *p)
{
   return( _NSAllocationFunctionTable()->malloc_size( p));
}


static inline void  _NSDeallocateMemory( void *p)
{
   _NSAllocationFunctionTable()->free( p);
}


/* now with added exceptions */

void  *_NSAllocateNonZeroedMemory( NSUInteger size);
void  *_NSReallocateNonZeroedMemory( void *p, NSUInteger size);
void  *_NSAllocateMemory( NSUInteger size);


void   *NSAllocateMemoryPages( NSUInteger size);
void   NSDeallocateMemoryPages( void *ptr, NSUInteger size);


// only use this in asserts, it will produce UINT_MAX on Linux
size_t   _NSMallocedBlockSize( void *p);


static inline NSUInteger   NSPageSize()
{
   return( 0x400);  // or let compiler determine it with ifdefs
}


static inline NSUInteger   NSLogPageSize()
{
   return( 10);      // 0x1 < (10 - 1)= 0x400
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
