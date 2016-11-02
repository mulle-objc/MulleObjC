#include <mulle_objc/mulle_objc.h>


@interface Foo
@end


static void   print_char( char x)
{
   switch( x)
   {
   case CHAR_MIN :
      printf( "CHAR_MIN\n");
      break;

   case CHAR_MAX :
      printf( "CHAR_MAX\n");
      break;

   default :
      printf( "%d\n", (int) x);
      return;
   }
}


@implementation Foo

+ (void) char:(char) a
{
   print_char( a);
}


// return value be different than argument
+ (char) char2:(char) x
{
   switch( x)
   {
   case 0  : return( CHAR_MIN);
   case 1  : return( 18);
   case 2  : return( 0);
   case 3  : return( -18);
   case 4  : return( CHAR_MAX);
   }
}


@end


main()
{
   [Foo char:CHAR_MIN];
   [Foo char:18];
   [Foo char:0];
   [Foo char:-18];
   [Foo char:CHAR_MAX];

   print_char( [Foo char2:0]);
   print_char( [Foo char2:1]);
   print_char( [Foo char2:2]);
   print_char( [Foo char2:3]);
   print_char( [Foo char2:4]);
}
