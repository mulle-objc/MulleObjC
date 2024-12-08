#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


//
// just checking what happens if a NSThread is started but never joined
//
@interface Foo : NSObject
@end


@implementation Foo

- (id) method:(id) arg
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
   return( nil);
}

@end

//
@interface Bar : NSObject
@end


@implementation Bar
@end


int main( void)
{
   Foo        *foo;
   Bar        *bar;
   NSThread   *thread;

   [NSThread mulleSetMainThreadWaitsAtExit:YES];

   @autoreleasepool
   {
      foo = [Foo object];
      bar = [Bar object];

      thread = [[[NSThread alloc] initWithTarget:foo
                                        selector:@selector( method:)
                                          object:bar] autorelease];
      [thread mulleStart];
   }

   return( 0);
}
