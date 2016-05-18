//
//  ns_test_allocation.c
//  MulleObjC
//
//  Created by Nat! on 25.02.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#include "ns_test_allocation.h"

#include "ns_exception.h"
#include <mulle_test_allocator/mulle_test_allocator.h>


static void  *test_calloc_or_raise( size_t n, size_t size)
{
   void     *p;
   
   p = _mulle_allocator_calloc( &mulle_test_allocator, n, size);
   if( p)
      return( p);

   size *= n;
   if( ! size)
      return( p);
   
   mulle_objc_throw_allocation_exception( size);
   return( NULL);
}


static void  *test_realloc_or_raise( void *block, size_t size)
{
   void   *p;
   
   p = _mulle_allocator_realloc( &mulle_test_allocator, block, size);
   if( p || ! size)
      return( p);
   
   mulle_objc_throw_allocation_exception( size);
   return( NULL);
}


static void  test_free( void *block)
{
   _mulle_allocator_free( &mulle_test_allocator, block);
}


struct mulle_allocator    mulle_test_allocator_objc =
{
   test_calloc_or_raise,
   test_realloc_or_raise,
   test_free,
   0,
   NULL
};


