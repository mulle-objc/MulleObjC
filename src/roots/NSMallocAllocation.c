/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSMallocAllocation.c is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#include "NSAllocation.h"

#include "_MulleObjCRootsParentIncludes.h"


#ifndef __APPLE__
static size_t   no_size( void *p, void *unused)
{
   return( UINT_MAX);  // make it huge, some algorithms depend on it
}
#endif


//
// for this to work in WIN, we must be doing CDECL or FASTCALL ?
//
struct _NSAllocationJumpTable   _NSAllocationJumpTable =
{
   (void *) malloc,
   (void *) realloc,
   (void *) calloc,
   (void *) free,
#ifdef __APPLE__
   (void *) malloc_size
#else
   (void *) no_size
#endif   
};


// TODO: thread safety with atomic instructions (as this can be called again)
__attribute__((constructor))
void  NSAllocationPushAllocationToObjCRuntime( void)
{
   mulle_objc_globals.class_vectors.calloc = _NSAllocationJumpTable.calloc;
   mulle_objc_globals.class_vectors.free   = _NSAllocationJumpTable.free;
}

