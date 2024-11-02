#import <MulleObjC/MulleObjC.h>


@interface Foo : NSObject
@end


@implementation Foo

- (void) printUTF8String:(char *) s
{
   printf( "%s\n", s);
}

@end


int   main( void)
{
   Foo            *foo;
   NSInvocation   *invocation;

   foo        = [Foo new];
   invocation = [NSInvocation mulleInvocationWithTarget:foo
                                               selector:@selector( printUTF8String:),
                                               "VfL Bochum 1848"];
   [invocation invoke];
   [foo release];
   return( 0);
}


