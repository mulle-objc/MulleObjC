#include <MulleObjC/dependencies.h>

struct bar_4
{
   void  *space[ 4];
};

struct bar_5
{
   void  *space[ 5];
};

struct bar_6
{
   void  *space[ 6];
};


@interface Foo
@end


@implementation Foo

+ (struct bar_4) bar_4_4:(struct bar_4) x
{
   struct bar_4   y;

   y.space[ 3] = x.space[ 0];
   y.space[ 2] = x.space[ 1];
   y.space[ 1] = x.space[ 2];
   y.space[ 0] = x.space[ 3];

   return( y);
}


+ (struct bar_5) bar_4_5:(struct bar_4) x
{
   struct bar_5   y;

   y.space[ 4] = x.space[ 0];
   y.space[ 3] = x.space[ 1];
   y.space[ 2] = x.space[ 2];
   y.space[ 1] = x.space[ 3];
   y.space[ 0] = -45;

   return( y);
}


+ (struct bar_6) bar_4_6:(struct bar_4) x
{
   struct bar_6   y;

   y.space[ 5] = x.space[ 0];
   y.space[ 4] = x.space[ 1];
   y.space[ 3] = x.space[ 2];
   y.space[ 2] = x.space[ 3];
   y.space[ 1] = -461;
   y.space[ 0] = -462;

   return( y);
}


+ (struct bar_4) bar_5_4:(struct bar_5) x
{
   struct bar_4   y;

   y.space[ 3] = x.space[ 0];
   y.space[ 2] = x.space[ 1];
   y.space[ 1] = x.space[ 2];
   y.space[ 0] = x.space[ 3];

   return( y);
}


+ (struct bar_5) bar_5_5:(struct bar_5) x
{
   struct bar_5   y;

   y.space[ 4] = x.space[ 0];
   y.space[ 3] = x.space[ 1];
   y.space[ 2] = x.space[ 2];
   y.space[ 1] = x.space[ 3];
   y.space[ 0] = x.space[ 4];

   return( y);
}


+ (struct bar_6) bar_5_6:(struct bar_5) x
{
   struct bar_6   y;

   y.space[ 5] = x.space[ 0];
   y.space[ 4] = x.space[ 1];
   y.space[ 3] = x.space[ 2];
   y.space[ 2] = x.space[ 3];
   y.space[ 1] = x.space[ 4];
   y.space[ 0] = -56;

   return( y);
}


+ (struct bar_4) bar_6_4:(struct bar_6) x
{
   struct bar_4   y;

   y.space[ 3] = x.space[ 0];
   y.space[ 2] = x.space[ 1];
   y.space[ 1] = x.space[ 2];
   y.space[ 0] = x.space[ 3];

   return( y);
}


+ (struct bar_5) bar_6_5:(struct bar_6) x
{
   struct bar_5   y;

   y.space[ 4] = x.space[ 0];
   y.space[ 3] = x.space[ 1];
   y.space[ 2] = x.space[ 2];
   y.space[ 1] = x.space[ 3];
   y.space[ 0] = x.space[ 4];

   return( y);
}


+ (struct bar_6) bar_6_6:(struct bar_6) x
{
   struct bar_6   y;

   y.space[ 5] = x.space[ 0];
   y.space[ 4] = x.space[ 1];
   y.space[ 3] = x.space[ 2];
   y.space[ 2] = x.space[ 3];
   y.space[ 1] = x.space[ 4];
   y.space[ 0] = x.space[ 5];

   return( y);
}



@end


static void   test1( void)
{
   struct bar_4   x0, x1, x2, x3, x4;

   // fill adjacent stuff with known values
   memset( &x0, 0xFF, sizeof( x0));
   memset( &x2, 0xFF, sizeof( x2));
   memset( &x4, 0xFF, sizeof( x4));

   x1.space[ 0] = (void *) 0x1;
   x1.space[ 1] = (void *) 0x2;
   x1.space[ 2] = (void *) 0x3;
   x1.space[ 3] = (void *) 0x4;

   x3 = [Foo bar_6_4:[Foo bar_5_6:[Foo bar_4_5:x1]]];

   assert( ! memcmp( &x0, &x2, sizeof( x0)));
   assert( ! memcmp( &x2, &x4, sizeof( x2)));

   printf( "%ld,%ld,%ld,%ld\n",
            (intptr_t) x3.space[ 0],
            (intptr_t) x3.space[ 1],
            (intptr_t) x3.space[ 2],
            (intptr_t) x3.space[ 3]);
}


static void   test2( void)
{
   struct bar_5   x0, x1, x2, x3, x4;

   // fill adjacent stuff with known values
   memset( &x0, 0xFF, sizeof( x0));
   memset( &x2, 0xFF, sizeof( x2));
   memset( &x4, 0xFF, sizeof( x4));

   x1.space[ 0] = (void *) 0x1;
   x1.space[ 1] = (void *) 0x2;
   x1.space[ 2] = (void *) 0x3;
   x1.space[ 3] = (void *) 0x4;
   x1.space[ 4] = (void *) 0x5;

   x3 = [Foo bar_4_5:[Foo bar_6_4:[Foo bar_5_6:x1]]];

   assert( ! memcmp( &x0, &x2, sizeof( x0)));
   assert( ! memcmp( &x2, &x4, sizeof( x2)));

   printf( "%ld,%ld,%ld,%ld,%ld\n",
            (intptr_t) x3.space[ 0],
            (intptr_t) x3.space[ 1],
            (intptr_t) x3.space[ 2],
            (intptr_t) x3.space[ 3],
            (intptr_t) x3.space[ 4]);
}


static void   test3( void)
{
   struct bar_6   x0, x1, x2, x3, x4;

   // fill adjacent stuff with known values
   memset( &x0, 0xFF, sizeof( x0));
   memset( &x2, 0xFF, sizeof( x2));
   memset( &x4, 0xFF, sizeof( x4));

   x1.space[ 0] = (void *) 0x1;
   x1.space[ 1] = (void *) 0x2;
   x1.space[ 2] = (void *) 0x3;
   x1.space[ 3] = (void *) 0x4;
   x1.space[ 4] = (void *) 0x5;
   x1.space[ 5] = (void *) 0x6;

   x3 = [Foo bar_4_6:[Foo bar_5_4:[Foo bar_6_5:x1]]];

   assert( ! memcmp( &x0, &x2, sizeof( x0)));
   assert( ! memcmp( &x2, &x4, sizeof( x2)));

   printf( "%ld,%ld,%ld,%ld,%ld,%ld\n",
            (intptr_t) x3.space[ 0],
            (intptr_t) x3.space[ 1],
            (intptr_t) x3.space[ 2],
            (intptr_t) x3.space[ 3],
            (intptr_t) x3.space[ 4],
            (intptr_t) x3.space[ 5]);
}

main()
{
   test1();
   test2();
   test3();
}
