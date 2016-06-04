/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSRange.c is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#include "ns_range.h"


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

