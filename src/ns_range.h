/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSRange.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#ifndef ns_range__h__
#define ns_range__h__

#include "ns_type.h"


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


static inline BOOL  NSLocationInRange( NSUInteger location, NSRange range) 
{
   return( location - range.location < range.length);
}


static inline BOOL   NSEqualRanges( NSRange range1, NSRange range2) 
{
    return( range1.location == range2.location && range1.length == range2.length);
}


extern NSRange    NSUnionRange( NSRange range1, NSRange range2);
extern NSRange    NSIntersectionRange( NSRange range1, NSRange range2);


// mulle additon:
static inline BOOL  MulleObjCRangeContainsRange( NSRange big, NSRange small)
{
   if( ! small.length)
      return( NO);
   
   if( ! NSLocationInRange( small.location, big))
      return( NO);
   return( NSLocationInRange( small.location + small.length - 1, big));
}

#endif
