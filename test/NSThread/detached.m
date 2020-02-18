#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo

+ (void) function:(id) arg
{
   [[NSObject new] autorelease];
   printf( "%s\n", __PRETTY_FUNCTION__);
}

@end


int main( void)
{
   NSThread    *thread;

   [NSThread detachNewThreadSelector:@selector( function:)
                            toTarget:[Foo class]
                          withObject:nil];
   sleep( 1);
   return( 0);
}
