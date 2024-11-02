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
#import "import-private.h"

#import "MulleObjCPrinting.h"

#import "MulleObjCAllocation.h"




char   *MulleObjC_mvasprintf( char *format, mulle_vararg_list args)
{
   char                  *s;
   struct mulle_buffer   buffer;

   if( ! format)
   {
      errno = EINVAL;
      return( NULL);
   }

   mulle_buffer_init_default( &buffer);
   mulle_buffer_mvsprintf( &buffer, format, args);
   mulle_buffer_make_string( &buffer);
   s = mulle_buffer_extract_string( &buffer);

   MulleObjCAutoreleaseAllocation( s, mulle_buffer_get_allocator( &buffer));
   mulle_buffer_done( &buffer);

   return( s);
}


char   *MulleObjC_vasprintf( char *format, va_list args)
{
   char                  *s;
   struct mulle_buffer   buffer;

   if( ! format)
   {
      errno = EINVAL;
      return( NULL);
   }

   mulle_buffer_init_default( &buffer);
   mulle_buffer_vsprintf( &buffer, format, args);
   mulle_buffer_make_string( &buffer);
   s = mulle_buffer_extract_string( &buffer);

   MulleObjCAutoreleaseAllocation( s, mulle_buffer_get_allocator( &buffer));
   mulle_buffer_done( &buffer);

   return( s);
}


char   *MulleObjC_asprintf( char *format, ...)
{
   va_list   args;
   char      *s;

   va_start( args, format);
   s = MulleObjC_vasprintf( format, args);
   va_end( args);
   return( s);
}


char   *MulleObjC_strdup( char *s)
{
   char                     *copy;
   struct mulle_allocator   *allocator;

   if( ! s)
      return( NULL);

   allocator = &mulle_default_allocator;
   copy      = mulle_allocator_strdup( allocator, s);
   MulleObjCAutoreleaseAllocation( copy, allocator);

   return( copy);
}
