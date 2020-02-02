//
//  _mulle_objc_exception.h
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
#ifndef mulle_objc_exceptionhandlertable__h__
#define mulle_objc_exceptionhandlertable__h__

//
// These exceptions vectors are only used by MulleObjC to generate exceeptions.
// User code uses NSException, which will ignore this.
//
struct _mulle_objc_exceptionhandlertable
{
   void (*errno_error)( id format, va_list args)            MULLE_C_NO_RETURN;
   void (*internal_inconsistency)( id format, va_list args) MULLE_C_NO_RETURN;
   void (*invalid_argument)( id format, va_list args)       MULLE_C_NO_RETURN;
   void (*invalid_index)( NSUInteger i)                     MULLE_C_NO_RETURN;
   void (*invalid_range)( NSRange range)                    MULLE_C_NO_RETURN;
};

MULLE_C_NO_RETURN
void  mulle_objc_throw_foundation_errno_error( id format, ...);

MULLE_C_NO_RETURN
void  mulle_objc_throw_foundation_internal_inconsistency( id format, ...);

MULLE_C_NO_RETURN
void  mulle_objc_throw_foundation_invalid_argument( id format, ...);

MULLE_C_NO_RETURN
void  mulle_objc_throw_foundation_invalid_index( NSUInteger i);

MULLE_C_NO_RETURN
void  mulle_objc_throw_foundation_invalid_range( NSRange range);

#endif
