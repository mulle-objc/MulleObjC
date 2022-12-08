#import <MulleObjC/MulleObjC.h>


@interface Foo : NSObject
@end


@implementation Foo

struct ab
{
   int     a;
   double  b;
};


- (void) x:(struct ab) x
         y:(struct ab) y
{
   printf( "%d %g\n", x.a, x.b);
   printf( "%d %g\n", y.a, y.b);
}

@end


int   main( void)
{
   Foo            *foo;
   NSInvocation   *invocation;

   foo        = [Foo new];
   invocation = [NSInvocation mulleInvocationWithTarget:foo
                                               selector:@selector( x:y:),
                                               (struct ab) { 1, 2.0 },
                                               (struct ab) { 3, 4.0 }];
   [invocation invoke];
   [foo release];
   return( 0);
}


