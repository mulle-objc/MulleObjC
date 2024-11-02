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
   printf( "%x %g\n", x.a, x.b);
   printf( "%x %g\n", y.a, y.b);
}

@end


int   main( void)
{
   Foo            *foo;
   NSInvocation   *invocation;

   foo        = [Foo new];
   invocation = [NSInvocation mulleInvocationWithTarget:foo
                                               selector:@selector( x:y:),
                                               (struct ab) { (int) 0x0123456789ABCDEFLL, 2.0 },
                                               (struct ab) { (int) 0x1111222233334444LL, 4.0 }];
   [invocation invoke];
   [foo release];
   return( 0);
}


