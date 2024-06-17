#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif



@interface Foo : NSObject < MulleObjCThreadSafe>
@end


static inline  void   stacktrace( void)
{
   _mulle_stacktrace( NULL, 1, mulle_stacktrace_linefeed, stderr);

}


@implementation Foo

- (void) release
{
   stacktrace();
   [super release];
}


- (id) retain
{
   stacktrace();
   return( [super retain]);
}


- (id) autorelease
{
   stacktrace();
   return( [super autorelease]);
}


- (void) dealloc
{
   stacktrace();
   [super dealloc];
}



- (void) function:(id) arg
{
}

@end


int   main( void)
{
   NSThread  *aThread;
   Foo       *foo;

   @autoreleasepool
   {
      foo     = [Foo object];

      // the NSThread will create an NSInvocation which will retain the
      // target and the argument
      // so [foo retainCount] will increase to 2
      aThread = [[[NSThread alloc] initWithTarget:foo
                                         selector:@selector( function:)
                                           object:foo] autorelease];
      [aThread mulleStartUndetached];
      [aThread mulleJoin];
   }

   return( 0);
}
