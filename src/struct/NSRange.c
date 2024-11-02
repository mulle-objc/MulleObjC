//
//  ns_range.m
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
#include "NSRange.h"


NSComparisonResult  MulleObjCRangePointerCompare( NSRange *a, NSRange *b)
{
   return( MulleObjCRangeCompare( *a, *b));
}


NSRange  MulleObjCRangeCombine( NSRange aRange, NSRange bRange)
{
   NSRange      *a = &aRange;
   NSRange      *b = &bRange;
   NSUInteger   a_end;
   NSUInteger   b_end;

   if( a->location > b->location)
   {
      a = &bRange;
      b = &aRange;
   }

   //
   // { 0, 2 } ==  0 1
   // { 3, 4 } ==  3 4 5 6
   //
   a_end = NSRangeGetMax( *a);
   if( a_end < b->location)
      return( NSRangeMake( NSNotFound, 0));

   b_end = NSRangeGetMax( *b);
   if( b_end > a_end)
      a_end = b_end;
   return( NSRangeMake( a->location, a_end - a->location));
}


char  *MulleObjCRangeUTF8String( NSRange range)
{
   extern void   *MulleObjCAutoreleaseAllocation( void *pointer,
                                                  struct mulle_allocator *allocator);  
   char   *s;

   mulle_buffer_do_string( buffer, NULL, s)
   {
      mulle_buffer_sprintf( buffer, "[%td,%td]", range.location, range.length);
   }
   return( MulleObjCAutoreleaseAllocation( s, NULL));
}
