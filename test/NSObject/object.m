#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
# import <MulleObjC/NSDebug.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo
@end


int   main( void)
{
   Foo   *foo;

#ifdef __MULLE_OBJC__
   MulleObjCDotdumpInfraHierarchy( "Foo");
   MulleObjCDotdumpMetaHierarchy( "Foo");
#endif

   foo = [Foo object];
   // happy if it doesn't leak
   return( 0);
}
