#include <mulle_objc/mulle_objc.h>


@interface Foo
@end


static void   print_long( long x)
{
   switch( x)
   {
   case LONG_MIN :
      printf( "LONG_MIN\n");
      break;

   case LONG_MAX :
      printf( "LONG_MAX\n");
      break;

   default :
      printf( "%ld\n", x);
      return;
   }
}


@implementation Foo

+ (void) long:(long) a
{
   print_long( a);
}


// return value be different than argument
+ (long) long2:(long) x
{
   switch( x)
   {
   case 0  : return( LONG_MIN);
   case 1  : return( 1848);
   case 2  : return( 0);
   case 3  : return( -1848);
   case 4  : return( LONG_MAX);
   }
}


@end


main()
{
   [Foo long:LONG_MIN];
   [Foo long:1848];
   [Foo long:0];
   [Foo long:-1848];
   [Foo long:LONG_MAX];

   print_long( [Foo long2:0]);
   print_long( [Foo long2:1]);
   print_long( [Foo long2:2]);
   print_long( [Foo long2:3]);
   print_long( [Foo long2:4]);
}
