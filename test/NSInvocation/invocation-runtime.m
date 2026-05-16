#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif
#include <stdio.h>


@interface Foo : NSObject
- (int) add:(int) a to:(int) b;
@end

@implementation Foo
- (int) add:(int) a to:(int) b { return( a + b); }
@end


int   main( void)
{
   Foo *obj = [Foo instance];

   // Mode 3: runtime SEL variable, sig nil -> looked up from target
   SEL               sel = @selector( add:to:);
   NSMethodSignature *sig = nil;
   NSInvocation      *inv = @invocation( obj, sel, sig, 3, 4);

   printf( "inv: %s\n", inv ? "ok" : "null");
   printf( "sig: %s\n", [inv methodSignature] ? "ok" : "null");

   // Mode 3 with explicit signature
   NSMethodSignature *sig2 = [obj methodSignatureForSelector:sel];
   NSInvocation      *inv2 = @invocation( obj, sel, sig2, 10, 20);

   printf( "inv2: %s\n", inv2 ? "ok" : "null");

   return( 0);
}
