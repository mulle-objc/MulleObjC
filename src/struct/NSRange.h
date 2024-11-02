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
// or link the runtime, its in uppercase for legacy reasons

#ifndef ns_range__h__
#define ns_range__h__

#include "include.h"

#include "MulleObjCIntegralType.h"

#include <assert.h>


typedef struct mulle_range   NSRange;
typedef NSRange              *NSRangePointer;

#define NSNotFound           mulle_not_found_e


//
// can be used in many methods to specify { 0, [self length] }
// The actual maximum range is { 0, mulle_range_location_max + 1}, though
//
static inline NSRange   MulleMakeFullRange( void)
{
   NSRange    range;

   range.location = 0;
   range.length   = (NSUInteger) -1;

   return( range);
}


static inline NSRange   NSRangeMake( NSUInteger location, NSUInteger length)
{
   NSRange    range;

   range.location = location;
   range.length   = length;

   return( range);
}


static inline NSUInteger   NSRangeGetLocation( NSRange range)
{
  return( range.location);
}


static inline NSUInteger   NSRangeGetLength( NSRange range)
{
  return( range.length);
}


static inline NSUInteger   NSRangeGetMax( NSRange range)
{
  return( mulle_range_get_max( range));
}



// use enum here instead of BOOL, because windows
// will define BOOL in <windows.h>, but when compiling
// MulleObjC.h it won't be there
//
static inline enum _MulleBool   NSRangeContainsLocation( NSRange range, 
                                                         NSUInteger location)
{
   return( mulle_range_contains_location( range, location));
}


static inline enum _MulleBool   NSRangeEqualToRange( NSRange range1, NSRange range2)
{
    return( range1.location == range2.location && range1.length == range2.length);
}


static inline NSRange   NSRangeUnion( NSRange range1, NSRange range2)
{
   return( mulle_range_union( range1, range2));
}


static inline NSRange   NSRangeIntersect( NSRange range1, NSRange range2)
{
   return( mulle_range_intersect( range1, range2));
}


//
// creates a hole of range2 in range1, result[ 0] will be the "cut" front of
// range1 and result[ 1] will be the back.
//
static inline void   MulleObjCRangeSubtract( NSRange range1,
                                             NSRange range2,
                                             NSRange result[ 2])
{
   mulle_range_subtract( range1, range2, result);
}



static inline NSUInteger   MulleObjCRangeInsert( NSRange range1,
                                                 NSRange range2,
                                                 NSRange result[ 2])
{
   return( mulle_range_insert( range1, range2, result));
}


// "legacy" support
// the old naming scheme was more readable but it didn't "complete" as well
// 

static inline NSRange   NSMakeRange( NSUInteger location, NSUInteger length)
{
   return( NSRangeMake( location, length));
}


static inline NSUInteger   NSMaxRange( NSRange range)
{
   return( NSRangeGetMax( range));
}


static inline enum _MulleBool   NSLocationInRange( NSUInteger location, NSRange range)
{
   return( NSRangeContainsLocation( range, location));
}


static inline enum _MulleBool   NSEqualRanges( NSRange range1, NSRange range2)
{
    return( NSRangeEqualToRange( range1, range2));
}


static inline NSRange   NSUnionRange( NSRange range1, NSRange range2)
{
   return( NSRangeUnion( range1, range2));
}


static inline NSRange   NSIntersectionRange( NSRange range1, NSRange range2)
{
   return( NSRangeIntersect( range1, range2));
}




// mulle additon:

// returns invalid range if range is not usable
static inline NSRange   MulleObjCRangeValidateAgainstLength( NSRange range, NSUInteger length)
{
   return( mulle_range_validate_against_length( range, length));
}


static inline enum _MulleBool   MulleObjCRangeIsValid( NSRange range)
{
   return( mulle_range_is_valid( range));
}


static inline NSRange   MulleObjCMakeInvalidRange( void)
{
   return( mulle_range_make_invalid());
}



static inline enum _MulleBool   MulleObjCRangeContainsRange( NSRange big, NSRange small)
{
   return( mulle_range_contains( big, small));
}


NSRange  MulleObjCRangeCombine( NSRange aRange, NSRange bRange);


static inline enum _MulleBool   MulleObjCRangeIsCombinableRange( NSRange a, NSRange b)
{
   return( MulleObjCRangeCombine( a, b).length ? YES : NO);
}


static inline enum _MulleBool   MulleObjCRangeIntersectsRange( NSRange a, NSRange b)
{
   return( NSRangeIntersect( a, b).length ? YES : NO);
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


char  *MulleObjCRangeUTF8String( NSRange range);


#define MulleObjCRangeFor( range, name)                               \
   for( NSUInteger name          = (range).location,                  \
                   name ## __end = (range).location + (range).length; \
        name < name ## __end;                                         \
        ++name                                                        \
      )

#endif
