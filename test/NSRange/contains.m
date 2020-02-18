#import <MulleObjC/MulleObjC.h>

#include <stdio.h>
#include <stdint.h>



static void   test_contains_range( NSRange range1, NSRange range2)
{
   printf( "[%ld,%ld] contains range [%ld,%ld] ? %s\n",
               (long) range1.location, (long) range1.length,
               (long) range2.location, (long) range2.length,
      MulleObjCRangeContainsRange( range1, range2) ? "YES" : "NO");
}


int   main( void)
{
   NSRange   range1;
   NSRange   range2;

   for( range2.location = -2; range2.location != 3; range2.location++)
      for( range2.length = -2; range2.length != 3; range2.length++)
         if( MulleObjCRangeIsValid( range2))
         {

            for( range1.location = -2; range1.location != 3; range1.location++)
               for( range1.length = -2; range1.length != 3; range1.length++)
                  if( MulleObjCRangeIsValid( range1))
                     test_contains_range( range1, range2);
            printf( "\n");
         }
   return( 0);
}

