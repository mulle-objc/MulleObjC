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
   // static @signature
   NSMethodSignature *staticSig = @signature( - (int) add:(int) a to:(int) b);

   // dynamic from class method
   NSMethodSignature *dynSig = [Foo instanceMethodSignatureForSelector:@selector( add:to:)];

   printf( "static size: %u\n", (unsigned) [staticSig mulleInvocationSize]);
   printf( "dynamic size: %u\n", (unsigned) [dynSig mulleInvocationSize]);
   printf( "match: %s\n",
       [staticSig mulleInvocationSize] == [dynSig mulleInvocationSize] ? "yes" : "no");

   return( 0);
}
