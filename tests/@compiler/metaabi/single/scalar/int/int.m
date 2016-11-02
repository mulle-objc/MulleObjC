#include <mulle_objc/mulle_objc.h>


@interface Foo
@end


static void   print_int( int x)
{
   switch( x)
   {
   case INT_MIN :
      printf( "INT_MIN\n");
      break;

   case INT_MAX :
      printf( "INT_MAX\n");
      break;

   default :
      printf( "%d\n", x);
      return;
   }
}


@implementation Foo

+ (void) int:(int) a
{
   print_int( a);
}


// return value be different than argument
+ (int) int2:(int) x
{
   switch( x)
   {
   case 0  : return( INT_MIN);
   case 1  : return( 1848);
   case 2  : return( 0);
   case 3  : return( -1848);
   case 4  : return( INT_MAX);
   }
}


@end


main()
{
   [Foo int:INT_MIN];
   [Foo int:1848];
   [Foo int:0];
   [Foo int:-1848];
   [Foo int:INT_MAX];

   print_int( [Foo int2:0]);
   print_int( [Foo int2:1]);
   print_int( [Foo int2:2]);
   print_int( [Foo int2:3]);
   print_int( [Foo int2:4]);
}
