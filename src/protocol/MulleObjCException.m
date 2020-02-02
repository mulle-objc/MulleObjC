//
//  MulleObjCException.m
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

#import "MulleObjCException.h"

#import "MulleObjCExceptionHandler.h"

#include "mulle-objc-exceptionhandlertable-private.h"
#include "mulle-objc-universefoundationinfo-private.h"
#include <stdarg.h>


#pragma clang diagnostic ignored "-Wobjc-root-class"


@interface MulleObjCException < MulleObjCException>

// don't use __attribute(( noreturn)), the compiler will produce
// wrong code for
// exception = nil;
// ...
// [exception raise];
//
- (void) raise;

@end


@implementation MulleObjCException

- (void) raise
{
   mulle_objc_throw( self);
}


- (char *) cStringDescription
{
   return( _mulle_objc_class_get_name( _mulle_objc_object_get_isa( self)));
}

@end



MULLE_C_NO_RETURN
void  _MulleObjCThrowInvalidArgumentException( mulle_objc_universeid_t universeid,
                                              id format, ...)
{
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_universefoundationinfo   *rootconfig;
   va_list                                     args;

   universe   = mulle_objc_global_get_universe( universeid);
   rootconfig = _mulle_objc_universe_get_foundationdata( universe);

   va_start( args, format);
   (*rootconfig->exception.vectors.invalid_argument)( format, args);
   va_end( args);
}


MULLE_C_NO_RETURN
void   _MulleObjCThrowInvalidIndexException( mulle_objc_universeid_t universeid,
                                             NSUInteger index)
{
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_universefoundationinfo   *rootconfig;

   universe   = mulle_objc_global_get_universe( universeid);
   rootconfig = _mulle_objc_universe_get_foundationdata( universe);

   (*rootconfig->exception.vectors.invalid_index)( index);
}


MULLE_C_NO_RETURN
void   _MulleObjCThrowInternalInconsistencyException( mulle_objc_universeid_t universeid,
                                                      id format, ...)
{
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_universefoundationinfo   *rootconfig;
   va_list                                     args;

   universe   = mulle_objc_global_get_universe( universeid);
   rootconfig = _mulle_objc_universe_get_foundationdata( universe);

   va_start( args, format);
   (*rootconfig->exception.vectors.internal_inconsistency)( format, args);
   va_end( args);
}



MULLE_C_NO_RETURN
void   _MulleObjCThrowInvalidRangeException( mulle_objc_universeid_t universeid,
                                             NSRange range)
{
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_universefoundationinfo   *rootconfig;

   universe   = mulle_objc_global_get_universe( universeid);
   rootconfig = _mulle_objc_universe_get_foundationdata( universe);

   (*rootconfig->exception.vectors.invalid_range)( range);
}


MULLE_C_NO_RETURN
void   _MulleObjCThrowErrnoException( mulle_objc_universeid_t universeid,
                                      id format, ...)
{
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_universefoundationinfo   *rootconfig;
   va_list                                     args;

   universe   = mulle_objc_global_get_universe( universeid);
   rootconfig = _mulle_objc_universe_get_foundationdata( universe);

   va_start( args, format);
   (*rootconfig->exception.vectors.errno_error)( format, args);
   va_end( args);
}


/*
 * C String interface
 */
MULLE_C_NO_RETURN
void   _MulleObjCThrowInvalidArgumentExceptionCString( mulle_objc_universeid_t universeid,
                                                       char *format, ...)
{
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_universefoundationinfo   *rootconfig;
   va_list                                     args;
   id                                          string;


   universe   = mulle_objc_global_get_universe( universeid);
   rootconfig = _mulle_objc_universe_get_foundationdata( universe);

   va_start( args, format);
   string     = (*rootconfig->string.objectfromchars)( format);
   (*rootconfig->exception.vectors.invalid_argument)( string, args);
   va_end( args);
}


MULLE_C_NO_RETURN
void   _MulleObjCThrowInternalInconsistencyExceptionCString( mulle_objc_universeid_t universeid,
                                                             char *format, ...)
{
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_universefoundationinfo   *rootconfig;
   va_list                                     args;
   id                                          string;

   universe   = mulle_objc_global_get_universe( universeid);
   rootconfig = _mulle_objc_universe_get_foundationdata( universe);

   va_start( args, format);
   string     = (*rootconfig->string.objectfromchars)( format);
   (*rootconfig->exception.vectors.internal_inconsistency)( string, args);
   va_end( args);
}


MULLE_C_NO_RETURN
void   _MulleObjCThrowErrnoExceptionCString( mulle_objc_universeid_t universeid,
                                             char *format, ...)
{
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_universefoundationinfo   *rootconfig;
   va_list                                     args;
   id                                          string;

   universe   = mulle_objc_global_get_universe( universeid);
   rootconfig = _mulle_objc_universe_get_foundationdata( universe);

   va_start( args, format);
   string     = (*rootconfig->string.objectfromchars)( format);
   (*rootconfig->exception.vectors.errno_error)( string, args);
   va_end( args);
}


