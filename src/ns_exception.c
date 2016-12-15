//
//  ns_exception.c
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


__attribute__ ((noreturn))
void   MulleObjCThrowAllocationException( size_t bytes)
{
   MulleObjCExceptionHandlersGetTable()->allocation_error( bytes);
}


__attribute__ ((noreturn))
void   mulle_objc_throw_allocation_exception( size_t bytes)
{
   MulleObjCExceptionHandlersGetTable()->allocation_error( bytes);
}


__attribute__ ((noreturn))
void   MulleObjCThrowInvalidArgumentException( id format, ...)
{
   va_list  args;
   
   va_start( args, format);
   MulleObjCExceptionHandlersGetTable()->invalid_argument( format, args);
   va_end( args);
}


__attribute__ ((noreturn))
void   mulle_objc_throw_invalid_argument_exception( char *format, ...)
{
   va_list  args;
   id       s;
   
   va_start( args, format);
   s = _ns_string( format);
   MulleObjCExceptionHandlersGetTable()->invalid_argument( s, args);
   va_end( args);
}


__attribute__ ((noreturn))
void   MulleObjCThrowInvalidIndexException( NSUInteger index)
{
   MulleObjCExceptionHandlersGetTable()->invalid_index( index);
}


__attribute__ ((noreturn))
void   mulle_objc_throw_invalid_index_exception( NSUInteger index)
{
   MulleObjCExceptionHandlersGetTable()->invalid_index( index);
}


__attribute__ ((noreturn))
void   MulleObjCThrowInternalInconsistencyException( id format, ...)
{
   va_list   args;
   
   va_start( args, format);
   MulleObjCExceptionHandlersGetTable()->internal_inconsistency( format, args);
   va_end( args);
}


__attribute__ ((noreturn))
void   mulle_objc_throw_internal_inconsistency_exception( char *format, ...)
{
   va_list   args;
   id        s;
   
   va_start( args, format);
   s = _ns_string( format);
   MulleObjCExceptionHandlersGetTable()->internal_inconsistency( s, args);
   va_end( args);
}


__attribute__ ((noreturn))
void   MulleObjCThrowInvalidRangeException( NSRange range)
{
   MulleObjCExceptionHandlersGetTable()->invalid_range( range);
}


__attribute__ ((noreturn))
void   mulle_objc_throw_invalid_range_exception( NSRange range)
{
   MulleObjCExceptionHandlersGetTable()->invalid_range( range);
}


__attribute__ ((noreturn))
void   MulleObjCThrowErrnoException( id format, ...)
{
   va_list  args;

   va_start( args, format);

   MulleObjCExceptionHandlersGetTable()->errno_error( format, args);
   va_end( args);
}


__attribute__ ((noreturn))
void   mulle_objc_throw_errno_exception( char *format, ...)
{
   va_list  args;
   id       s;
   
   va_start( args, format);
   s = _ns_string( format);
   MulleObjCExceptionHandlersGetTable()->errno_error( s, args);
   va_end( args);
}


#pragma mark -
#pragma mark Uncaught Exceptions

NSUncaughtExceptionHandler   *NSGetUncaughtExceptionHandler( void)
{
   struct _mulle_objc_runtime      *runtime;
   
   runtime    = mulle_objc_get_runtime();
   return( (NSUncaughtExceptionHandler *) runtime->failures.uncaughtexception);
}


void   NSSetUncaughtExceptionHandler( NSUncaughtExceptionHandler *handler)
{
   struct _mulle_objc_runtime      *runtime;
   
   runtime  = mulle_objc_get_runtime();
   runtime->failures.uncaughtexception = (void (*)()) handler;
}
