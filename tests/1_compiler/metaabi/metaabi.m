//
//  main.m
//  test-meta-abi
//
//  Created by Nat! on 31.10.15.
//  Copyright © 2015 Mulle kybernetiK. All rights reserved.
//
#include <mulle_objc_runtime/mulle_objc_runtime.h>
#include <limits.h>
#include <stdio.h>


struct _received
{
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

+ (void) callChar:(char) v           { received[ 0].c = v;  }
+ (void) callShort:(short) v         { received[ 0].s = v;  }
+ (void) callInt:(int) v             { received[ 0].i = v;  }
+ (void) callLong:(long) v           { received[ 0].l = v;  }
+ (void) callLongLong:(long long) v  { received[ 0].ll = v; }
+ (void) callCharPtr:(char *) v      { received[ 0].cp = v; }

@end


void  single_args()
{
   [Foo callChar:CHAR_MIN];
   printf( "-callChar:CHAR_MIN %s\n",  (received[ 0].c == CHAR_MIN)  ? "PASS" : "FAIL");
   [Foo callChar:CHAR_MAX];
   printf( "-callChar:CHAR_MAX %s\n",  (received[ 0].c == CHAR_MAX)  ? "PASS" : "FAIL");

   [Foo callShort:SHRT_MIN];
   printf( "-callShort:SHRT_MIN %s\n",  (received[ 0].s== SHRT_MIN)  ? "PASS" : "FAIL");
   [Foo callShort:SHRT_MAX];
   printf( "-callShort:SHRT_MAX %s\n",  (received[ 0].s== SHRT_MAX)  ? "PASS" : "FAIL");

   [Foo callInt:INT_MIN];
   printf( "-callShort:INT_MIN %s\n",  (received[ 0].i== INT_MIN)  ? "PASS" : "FAIL");
   [Foo callInt:INT_MAX];
   printf( "-callShort:INT_MAX %s\n",  (received[ 0].i== INT_MAX)  ? "PASS" : "FAIL");

   [Foo callLong:LONG_MIN];
   printf( "-callLong:LONG_MIN %s\n",  (received[ 0].l== LONG_MIN)  ? "PASS" : "FAIL");
   [Foo callLong:LONG_MAX];
   printf( "-callLong:LONG_MAX %s\n",  (received[ 0].l == LONG_MAX)  ? "PASS" : "FAIL");

   [Foo callLongLong:LLONG_MIN];
   printf( "-callLongLong:LLONG_MIN %s\n",  (received[ 0].ll == LLONG_MIN)  ? "PASS" : "FAIL");
   [Foo callLongLong:LLONG_MAX];
   printf( "-callLongLong:LLONG_MAX %s\n",  (received[ 0].ll == LLONG_MAX) ? "PASS" : "FAIL");

   [Foo callCharPtr:(char *) INTPTR_MIN];
   printf( "-callCharPtr:INTPTR_MIN %s\n",  (received[ 0].cp == (char *) INTPTR_MIN) ? "PASS" : "FAIL");
   [Foo callCharPtr:(char *) INTPTR_MAX];
   printf( "-callCharPtr:INTPTR_MAX %s\n",  (received[ 0].cp == (char *) INTPTR_MAX) ? "PASS" : "FAIL");
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
   char   *s;

   [Foo callChar:CHAR_MIN longlong:LLONG_MIN];
   printf( "-callChar:CHAR_MIN longlong:LLONG_MIN %s\n", (received[ 0].c == CHAR_MIN && received[ 1].ll == LLONG_MIN) ? "PASS" : "FAIL");
   [Foo callChar:CHAR_MIN longlong:LLONG_MAX];
   printf( "-callChar:CHAR_MIN longlong:LLONG_MAX %s\n", (received[ 0].c == CHAR_MIN && received[ 1].ll == LLONG_MAX) ? "PASS" : "FAIL");

   [Foo callChar:CHAR_MAX longlong:LLONG_MIN];
   printf( "-callChar:CHAR_MAX longlong:LLONG_MIN %s\n", (received[ 0].c == CHAR_MAX && received[ 1].ll == LLONG_MIN) ? "PASS" : "FAIL");
   [Foo callChar:CHAR_MAX longlong:LLONG_MAX];
   printf( "-callChar:CHAR_MAX longlong:LLONG_MAX %s\n", (received[ 0].c == CHAR_MAX && received[ 1].ll == LLONG_MAX) ? "PASS" : "FAIL");

   s = "VfL Bochum 1848";
   [Foo callCharPtr:s longlong:LLONG_MIN];
   printf( "-callCharPtr:\"%s\" longlong:LLONG_MIN %s\n", s, (received[ 0].cp == s && received[ 1].ll == LLONG_MIN) ? "PASS" : "FAIL");
   [Foo callCharPtr:s longlong:LLONG_MAX];
   printf( "-callCharPtr:\"%s\" longlong:LLONG_MAX %s\n", s, (received[ 0].cp == s && received[ 1].ll == LLONG_MAX) ? "PASS" : "FAIL");
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
      printf( "-callLongLong:... #%u %s\n",  i, (received[ i].ll == i + 1) ? "PASS" : "FAIL");
}


int main(int argc, const char * argv[])
{
   single_args();
   double_args();
   fat_args();
   return( 0);
}



