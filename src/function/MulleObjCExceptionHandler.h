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

#ifndef MulleObjCExceptionHandler__h__
#define MulleObjCExceptionHandler__h__

// requires: UNIVERSE

#include "mulle-objc.h"

#include "MulleObjCIntegralType.h"
#include "NSRange.h"
#include <stdarg.h>



// calls the runtime to really throw, used by NSException later
MULLE_C_NO_RETURN void
   mulle_objc_throw( void *exception);

//
// the function to set breakpoints to, to catch all exceptions
//
void  mulle_objc_break_exception( void);

#pragma mark -
#pragma mark Uncaught Exceptions

#ifndef MULLE_OBJC_EXCEPTION_CLASS_P
# define MULLE_OBJC_EXCEPTION_CLASS_P  void *
#endif

typedef void   NSUncaughtExceptionHandler( MULLE_OBJC_EXCEPTION_CLASS_P exception);

NSUncaughtExceptionHandler   *NSGetUncaughtExceptionHandler( void);
void   NSSetUncaughtExceptionHandler( NSUncaughtExceptionHandler *handler);

#endif
