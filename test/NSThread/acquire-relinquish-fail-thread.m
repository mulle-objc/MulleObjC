#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif

//
// This tests, that foo can not be shared to multiple thread, though
// the function being used is marked a threadsafe
//
@interface Foo : NSObject

- (void) function:(id) arg    MULLE_OBJC_THREADSAFE_METHOD;

@end


@implementation Foo

- (void) function:(id) arg
{
   mulle_relativetime_sleep( 0.001);
}

@end


int   main( void)
{
   NSThread  *aThread;
   NSThread  *bThread;
   Foo       *foo;

   @autoreleasepool
   {
      foo     = [Foo object];

      // since foo is not MulleObjCThreadSafe you can't pass it to two threads
      // it just won't work (except for weird races, where one thread dies
      // immediately before the other starts)
      //
      aThread = [[[NSThread alloc] initWithTarget:foo
                                         selector:@selector( function:)
                                           object:nil] autorelease];

      //
      // doing initWithTarget:foo again is already a mistake. foo no longer
      // belongs to the current thread if [aThread mulleStart]
      // was moved above bThread = [[[NSThread alloc] initWithTarget:
      //
      bThread = [[[NSThread alloc] initWithTarget:foo
                                         selector:@selector( function:)
                                           object:nil] autorelease];
      [aThread mulleStart];
      [bThread mulleStart];

      [bThread mulleJoin];
      [aThread mulleJoin];
   }

   return( 0);
}
