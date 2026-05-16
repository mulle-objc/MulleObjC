#import <MulleObjC/MulleObjC.h>
#include <stdio.h>

@interface Foo : NSObject
{
   int   _value;
}
- (int) add:(int) a to:(int) b;
- (int) value;
@end

@implementation Foo
- (int) add:(int) a to:(int) b   { return( a + b); }
- (int) value                    { return( _value); }
@end

int   main( void)
{
   Foo   *foo = [[Foo new] autorelease];

   // { body } can access self as Foo * and call methods on it
   NSInvocation *inv = @invocation( foo, - (int) add:(int) a to:(int) b, 10, 20)
   {
      return( a + b + [self value]);
   };

   [inv invoke];
   int r;
   [inv getReturnValue:&r];
   printf( "%d\n", r);

   return( 0);
}
