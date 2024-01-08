#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo
@end


int  main( void)
{
   Foo   *foo;

   foo = [[Foo instantiate] init];
   // happy if it doesn't leak
   return( 0);
}
