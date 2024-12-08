#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


//
// just checking what happens if a NSThread is never called
//
@interface Foo : NSObject
@end


@implementation Foo

- (id) function:(id) arg
{
   printf( "%s\n", __PRETTY_FUNCTION__);
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

   foo = [Foo object];
   bar = [Bar object];

   @autoreleasepool
   {
      thread = [[[NSThread alloc] initWithTarget:foo
                                        selector:@selector( function:)
                                          object:bar] autorelease];
   }

   return( 0);
}
