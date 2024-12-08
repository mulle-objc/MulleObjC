//
//  MulleObjCHash.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2017 Nat! - Mulle kybernetiK.
//  Copyright (c) 2017 Codeon GmbH.
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
#ifndef MulleObjCHashFunctions_h__
#define MulleObjCHashFunctions_h__

#include "include.h"

#include "NSRange.h"



// limit hash to last 64 bytes

static inline NSRange   MulleObjCGetHashBytesRange( NSUInteger length)
{
   NSUInteger   offset;

   offset = 0;
   if( length > 64)
   {
      offset = length - 64;
      length = 64;
   }
   return( NSRangeMake( offset, length));
}


static inline NSUInteger   MulleObjCBytesHash( void *buf, NSUInteger length)
{
   if( ! buf)
      return( -1);
   return( mulle_data_hash( mulle_data_make( buf, length)));
}


static inline NSUInteger   MulleObjCBytesHashRange( void *buf, NSRange range)
{
   if( ! buf)
      return( -1);
   return( mulle_data_hash( mulle_data_make( &((char *)buf)[ range.location], range.length)));
}


static inline NSUInteger   MulleObjCBytesPartialHash( void *buf, NSUInteger length)
{
   NSRange   range;

   range = MulleObjCGetHashBytesRange( length);
   return( MulleObjCBytesHashRange( buf, range));
}

#endif
