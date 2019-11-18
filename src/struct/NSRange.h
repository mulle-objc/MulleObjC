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

#include "include.h"

#include "MulleObjCIntegralType.h"

#include <assert.h>


typedef struct mulle_range   NSRange;
typedef NSRange              *NSRangePointer;

#define NSNotFound           mulle_not_found_e


static inline NSRange   NSMakeRange( NSUInteger location, NSUInteger length)
{
    NSRange    range;

    range.location = location;
    range.length   = length;
    return( range);
}


static inline NSUInteger   NSMaxRange( NSRange range)
{
   return( mulle_range_get_end( range));
}


// use enum here instead of BOOL, because windows
// will define BOOL in <windows.h>, but when compiling
// MulleObjC.h it won't be there
//
static inline enum _MulleBool   NSLocationInRange( NSUInteger location, NSRange range)
{
   return( mulle_range_contains_location( range, location));
}


static inline enum _MulleBool   NSEqualRanges( NSRange range1, NSRange range2)
{
    return( range1.location == range2.location && range1.length == range2.length);
}


static inline NSRange   NSUnionRange( NSRange range1, NSRange range2)
{
   return( mulle_range_union( range1, range2));
}


static inline NSRange   NSIntersectionRange( NSRange range1, NSRange range2)
{
   return( mulle_range_intersect( range1, range2));
}


// mulle additon:

static inline enum _MulleBool   MulleObjCRangeIsValid( NSRange range)
{
   return( mulle_range_is_valid( range));
}



static inline enum _MulleBool   MulleObjCRangeContainsRange( NSRange big, NSRange small)
{
   return( mulle_range_contains( big, small));
}


NSRange  MulleObjCRangeCombine( NSRange aRange, NSRange bRange);


static enum _MulleBool   MulleObjCRangeIsCombinableRange( NSRange a, NSRange b)
{
   return( MulleObjCRangeCombine( a, b).length ? YES : NO);
}


static enum _MulleBool   MulleObjCRangeIntersectsRange( NSRange a, NSRange b)
{
   return( NSIntersectionRange( a, b).length ? YES : NO);
}


static inline NSComparisonResult   MulleObjCRangeCompare( NSRange a, NSRange b)
{
   if( a.location != b.location)
      return( a.location < b.location ? NSOrderedAscending : NSOrderedDescending);
   if( a.length != b.length)
      return( a.length < b.length ? NSOrderedAscending : NSOrderedDescending);
   return( NSOrderedSame);
}

NSComparisonResult   MulleObjCRangePointerCompare( NSRange *a, NSRange *b);

#endif
