#include <mulle_objc/mulle_objc.h>
#include <float.h>


@interface Foo
@end


static void   print_float( float x)
{
   if( x == FLT_MIN)
   {
      printf( "FLT_MIN\n");
      return;
   }

   if( x == FLT_MAX)
   {
      printf( "FLT_MIN\n");
      return;
   }

   printf( "%f\n", x);
}


@implementation Foo

+ (void) float:(float) a
{
   print_float( a);
}


// return value be different than argument
+ (float) float2:(int) x
{
   switch( x)
   {
   case 0  : return( FLT_MIN);
   case 1  : return( 18.48f);
   case 2  : return( 0);
   case 3  : return( -18.48f);
   case 4  : return( FLT_MAX);
   }
}


@end


main()
{
   [Foo float:FLT_MIN];
   [Foo float:18.48f];
   [Foo float:0];
   [Foo float:-18.48f];
   [Foo float:FLT_MAX];

   print_float( [Foo float2:0]);
   print_float( [Foo float2:1]);
   print_float( [Foo float2:2]);
   print_float( [Foo float2:3]);
   print_float( [Foo float2:4]);
}
