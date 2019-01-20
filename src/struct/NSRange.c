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


NSRange   NSIntersectionRange( NSRange range, NSRange other)
{
   NSUInteger   location;
   NSUInteger   min;
   NSUInteger   max1;
   NSUInteger   max2;
   NSRange      result;

   max1 = NSMaxRange( range);
   max2 = NSMaxRange( other);
   min  = (max1 < max2) ? max1 : max2;
   location  = (range.location > other.location) ? range.location : other.location;

   if( min < location)
      result.location = result.length = 0;
   else
   {
      result.location = location;
      result.length   = min - location;
   }

   return( result);
}


NSRange   NSUnionRange( NSRange range, NSRange other)
{
   NSUInteger   location;
   NSUInteger   max;
   NSUInteger   max1;
   NSUInteger   max2;
   NSRange      result;

   max1 = NSMaxRange( range);
   max2 = NSMaxRange( other);
   max  = (max1 > max2) ? max1 : max2;
   location  = (range.location < other.location) ? range.location : other.location;

   result.location = location;
   result.length   = max - result.location;
   return(result);
}