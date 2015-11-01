//
//  main.m
//  test-meta-abi
//
//  Created by Nat! on 31.10.15.
//  Copyright © 2015 Mulle kybernetiK. All rights reserved.
//

#ifndef __MULLE_RUNTIME__
# import <Foundation/Foundation.h>
#else
# import "MulleObjCRoot.h"

struct _mulle_objc_runtime  *__get_or_create_objc_runtime( void)
{
   struct _mulle_objc_runtime    *runtime;
   
   runtime = __mulle_objc_get_runtime();
   if( ! runtime)
      runtime = (*mulle_objc_root_setup)();
   return( runtime);
}
#endif



struct _received
{
   BOOL   b;
   char   c;
   short  s;
   int    i;
   long   l;
   long long ll;
   char   *cp;
} received[ 16];


@interface Foo
@end


@implementation Foo

+ (void) callBool:(BOOL) v           { received[ 0].b = v;  }
+ (void) callChar:(char) v           { received[ 0].c = v;  }
+ (void) callShort:(short) v         { received[ 0].s = v;  }
+ (void) callInt:(int) v             { received[ 0].i = v;  }
+ (void) callLong:(long) v           { received[ 0].l = v;  }
+ (void) callLongLong:(long long) v  { received[ 0].ll = v; }
+ (void) callCharPtr:(char *) v      { received[ 0].cp = v; }

@end


void  single_args()
{
   [Foo callBool:0];
   assert( received[ 0].b == 0);
   [Foo callBool:1];
   assert( received[ 0].b == 1);

   [Foo callChar:CHAR_MIN];
   assert( received[ 0].c == CHAR_MIN);
   [Foo callChar:CHAR_MAX];
   assert( received[ 0].c == CHAR_MAX);

   [Foo callShort:SHRT_MIN];
   assert( received[ 0].s == SHRT_MIN);
   [Foo callShort:SHRT_MAX];
   assert( received[ 0].s == SHRT_MAX);

   [Foo callInt:INT_MIN];
   assert( received[ 0].i == INT_MIN);
   [Foo callInt:INT_MAX];
   assert( received[ 0].i == INT_MAX);

   [Foo callLong:LONG_MIN];
   assert( received[ 0].l == LONG_MIN);
   [Foo callLong:LONG_MAX];
   assert( received[ 0].l == LONG_MAX);

   [Foo callLongLong:LONG_LONG_MIN];
   assert( received[ 0].ll == LONG_LONG_MIN);
   [Foo callLongLong:LONG_LONG_MAX];
   assert( received[ 0].ll == LONG_LONG_MAX);
   
   [Foo callCharPtr:(char *) INTPTR_MIN];
   assert( received[ 0].cp == (char *) INTPTR_MIN);
   [Foo callCharPtr:(char *) INTPTR_MAX];
   assert( received[ 0].cp == (char *) INTPTR_MAX);
}


@implementation Foo ( DoubleArgs)

+ (void) callChar:(char) v  longlong:(long long) v2
{
   received[ 0].c   = v;
   received[ 1].ll = v2;
}


+ (void) callLongLong:(long long) v char:(char) v2
{
   received[ 0].ll = v;
   received[ 1].c = v2;
}


+ (void) callCharPtr:(char *) v  longlong:(long long) v2
{
   received[ 0].cp  = v;
   received[ 1].ll = v2;
}

@end


static void  double_args()
{
   [Foo callChar:CHAR_MIN longlong:LONG_LONG_MIN];
   assert( received[ 0].c == CHAR_MIN && received[ 1].ll == LONG_LONG_MIN);
   [Foo callChar:CHAR_MIN longlong:LONG_LONG_MAX];
   assert( received[ 0].c == CHAR_MIN && received[ 1].ll == LONG_LONG_MAX);

   [Foo callChar:CHAR_MAX longlong:LONG_LONG_MIN];
   assert( received[ 0].c == CHAR_MAX && received[ 1].ll == LONG_LONG_MIN);
   [Foo callChar:CHAR_MAX longlong:LONG_LONG_MAX];
   assert( received[ 0].c == CHAR_MAX && received[ 1].ll == LONG_LONG_MAX);

   // depends on string coalescing
   [Foo callCharPtr:"VfL Bochum 1848" longlong:LONG_LONG_MIN];
   assert( received[ 0].cp == "VfL Bochum 1848" && received[ 1].ll == LONG_LONG_MIN);
   [Foo callCharPtr:"VfL Bochum 1848" longlong:LONG_LONG_MAX];
   assert( received[ 0].cp == "VfL Bochum 1848" && received[ 1].ll == LONG_LONG_MAX);

}



@implementation Foo ( FatArgs)

+ (void) callLongLong:(char) v1
             longlong:(long long) v2
             longlong:(long long) v3
             longlong:(long long) v4
             longlong:(long long) v5
             longlong:(long long) v6
             longlong:(long long) v7
             longlong:(long long) v8
             longlong:(long long) v9
             longlong:(long long) v10
             longlong:(long long) v11
             longlong:(long long) v12
             longlong:(long long) v13
             longlong:(long long) v14
             longlong:(long long) v15
             longlong:(long long) v16
{
   received[ 0].ll = v1;
   received[ 1].ll = v2;
   received[ 2].ll = v3;
   received[ 3].ll = v4;
   received[ 4].ll = v5;
   received[ 5].ll = v6;
   received[ 6].ll = v7;
   received[ 7].ll = v8;
   received[ 8].ll = v9;
   received[ 9].ll = v10;
   received[10].ll = v11;
   received[11].ll = v12;
   received[12].ll = v13;
   received[13].ll = v14;
   received[14].ll = v15;
   received[15].ll = v16;
}

@end

static void  fat_args()
{
   unsigned int   i;
   
   [Foo callLongLong:1
            longlong:2
            longlong:3
            longlong:4
            longlong:5
            longlong:6
            longlong:7
            longlong:8
            longlong:9
            longlong:10
            longlong:11
            longlong:12
            longlong:13
            longlong:14
            longlong:15
            longlong:16];
   
   for( i = 0; i < 16; i++)
      assert( received[ i].ll == i + 1);
}


int main(int argc, const char * argv[])
{
#ifdef NDEBUG
# error "don't compile with NDEBUG defined"
#endif
   single_args();
   double_args();
   fat_args();
   return( 0);
}



