#include <mulle_objc_runtime/mulle_objc_runtime.h>

struct bar
{
   char     a;
   int      b;
   char     huge[ 256];
   long     c;
   double   d;
};

@interface Foo
@end


@implementation Foo

// return value be different than argument

+ (struct bar) bogus_clear:(struct bar) x
{
   printf( "%d,%d,%ld,%f\n", x.a, x.b, x.c, x.d);

   memset( &x, 0, sizeof( x));
   return( x);
}


+ (struct bar) struct_bar:(struct bar) x
{
   struct bar   y;

   y = [self bogus_clear:x];

   y.a = x.a * 2;
   y.b = x.b * 2;
   y.c = x.c * 2;
   y.d = x.d * 2;

   return( y);
}


+ (struct bar) struct_bar2:(struct bar) x
{
   struct bar   y;

   y.a = x.a / 2;
   y.b = x.b / 2;
   y.c = x.c / 2;
   y.d = x.d / 2;

   x = [self bogus_clear:x];

   return( y);
}

@end


main()
{
   struct bar   x;
   struct bar   y;
   struct bar   z;

   x.a = 18;
   x.b = 1848;
   x.c = 1848;
   x.d = 18.48;

   y = [Foo struct_bar:x];
   z = [Foo struct_bar2:y];

   printf( "%d,%d,%ld,%f\n", x.a, x.b, x.c, x.d);
   printf( "%d,%d,%ld,%f\n", y.a, y.b, y.c, y.d);
   printf( "%d,%d,%ld,%f\n", z.a, z.b, z.c, z.d);
}
