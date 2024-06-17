#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif



@interface Foo : NSObject < MulleObjCThreadSafe>
@end



@implementation Foo

- (void) release
{
   [super release];
}


- (id) retain
{
   return( [super retain]);
}


- (id) autorelease
{
   return( [super autorelease]);
}


- (void) dealloc
{
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
      foo = [Foo object];

      @autoreleasepool
      {
         // the NSThread will create an NSInvocation which will retain the
         // target and the argument
         // so [foo retainCount] will increase to 2
         aThread = [[[NSThread alloc] initWithTarget:foo
                                            selector:@selector( function:)
                                              object:foo] autorelease];
         [aThread mulleStartUndetached];
         [aThread mulleJoin];  // this does no owner transfership
      }
   }

   return( 0);
}
