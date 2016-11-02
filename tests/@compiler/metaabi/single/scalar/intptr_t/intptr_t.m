#include <mulle_objc/mulle_objc.h>


@interface Foo
@end


static void   print_intptr_t( intptr_t x)
{
   switch( x)
   {
   case INTPTR_MIN :
      printf( "INTPTR_MIN\n");
      break;

   case INTPTR_MAX :
      printf( "INTPTR_MAX\n");
      break;

   default :
      printf( "%ld\n", x);
      return;
   }
}


@implementation Foo

+ (void) intptr_t:(intptr_t) a
{
   print_intptr_t( a);
}


// return value be different than argument
+ (intptr_t) intptr_t2:(intptr_t) x
{
   switch( x)
   {
   case 0  : return( INTPTR_MIN);
   case 1  : return( 1848);
   case 2  : return( 0);
   case 3  : return( -1848);
   case 4  : return( INTPTR_MAX);
   }
}


@end


main()
{
   [Foo intptr_t:INTPTR_MIN];
   [Foo intptr_t:1848];
   [Foo intptr_t:0];
   [Foo intptr_t:-1848];
   [Foo intptr_t:INTPTR_MAX];

   print_intptr_t( [Foo intptr_t2:0]);
   print_intptr_t( [Foo intptr_t2:1]);
   print_intptr_t( [Foo intptr_t2:2]);
   print_intptr_t( [Foo intptr_t2:3]);
   print_intptr_t( [Foo intptr_t2:4]);
}
