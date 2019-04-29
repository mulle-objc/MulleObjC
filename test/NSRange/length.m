#import <MulleObjC/MulleObjC.h>

#include <stdio.h>
#include <stdint.h>


static void   test_is_valid_with_length( NSRange range, NSUInteger length)
{
   printf( "[%ld - %ld] in range [%ld - %ld] is %s\n",
               (long) range.location, (long) (range.location + range.length),
               (long) 0, (long) length,
               MulleObjCRangeIsValidWithLength( range, length) ? "OK" : "INVALID");
}



int   main( void)
{
   NSRange      range;
   NSUInteger   length;

   for( range.location = -2; range.location != 3; range.location++)
      for( range.length = -2; range.length != 3; range.length++)
      {
         for( length = -2; length != 6; length += 2)
               test_is_valid_with_length( range, length);
         printf( "\n");
      }

   return( 0);
}

