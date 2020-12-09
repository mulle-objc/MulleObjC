//
//  ns_exception.m
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
#import "import-private.h"

#import "MulleObjCExceptionHandler.h"
#import "MulleObjCExceptionHandler-Private.h"

#import "NSRange.h"
#import "mulle-objc-exceptionhandlertable-private.h"
#import "mulle-objc-universefoundationinfo-private.h"
#import "MulleObjCVersion.h"
#include <stdio.h>


#pragma mark - C


MULLE_C_NO_RETURN void
   mulle_objc_universe_raisev_invalidargument( struct _mulle_objc_universe *universe,
   														  char *format,
   														  va_list args)
{
   struct _mulle_objc_exceptionhandlertable   *vectors;
   id                                         s;

   mulle_objc_break_exception();
   vectors = mulle_objc_universe_get_foundationexceptionhandlertable( universe);
   s       = vectors ? _mulle_objc_universe_string( universe, format) : 0;
   if( s && vectors)
      vectors->invalid_argument( s, args);
   else
      vfprintf( stderr, format, args);
   abort();
}


MULLE_C_NO_RETURN void
   __mulle_objc_universe_raise_invalidargument( struct _mulle_objc_universe *universe,
   														   char *format, ...)
{
   va_list   args;

   va_start( args, format);
   mulle_objc_universe_raisev_invalidargument( universe, format, args);
   va_end( args);
}


MULLE_C_NO_RETURN void
   mulle_objc_universe_raisev_internalinconsistency( struct _mulle_objc_universe *universe,
   															     char *format,
                                                     va_list args)
{
   id                                         s;
   struct _mulle_objc_exceptionhandlertable   *vectors;

   mulle_objc_break_exception();
   vectors = mulle_objc_universe_get_foundationexceptionhandlertable( universe);
   s       = vectors ? _mulle_objc_universe_string( universe, format) : 0;
   if( s && vectors)
      vectors->internal_inconsistency( s, args);
   else
      vfprintf( stderr, format, args);
   abort();
}


MULLE_C_NO_RETURN void
   __mulle_objc_universe_raise_internalinconsistency( struct _mulle_objc_universe *universe,
   																   char *format, ...)
{
   va_list   args;

   va_start( args, format);
   mulle_objc_universe_raisev_internalinconsistency( universe, format, args);
   va_end( args);
}


MULLE_C_NO_RETURN void
   mulle_objc_universe_raisev_errno( struct _mulle_objc_universe *universe,
   										    char *format,
   										    va_list args)
{
   id                                         s;
   struct _mulle_objc_exceptionhandlertable   *vectors;

   mulle_objc_break_exception();
   vectors = mulle_objc_universe_get_foundationexceptionhandlertable( universe);
   s       = vectors ? _mulle_objc_universe_string( universe, format) : 0;
   if( s && vectors)
      vectors->errno_error( s, args);
   else
      vfprintf( stderr, format, args);
   abort();
}


MULLE_C_NO_RETURN void
   __mulle_objc_universe_raise_errno( struct _mulle_objc_universe *universe,
   											  char *format, ...)
{
   va_list  args;

   va_start( args, format);
   mulle_objc_universe_raisev_errno( universe, format, args);
   va_end( args);
}


MULLE_C_NO_RETURN void
   __mulle_objc_universe_raise_invalidindex( struct _mulle_objc_universe *universe,
   														NSUInteger index)
{
   struct _mulle_objc_exceptionhandlertable   *vectors;

   mulle_objc_break_exception();
   vectors = mulle_objc_universe_get_foundationexceptionhandlertable( universe);
   if( vectors)
      vectors->invalid_index( index);
   else
      fprintf( stderr, "invalid index %lu\n", (long) index);
   abort();
}


MULLE_C_NO_RETURN void
   mulle_objc_throw( void *exception)
{
   struct _mulle_objc_universe   *universe;

   mulle_objc_break_exception();
   universe = _mulle_objc_object_get_universe( exception);
   _mulle_objc_universe_throw( universe, exception);
}


#pragma mark -
#pragma mark Uncaught Exceptions

NSUncaughtExceptionHandler   *NSGetUncaughtExceptionHandler()
{
   struct _mulle_objc_universe   *universe;

   universe = mulle_objc_global_get_defaultuniverse();
   return( (NSUncaughtExceptionHandler *) universe->failures.uncaughtexception);
}


void   NSSetUncaughtExceptionHandler( NSUncaughtExceptionHandler *handler)
{
   struct _mulle_objc_universe      *universe;

   universe = mulle_objc_global_get_defaultuniverse();
   universe->failures.uncaughtexception = (void (*)()) handler;
}
