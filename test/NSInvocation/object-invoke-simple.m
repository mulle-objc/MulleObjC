#import <MulleObjC/MulleObjC.h>


@interface Foo : NSObject
@end


@implementation Foo

- (void) print:(id) s
{
   printf( "%s\n", [s UTF8String]);
}

@end


int   main( void)
{
   Foo            *foo;
   NSInvocation   *invocation;

   foo        = [Foo new];
   invocation = [NSInvocation mulleInvocationWithTarget:foo
                                               selector:@selector( print:)
                                                 object:foo];
   [invocation invoke];
   [foo release];
   return( 0);
}


