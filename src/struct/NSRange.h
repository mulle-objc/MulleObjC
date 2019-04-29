//
//  ns_range.h
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

// This header should be includeable by C and must not require inclusion
// or link the runtime

#ifndef ns_range__h__
#define ns_range__h__

#include "MulleObjCIntegralType.h"

#include <assert.h>


typedef struct
{
   NSUInteger   location;
   NSUInteger   length;
} NSRange;


typedef NSRange   *NSRangePointer;


static inline NSRange   NSMakeRange( NSUInteger location, NSUInteger length)
{
    NSRange    range;

    range.location = location;
    range.length   = length;
    return( range);
}


static inline   NSUInteger NSMaxRange( NSRange range)
{
   return( range.location + range.length);
}


// use enum here instead of BOOL, because windows
// will define BOOL in <windows.h>, but when compiling
// MulleObjC.h it won't be there
//
static inline enum _MulleBool   NSLocationInRange( NSUInteger location, NSRange range)
{
   return( location - range.location < range.length);
}


static inline enum _MulleBool   NSEqualRanges( NSRange range1, NSRange range2)
{
    return( range1.location == range2.location && range1.length == range2.length);
}


extern NSRange    NSUnionRange( NSRange range1, NSRange range2);
extern NSRange    NSIntersectionRange( NSRange range1, NSRange range2);


// mulle additon:

static inline enum _MulleBool  MulleObjCRangeIsValid( NSRange range)
{
   NSUInteger   end;

   end = range.location + range.length;
   // check for overflow
   return( end >= range.location || end == 0); //|| (end == range.location && range.length == 0));
}


static inline enum _MulleBool  MulleObjCRangeIsValidWithLength( NSRange range, NSUInteger length)
{
   NSUInteger   end;

   if( ! MulleObjCRangeIsValid( range))
      return( NO);

   end = range.location + range.length;
   return( end <= length && range.location <= length);
}


// other must have been validated already!
static inline enum _MulleBool  MulleObjCRangeIsValidInRange( NSRange range, NSRange other)
{
   NSUInteger   end;
   NSUInteger   other_end;

   assert( MulleObjCRangeIsValid( other));
   if( ! MulleObjCRangeIsValid( range))
      return( NO);

   end       = range.location + range.length;
   other_end = other.location + other.length;
   return( end <= other_end && range.location >= other.location);
}


static inline enum _MulleBool  MulleObjCRangeContainsRange( NSRange big, NSRange small)
{
   if( ! small.length)
      return( NO);

   if( ! NSLocationInRange( small.location, big))
      return( NO);
   return( NSLocationInRange( small.location + small.length - 1, big));
}

#endif
