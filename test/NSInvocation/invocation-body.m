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
   Foo   *foo = [[Foo new] autorelease];

   NSInvocation *inv = @invocation( foo,
       - (int) add:(int) a to:(int) b,
       10, 20)
   {
      return( a + b + 1000);
   };

   [inv invoke];
   int r;
   [inv getReturnValue:&r];
   printf( "%d\n", r);

   return( 0);
}
