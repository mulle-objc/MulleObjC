#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo

+ (void) method:(id) arg
{
   [Foo object]; // create an object for leak test
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
   MulleObjCDumpAutoreleasePoolsFrame();
}

@end


int main( void)
{
   NSThread    *thread;

   @autoreleasepool
   {
      [NSThread mulleSetMainThreadWaitsAtExit:YES];  // ensure
      [NSThread detachNewThreadSelector:@selector( method:)
                               toTarget:[Foo class]
                             withObject:nil];
      MulleObjCDumpAutoreleasePoolsFrame();
   }
   return( 0);
}
