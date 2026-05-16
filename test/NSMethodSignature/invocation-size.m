#import <MulleObjC/MulleObjC.h>
#include <stdio.h>

@interface Foo : NSObject
- (void) doNothing;
- (int) add:(int) a to:(int) b;
- (double) sum:(double) x and:(double) y;
@end

@implementation Foo
- (void) doNothing                         {}
- (int) add:(int) a to:(int) b             { return( a + b); }
- (double) sum:(double) x and:(double) y   { return( x + y); }
@end

int   main( void)
{
   NSMethodSignature *sig;

   sig = @signature( - (void) doNothing);
   printf( "void/void: %u\n", (unsigned) [sig mulleInvocationSize]);

   sig = @signature( - (int) add:(int) a to:(int) b);
   printf( "int/multi: %u\n", (unsigned) [sig mulleInvocationSize]);

   sig = @signature( - (double) sum:(double) x and:(double) y);
   printf( "double/multi: %u\n", (unsigned) [sig mulleInvocationSize]);

   return( 0);
}
