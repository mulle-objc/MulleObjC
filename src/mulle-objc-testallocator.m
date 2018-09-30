//
//  ns_test_allocation.m
//  MulleObjC
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//

#include <mulle-testallocator/mulle-testallocator.h>

#include "mulle-objc-testallocator-private.h"

#include "MulleObjCExceptionHandler.h"
#include "MulleObjCExceptionHandler-Private.h"


static void  *test_calloc_or_raise( size_t n, size_t size)
{
   void     *p;

   p = _mulle_allocator_calloc( &mulle_testallocator, n, size);
   if( p)
      return( p);

   size *= n;
   if( ! size)
      return( p);

   __mulle_objc_universe_raise_failedallocation( NULL, size);
   return( NULL);
}


static void  *test_realloc_or_raise( void *block, size_t size)
{
   void   *p;

   p = _mulle_allocator_realloc( &mulle_testallocator, block, size);
   if( p || ! size)
      return( p);

   __mulle_objc_universe_raise_failedallocation( NULL, size);
   return( NULL);
}


static void  test_free( void *block)
{
   _mulle_allocator_free( &mulle_testallocator, block);
}


MULLE_C_NO_RETURN static void
   test_exception( void *block, size_t size)
{
   if( block)
      __mulle_objc_universe_raise_errno( NULL, "Couldn't not allocate %ld bytes for block %p", block, size);
   else
      __mulle_objc_universe_raise_errno( NULL, "Couldn't not allocate %ld bytes", size);
}



struct mulle_allocator    mulle_objc_testallocator =
{
   test_calloc_or_raise,
   test_realloc_or_raise,
   test_free,
   test_exception,
   0,
   NULL
};
