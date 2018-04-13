#include <MulleObjC/dependencies.h>
#include <float.h>


@interface Foo
@end


static void   print_double( double x)
{
   if( x == DBL_MIN)
   {
      printf( "DBL_MIN\n");
      return;
   }

   if( x == DBL_MAX)
   {
      printf( "DBL_MAX\n");
      return;
   }

   printf( "%f\n", x);
}


@implementation Foo

+ (void) double:(double) a
{
   print_double( a);
}


// return value be different than argument
+ (double) double2:(int) x
{
   switch( x)
   {
   case 0  : return( DBL_MIN);
   case 1  : return( 18.48f);
   case 2  : return( 0);
   case 3  : return( -18.48f);
   case 4  : return( DBL_MAX);
   }
}


@end


main()
{
   [Foo double:DBL_MIN];
   [Foo double:18.48f];
   [Foo double:0];
   [Foo double:-18.48f];
   [Foo double:DBL_MAX];

   print_double( [Foo double2:0]);
   print_double( [Foo double2:1]);
   print_double( [Foo double2:2]);
   print_double( [Foo double2:3]);
   print_double( [Foo double2:4]);
}
