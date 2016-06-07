/*
 *  MulleFoundation - the mulle-objc class library
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

NSUInteger     _ns_page_size;
NSUInteger     _ns_log_page_size;

void  _MulleObjCSetPageSize( size_t pagesize)
{
   size_t   size;
   
   size = pagesize ? pagesize : 0x1000;
   
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
   p = mulle_malloc( size);
   assert( ! (uintptr_t) p & (NSPageSize() - 1));
   return( p);
}


void   NSDeallocateMemoryPages( void *ptr, NSUInteger size)
{
   mulle_free( ptr);
}


