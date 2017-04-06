#include <mulle_objc/mulle_objc.h>


@interface Foo
@end


static void   print_long_long( long long x)
{
   switch( x)
   {
   case LLONG_MIN :
      printf( "LONG_LONG_MIN\n");
      break;

   case LLONG_MAX :
      printf( "LONG_LONG_MAX\n");
      break;

   default :
      printf( "%ld\n", x);
      return;
   }
}


@implementation Foo

+ (void) long_long:(long long) a
{
   print_long_long( a);
}


// return value be different than argument
+ (long long) long_long2:(long long) x
{
   switch( x)
   {
   case 0  : return( LLONG_MIN);
   case 1  : return( 1848);
   case 2  : return( 0);
   case 3  : return( -1848);
   case 4  : return( LLONG_MAX);
   }
}


@end


main()
{
   [Foo long_long:LLONG_MIN];
   [Foo long_long:1848];
   [Foo long_long:0];
   [Foo long_long:-1848];
   [Foo long_long:LLONG_MAX];

   print_long_long( [Foo long_long2:0]);
   print_long_long( [Foo long_long2:1]);
   print_long_long( [Foo long_long2:2]);
   print_long_long( [Foo long_long2:3]);
   print_long_long( [Foo long_long2:4]);
}
