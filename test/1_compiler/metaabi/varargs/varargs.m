//
//  main.m
//  test-varargs
//
//  Created by Nat! on 29.10.15.
//  Copyright © 2015 Mulle kybernetiK. All rights reserved.
//
#include <MulleObjC/dependencies.h>


@interface Foo

+ (void) varargs:(char *) types, ...;

@end


@implementation Foo

// make order unpleasant for alignment
struct call_1
{
   union { short v; int filler; } a;
   union { long long v; int filler; } b;
   union { char  v; int filler; } c;
   union { long  v; int filler; } d;
   union { int   v; int filler; } e;
};

struct call_2
{
   union { float  v; double filler; } a;
   union { double v; double filler; } b;
};


+ (void) varargs:(char *) types, ...
{
   mulle_vararg_list    args;
#if 0
   struct call_1        *call1;
   struct call_2        *call2;


   call1 = args.p;
   call2 = args.p;

   if( strlen( types) == 2)
   {
      printf( "call2->a.v -> %f\n", call2->a.v);
      printf( "call2->b.v -> %f\n", call2->b.v);
   }
   else
   {
      printf( "call1->a.v -> %d\n",   call1->a.v);
      printf( "call1->b.v -> %lld\n", call1->b.v);
      printf( "call1->c.v -> %d\n",   call1->c.v);
      printf( "call1->d.v -> %ld\n",  call1->d.v);
      printf( "call1->e.v -> %d\n",   call1->e.v);
   }
#endif

   mulle_vararg_start( args, types);
   for(;;)
      switch( *types++)
      {
      case 0 :
         mulle_vararg_end( args);
         return;

      case 'c' :
         printf( "%d\n", (int) mulle_vararg_next_integer( args, char));
         break;

      case 's' :
         printf( "%d\n", mulle_vararg_next_integer( args, short));
         break;

      case 'i' :
         printf( "%d\n", mulle_vararg_next_integer( args, int));
         break;

      case 'l' :
         printf( "%ld\n", mulle_vararg_next_integer( args, long));
         break;

      case 'q' :
         printf( "%lld\n", mulle_vararg_next_integer( args, long long));
         break;

      case 'f' :
         printf( "%f\n", mulle_vararg_next_fp( args, float));
         break;

      case 'd' :
         printf( "%f\n", mulle_vararg_next_fp( args, double));
         break;
      }
}

@end


int   main( int argc, const char * argv[])
{
   [Foo varargs:"sqcli", (short) 1848, (long long) 1848, (char) 18, (long) 1848, (int) 1848 ];
   [Foo varargs:"fd", (float) 18.48, (double) 18.48];
   return 0;
}
