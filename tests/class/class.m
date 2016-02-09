#import <MulleStandaloneObjC/MulleStandaloneObjC.h>


@interface Foo : NSObject
@end


@implementation Foo

+ (Class) class
{
   Class  cls;

   cls = [super class];
   printf( "%s: %s\n", __PRETTY_FUNCTION__, cls == mulle_objc_object_get_class( self) ? "SAME" : "DIFFERENT");
   return( cls);
}


- (Class) class
{
   Class  cls;

   cls = [super class];
   printf( "%s: %s\n", __PRETTY_FUNCTION__, cls == mulle_objc_object_get_class( self) ? "SAME" : "DIFFERENT");
   return( cls);
}

@end


main()
{
   [Foo class];
   [[Foo new] class];
}
