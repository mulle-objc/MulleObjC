#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif
#include <stdio.h>


@interface Foo : NSObject
- (void) doSomething;
@end

@implementation Foo
- (void) doSomething {}
@end


int   main( void)
{
   Foo *obj = [Foo instance];

   // nil sel, nil sig: signature lookup [obj methodSignatureForSelector:NULL]
   // returns nil -> invocation should be nil
   SEL sel = (SEL) 0;
   NSInvocation *inv = @invocation( obj, sel, nil);
   printf( "nil-sel inv: %s\n", inv ? "ok" : "null");

   return( 0);
}
