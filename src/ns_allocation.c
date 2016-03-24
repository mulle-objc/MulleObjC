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
#include <unistd.h>


# pragma mark -
# pragma mark Allocations

size_t         _ns_page_size;
unsigned int   _ns_log_page_size;

char  *MulleObjCDuplicateCString( char *s)
{
   char     *dup;
   size_t   size;

   if( ! s)
      return( s);
      
   size = strlen( s) + 1;
   dup  = MulleObjCAllocateMemory( size);
   memcpy( dup, s, size);
   return( dup);
}


void  MulleObjCDeterminePageSize( void);
void  MulleObjCDeterminePageSize( void)
{
   size_t   size;
   
   /* figure out _ns_page_size for ns_allocation */
   size = getpagesize();
   size = size ? size : 0x1000;
   
   _ns_page_size     = size;
   _ns_log_page_size = 1;
   while( size >>= 1)
      _ns_log_page_size++;
}


void   *NSAllocateMemoryPages( NSUInteger size)
{
   void   *p;
   
   size = NSRoundUpToMultipleOfPageSize( size);

   // make sure memory is page aligned ...
   p = MulleObjCAllocateMemory( size);
   assert( ! (uintptr_t) p & (NSPageSize() - 1));
   return( p);
}


void   NSDeallocateMemoryPages( void *ptr, NSUInteger size)
{
   return( MulleObjCDeallocateMemory( ptr));
}


static void  *calloc_or_raise( size_t n, size_t size)
{
   void     *p;
   
   p = calloc( n, size);
   if( p)
      return( p);

   size *= n;
   if( ! size)
      return( p);
   
   __NSThrowAllocationException( size);
   return( NULL);
}


static void  *realloc_or_raise( void *block, size_t size)
{
   void   *p;
   
   p = realloc( block, size);
   if( p)
      return( p);

   if( ! size)
      return( p);
   
   __NSThrowAllocationException( size);
   return( NULL);
}


struct mulle_allocator    mulle_allocator_objc =
{
   calloc_or_raise,
   realloc_or_raise,
   free,
   0,
   0
};

