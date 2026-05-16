#import <MulleObjC/MulleObjC.h>
#include <stdio.h>

@interface Foo : NSObject
- (int) add:(int) a to:(int) b;
@end

@implementation Foo
- (int) add:(int) a to:(int) b   { return( a + b); }
@end

static void  *my_add( Foo *self, mulle_objc_methodid_t _cmd, void *_param)
{
   int *p = _param;
   int  a = p[0];
   int  b = p[1];
   int  r = a + b + 2000;
   return( (void *) (intptr_t) r);
}

int   main( void)
{
   Foo   *foo = [[Foo new] autorelease];

   NSInvocation *inv = @invocation( foo,
       - (int) add:(int) a to:(int) b,
       10, 20) = (IMP) my_add;

   [inv invoke];
   int r;
   [inv getReturnValue:&r];
   printf( "%d\n", r);

   return( 0);
}
