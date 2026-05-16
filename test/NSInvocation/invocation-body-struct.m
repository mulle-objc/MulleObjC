#import <MulleObjC/MulleObjC.h>
#include <stdio.h>

struct Point { int x; int y; };

@interface Foo : NSObject
- (struct Point) makeX:(int) x y:(int) y;
@end

@implementation Foo
- (struct Point) makeX:(int) x y:(int) y
{
   return( (struct Point){ x, y});
}
@end

int   main( void)
{
   Foo   *foo = [[Foo new] autorelease];

   // First verify the normal path works
   NSInvocation *inv1 = @invocation( foo, - (struct Point) makeX:(int) x y:(int) y, 42, 99);
   [inv1 invoke];
   struct Point pt1;
   [inv1 getReturnValue:&pt1];
   printf( "normal: %d,%d\n", pt1.x, pt1.y);

   // Now the body form
   NSInvocation *inv2 = @invocation( foo, - (struct Point) makeX:(int) x y:(int) y, 42, 99)
   {
      return( (struct Point){ x * 2, y * 2});
   };

   [inv2 invoke];
   struct Point pt2;
   [inv2 getReturnValue:&pt2];
   printf( "body: %d,%d\n", pt2.x, pt2.y);

   return( 0);
}
