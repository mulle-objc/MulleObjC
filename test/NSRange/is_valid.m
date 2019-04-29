#import <MulleObjC/MulleObjC.h>

#include <stdio.h>
#include <stdint.h>


static void   test_is_valid( NSRange range)
{
   printf( "[%ld - %ld] is %s\n",
               (long) range.location,
               (long) (range.location + range.length),
               MulleObjCRangeIsValid( range) ? "OK" : "INVALID");
}


int   main( void)
{
   NSRange      range;
   NSUInteger   length;

   for( range.location = -2; range.location != 3; range.location++)
      for( range.length = -2; range.length != 3; range.length++)
         test_is_valid( range);

   return( 0);
}


