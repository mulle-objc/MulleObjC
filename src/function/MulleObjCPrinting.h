//
//  MulleObjCPrinting.m
//  MulleObjC
//
//  Copyright (c) 2022 Nat! - Mulle kybernetiK.
//  Copyright (c) 2022 Codeon GmbH.
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
#ifndef MulleObjCPrinting_h__
#define MulleObjCPrinting_h__

#include "mulle-objc.h"

#include <stdarg.h>


//
// C format strings, the returned char * is autoreleased!
//
MULLE_OBJC_GLOBAL
char   *MulleObjC_vasprintf( char *format, va_list args);

MULLE_OBJC_GLOBAL
char   *MulleObjC_mvasprintf( char *format, mulle_vararg_list args);

MULLE_OBJC_GLOBAL
char   *MulleObjC_asprintf( char *format, ...);

MULLE_OBJC_GLOBAL
char   *MulleObjC_strdup( char *s);



#define mulle_buffer_do_autoreleased_string( name, allocator, s)               \
   for( struct mulle_buffer name ## __storage = MULLE_BUFFER_DATA( allocator), \
                            *name = &name ## __storage,                        \
                            name ## __i = { 0 };                               \
                                                                               \
        s = (name ## __i._storage)                                             \
               ? MulleObjCAutoreleaseAllocation(                               \
                   mulle_buffer_extract_string( &name ## __storage),           \
                   (allocator))                                                \
               : NULL,                                                         \
        ! name ## __i._storage;                                                \
                                                                               \
        name ## __i._storage = (void *) 0x1                                    \
      )                                                                        \
                                                                               \
      for( int  name ## __j = 0;    /* break protection */                     \
           name ## __j < 1;                                                    \
           name ## __j++)

#endif
