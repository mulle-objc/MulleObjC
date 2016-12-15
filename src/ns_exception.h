//
//  ns_exception.h
//  MulleObjC
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#ifndef ns_exception__h__
#define ns_exception__h__

// the "C" interface to NSException
// by default these all just call abort

#include "ns_type.h"
#include "ns_range.h"

#include "ns_rootconfiguration.h"


static inline struct _ns_exceptionhandlertable   *MulleObjCExceptionHandlersGetTable( void)
{
   return( &_ns_get_rootconfiguration()->exception.vectors);
}

__attribute__ ((noreturn))
void   MulleObjCThrowAllocationException( size_t bytes);

__attribute__ ((noreturn))
void   MulleObjCThrowInvalidArgumentException( id format, ...);

__attribute__ ((noreturn))
void   MulleObjCThrowInvalidIndexException( NSUInteger index);

__attribute__ ((noreturn))
void   MulleObjCThrowInternalInconsistencyException( id format, ...);

__attribute__ ((noreturn))
void   MulleObjCThrowInvalidRangeException( NSRange range);

__attribute__ ((noreturn))
void   MulleObjCThrowErrnoException( id s, ...);


#pragma mark -
#pragma mark Some C Interfaces with char * (and some just for completeness)

__attribute__ ((noreturn))
void   mulle_objc_throw_allocation_exception( size_t bytes);

__attribute__ ((noreturn))
void   mulle_objc_throw_invalid_index_exception( NSUInteger index);

__attribute__ ((noreturn))
void   mulle_objc_throw_invalid_range_exception( NSRange range);

__attribute__ ((noreturn))
void   mulle_objc_throw_invalid_argument_exception( char *format, ...);

__attribute__ ((noreturn))
void   mulle_objc_throw_errno_exception( char *format, ...);

__attribute__ ((noreturn))
void   mulle_objc_throw_internal_inconsistency_exception( char *format, ...);


#pragma mark -
#pragma mark Uncaught Exceptions

typedef void   NSUncaughtExceptionHandler( void *exception);

NSUncaughtExceptionHandler *NSGetUncaughtExceptionHandler( void);
void   NSSetUncaughtExceptionHandler( NSUncaughtExceptionHandler *handler);

#endif
