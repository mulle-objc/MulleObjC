//
//  main.m
//  NSRangeEmpty
//
//  Created by Nat! on 18.02.20.
//  Copyright © 2020 Mulle kybernetiK. All rights reserved.
//
#ifdef __MULLE_OBJC__
# import <MulleObjC/MulleObjC.h>
#else
# import <Foundation/Foundation.h>
#endif


void   print_range( NSRange range)
{
   printf( "{%lu, %lu}", range.location, range.length);;
}



static void   test_intersection( NSRange a, NSRange b)
{
   NSRange   c;

   c = NSIntersectionRange( a, b);

   printf( "NSIntersectionRange( ");
   print_range( a);
   printf( ", ");
   print_range( b);
   printf( ") = ");
   print_range( c);
   printf( "\n");
}


static void   test_union( NSRange a, NSRange b)
{
   NSRange   c;

   c = NSUnionRange( a, b);

   printf( "NSUnionRange( ");
   print_range( a);
   printf( ", ");
   print_range( b);
   printf( ") = ");
   print_range( c);
   printf( "\n");
}


static void   test_equals( NSRange a, NSRange b)
{
   char   *s;

   s = NSEqualRanges( a, b)  ? "YES" : "NO";

   printf( "NSEqualRanges( ");
   print_range( a);
   printf( ", ");
   print_range( b);
   printf( ") = %s\n", s);
}


static void   test_location( NSRange a, NSUInteger b)
{
   char   *s;

   s = NSLocationInRange( b, a)  ? "YES" : "NO";

   printf( "NSLocationInRange( %lu, ", b);
   print_range( a);
   printf( ") = %s\n", s);
}



/*
OUTPUT on MacOS:

NSIntersectionRange( {0, 0}, {0, 0}) = {0, 0}
NSIntersectionRange( {0, 0}, {1, 0}) = {0, 0}
NSIntersectionRange( {0, 0}, {0, 2}) = {0, 0}
NSIntersectionRange( {0, 0}, {1, 2}) = {0, 0}
NSIntersectionRange( {1, 0}, {0, 0}) = {0, 0}
NSIntersectionRange( {1, 0}, {1, 0}) = {0, 0}
NSIntersectionRange( {1, 0}, {0, 2}) = {1, 0}
NSIntersectionRange( {1, 0}, {1, 2}) = {1, 0}
NSIntersectionRange( {0, 2}, {0, 0}) = {0, 0}
NSIntersectionRange( {0, 2}, {1, 0}) = {1, 0}
NSIntersectionRange( {0, 2}, {0, 2}) = {0, 2}
NSIntersectionRange( {0, 2}, {1, 2}) = {1, 1}
NSIntersectionRange( {1, 2}, {0, 0}) = {0, 0}
NSIntersectionRange( {1, 2}, {1, 0}) = {1, 0}
NSIntersectionRange( {1, 2}, {0, 2}) = {1, 1}
NSIntersectionRange( {1, 2}, {1, 2}) = {1, 2}
NSUnionRange( {0, 0}, {0, 0}) = {0, 0}
NSUnionRange( {0, 0}, {1, 0}) = {0, 1}
NSUnionRange( {0, 0}, {0, 2}) = {0, 2}
NSUnionRange( {0, 0}, {1, 2}) = {0, 3}
NSUnionRange( {1, 0}, {0, 0}) = {0, 1}
NSUnionRange( {1, 0}, {1, 0}) = {1, 0}
NSUnionRange( {1, 0}, {0, 2}) = {0, 2}
NSUnionRange( {1, 0}, {1, 2}) = {1, 2}
NSUnionRange( {0, 2}, {0, 0}) = {0, 2}
NSUnionRange( {0, 2}, {1, 0}) = {0, 2}
NSUnionRange( {0, 2}, {0, 2}) = {0, 2}
NSUnionRange( {0, 2}, {1, 2}) = {0, 3}
NSUnionRange( {1, 2}, {0, 0}) = {0, 3}
NSUnionRange( {1, 2}, {1, 0}) = {1, 2}
NSUnionRange( {1, 2}, {0, 2}) = {0, 3}
NSUnionRange( {1, 2}, {1, 2}) = {1, 2}
NSEqualRanges( {0, 0}, {0, 0}) = YES
NSEqualRanges( {0, 0}, {1, 0}) = NO
NSEqualRanges( {0, 0}, {0, 2}) = NO
NSEqualRanges( {0, 0}, {1, 2}) = NO
NSEqualRanges( {1, 0}, {0, 0}) = NO
NSEqualRanges( {1, 0}, {1, 0}) = YES
NSEqualRanges( {1, 0}, {0, 2}) = NO
NSEqualRanges( {1, 0}, {1, 2}) = NO
NSEqualRanges( {0, 2}, {0, 0}) = NO
NSEqualRanges( {0, 2}, {1, 0}) = NO
NSEqualRanges( {0, 2}, {0, 2}) = YES
NSEqualRanges( {0, 2}, {1, 2}) = NO
NSEqualRanges( {1, 2}, {0, 0}) = NO
NSEqualRanges( {1, 2}, {1, 0}) = NO
NSEqualRanges( {1, 2}, {0, 2}) = NO
NSEqualRanges( {1, 2}, {1, 2}) = YES
NSLocationInRange( 0, {0, 0}) = 0
NSLocationInRange( 1, {0, 0}) = 0
NSLocationInRange( 2, {0, 0}) = 0
NSLocationInRange( 3, {0, 0}) = 0
NSLocationInRange( 0, {1, 0}) = 0
NSLocationInRange( 1, {1, 0}) = 0
NSLocationInRange( 2, {1, 0}) = 0
NSLocationInRange( 3, {1, 0}) = 0
NSLocationInRange( 0, {0, 2}) = 1
NSLocationInRange( 1, {0, 2}) = 1
NSLocationInRange( 2, {0, 2}) = 0
NSLocationInRange( 3, {0, 2}) = 0
NSLocationInRange( 0, {1, 2}) = 0
NSLocationInRange( 1, {1, 2}) = 1
NSLocationInRange( 2, {1, 2}) = 1

*/

/* Our output is different, in these cases:

OUR                                           | Apple
----------------------------------------------|------------------------------------
NSIntersectionRange( {1, 0}, {1, 0}) = {1, 0} |  NSIntersectionRange( {1, 0}, {1, 0}) = {0, 0}
NSUnionRange( {0, 0}, {1, 0}) = {0, 0}        |  NSUnionRange( {0, 0}, {1, 0}) = {0, 1}
NSUnionRange( {0, 0}, {1, 2}) = {1, 2}        |  NSUnionRange( {0, 0}, {1, 2}) = {0, 3}
NSUnionRange( {1, 0}, {0, 0}) = {1, 0}        |  NSUnionRange( {1, 0}, {0, 0}) = {0, 1}
NSUnionRange( {1, 2}, {0, 0}) = {1, 2}        |  NSUnionRange( {1, 2}, {0, 0}) = {0, 3}

but I like it better, I don't think an empty range should extend a range
*/

int main(int argc, const char * argv[])
{
   NSRange   empty;
   NSRange   empty2;
   NSRange   full;
   NSRange   full2;

   empty  = NSRangeMake( 0, 0);
   empty2 = NSRangeMake( 1, 0);
   full   = NSRangeMake( 0, 2);
   full2  = NSRangeMake( 1, 2);


   test_intersection( empty, empty);
   test_intersection( empty, empty2);
   test_intersection( empty, full);
   test_intersection( empty, full2);

   test_intersection( empty2, empty);
   test_intersection( empty2, empty2);
   test_intersection( empty2, full);
   test_intersection( empty2, full2);

   test_intersection( full, empty);
   test_intersection( full, empty2);
   test_intersection( full, full);
   test_intersection( full, full2);

   test_intersection( full2, empty);
   test_intersection( full2, empty2);
   test_intersection( full2, full);
   test_intersection( full2, full2);

   test_union( empty, empty);
   test_union( empty, empty2);
   test_union( empty, full);
   test_union( empty, full2);

   test_union( empty2, empty);
   test_union( empty2, empty2);
   test_union( empty2, full);
   test_union( empty2, full2);

   test_union( full, empty);
   test_union( full, empty2);
   test_union( full, full);
   test_union( full, full2);

   test_union( full2, empty);
   test_union( full2, empty2);
   test_union( full2, full);
   test_union( full2, full2);

   test_equals( empty, empty);
   test_equals( empty, empty2);
   test_equals( empty, full);
   test_equals( empty, full2);

   test_equals( empty2, empty);
   test_equals( empty2, empty2);
   test_equals( empty2, full);
   test_equals( empty2, full2);

   test_equals( full, empty);
   test_equals( full, empty2);
   test_equals( full, full);
   test_equals( full, full2);

   test_equals( full2, empty);
   test_equals( full2, empty2);
   test_equals( full2, full);
   test_equals( full2, full2);

   test_location( empty, 0);
   test_location( empty, 1);
   test_location( empty, 2);
   test_location( empty, 3);

   test_location( empty2, 0);
   test_location( empty2, 1);
   test_location( empty2, 2);
   test_location( empty2, 3);

   test_location( full, 0);
   test_location( full, 1);
   test_location( full, 2);
   test_location( full, 3);

   test_location( full2, 0);
   test_location( full2, 1);
   test_location( full2, 2);
   test_location( full2, 3);

   return 0;
}
