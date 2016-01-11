//
//  main.m
//  test-varargs
//
//  Created by Nat! on 29.10.15.
//  Copyright © 2015 Mulle kybernetiK. All rights reserved.
//

#ifndef __MULLE_RUNTIME__
# import <Foundation/Foundation.h>
#else
# import "NSObjC.h"

struct _mulle_objc_runtime  *__get_or_create_objc_runtime( void)
{
   struct _mulle_objc_runtime    *runtime;
   
   runtime = __mulle_objc_get_runtime();
   if( ! runtime)
      runtime = (*ns_root_setup)();
   return( runtime);
}

@interface NSString < NSObject>

- (char *) cString;

@end

#endif

#include <mulle_objc_runtime/mulle_objc_vararg.h>


@interface Foo

+ (void) varargs:(char *) types, ...;

@end


@implementation Foo

struct call_1
{
   union { char  v; int filler; } a;
   union { short v; int filler; } b;
   union { int   v; int filler; } c;
   union { long  v; int filler; } d;
   union { long long v; int filler; } e;
};

struct call_2
{
   union { float  v; int filler; } a;
   union { double v; int filler; } b;
};


+ (void) varargs:(char *) types, ...
{
   mulle_objc_vararg_list   args;
   struct call_1            *call1;
   struct call_2            *call2;
   
   mulle_objc_vararg_start( args, types);
   
   call1 = args.p;
   call2 = args.p;
   
   for(;;)
      switch( *types++)
      {
      case 0 :
         mulle_objc_vararg_end( args);
         return;
         
      case 'c' :
         printf( "%d\n", (int) mulle_objc_vararg_next( args, char));
         break;
         
      case 's' :
         printf( "%d\n", mulle_objc_vararg_next( args, short));
         break;
         
      case 'i' :
         printf( "%d\n", mulle_objc_vararg_next( args, int));
         break;
         
      case 'l' :
         printf( "%ld\n", mulle_objc_vararg_next( args, long));
         break;
         
      case 'q' :
         printf( "%lld\n", mulle_objc_vararg_next( args, long long));
         break;
         
      case 'f' :
         printf( "%f\n", mulle_objc_vararg_next_fp( args, float));
         break;
         
      case 'd' :
         printf( "%f\n", mulle_objc_vararg_next_fp( args, double));
         break;
      }
}

@end


int main(int argc, const char * argv[])
{
   [Foo varargs:"csilq", (char) 18, (short) 1848, (int) 1848, (long) 1848, (long long) 1848];
   [Foo varargs:"fd", (float) 18.48, (double) 18.48];
   return 0;
}
