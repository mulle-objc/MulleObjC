#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject < MulleObjCClassCluster>
@end


@interface Bar : Foo
@end


@implementation Foo

- (id) init
{
   [self release];
   return( [Bar new]);
}

@end


@implementation  Bar

- (id) init
{
   return( self);
}

@end


main()
{
   Foo   *foo;

   foo = [Foo object]; // this should not leak

   // no leaks
   return( 0);
}
