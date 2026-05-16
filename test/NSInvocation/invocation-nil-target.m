#import <MulleObjC/MulleObjC.h>
#include <stdio.h>

@interface Foo : NSObject
- (int) add:(int) a to:(int) b;
@end

@implementation Foo
- (int) add:(int) a to:(int) b   { return( a + b); }
@end

int   main( void)
{
   // nil target with explicit signature — creates invocation, invoke is a no-op
   NSInvocation *inv = @invocation( (Foo *) nil,
       @selector( add:to:),
       @signature( - (int) add:(int) a to:(int) b),
       10, 20);
   printf( "%s\n", inv ? "created" : "null");

   // set a real target and invoke
   Foo *foo = [[Foo new] autorelease];
   [inv invokeWithTarget:foo];
   int r = 0;
   [inv getReturnValue:&r];
   printf( "%d\n", r);

   return( 0);
}
