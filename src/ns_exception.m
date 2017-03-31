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

#include "ns_exception.h"

#include "ns_rootconfiguration.h"

#include <stdio.h>


#pragma mark - C

MULLE_C_NO_RETURN
void   mulle_objc_throw_allocation_exception( size_t bytes)
{
   struct _ns_exceptionhandlertable   *vectors;

   vectors = _ns_get_exceptionhandlertable();
   if( ! vectors)
   {
      fprintf( stderr, "Out of memory allocating %lu bytes\n", bytes);
      exit( 1);
   }
   vectors->allocation_error( bytes);
}


MULLE_C_NO_RETURN
void   mulle_objc_throw_invalid_argument_exception_v( char *format, va_list args)
{
   id                                 s;
   struct _ns_exceptionhandlertable   *vectors;

   vectors = _ns_get_exceptionhandlertable();
   if( ! vectors)
   {
      vfprintf( stderr, format, args);
      exit( 1);
   }
   
   s = _ns_string( format);
   vectors->invalid_argument( s, args);
}


MULLE_C_NO_RETURN
void   mulle_objc_throw_invalid_argument_exception( char *format, ...)
{
   va_list   args;

   va_start( args, format);
   mulle_objc_throw_invalid_argument_exception_v( format, args);
   va_end( args);
}


MULLE_C_NO_RETURN
void   mulle_objc_throw_internal_inconsistency_exception_v( char *format, va_list args)
{
   id                                 s;
   struct _ns_exceptionhandlertable   *vectors;

   vectors = _ns_get_exceptionhandlertable();
   if( ! vectors)
   {
      vfprintf( stderr, format, args);
      exit( 1);
   }
   s = _ns_string( format);
   
   vectors->internal_inconsistency( s, args);
}


MULLE_C_NO_RETURN
void   mulle_objc_throw_internal_inconsistency_exception( char *format, ...)
{
   va_list   args;

   va_start( args, format);
   mulle_objc_throw_internal_inconsistency_exception_v( format, args);
   va_end( args);
}


MULLE_C_NO_RETURN
void   mulle_objc_throw_errno_exception_v( char *format, va_list args)
{
   id                                 s;
   struct _ns_exceptionhandlertable   *vectors;

   vectors = _ns_get_exceptionhandlertable();
   if( ! vectors)
   {
      vfprintf( stderr, format, args);
      exit( 1);
   }
   
   s = _ns_string( format);
   vectors->errno_error( s, args);
}


MULLE_C_NO_RETURN
void   mulle_objc_throw_errno_exception( char *format, ...)
{
   va_list  args;

   va_start( args, format);
   mulle_objc_throw_errno_exception_v( format, args);
   va_end( args);
}


MULLE_C_NO_RETURN
void   mulle_objc_throw_invalid_index( NSUInteger index)
{
   struct _ns_exceptionhandlertable   *vectors;

   vectors = _ns_get_exceptionhandlertable();
   if( ! vectors)
   {
      fprintf( stderr, "invalid index %lu\n", index);
      exit( 1);
   }
   
   vectors->invalid_index( index);
}


#pragma mark -
#pragma mark Uncaught Exceptions

NSUncaughtExceptionHandler   *NSGetUncaughtExceptionHandler( void)
{
   struct _mulle_objc_runtime   *runtime;

   runtime = mulle_objc_get_runtime();
   return( (NSUncaughtExceptionHandler *) runtime->failures.uncaughtexception);
}


void   NSSetUncaughtExceptionHandler( NSUncaughtExceptionHandler *handler)
{
   struct _mulle_objc_runtime      *runtime;

   runtime = mulle_objc_get_runtime();
   runtime->failures.uncaughtexception = (void (*)()) handler;
}
