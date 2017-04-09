#import <MulleObjC/MulleObjC.h>


@interface Foo : NSObject
@end


@implementation Foo

+ (Class) class
{
   Class  cls;

   cls = [super class];
   printf( "%s: %s\n", __PRETTY_FUNCTION__, cls == (void *) self ? "SAME" : "DIFFERENT");
   return( cls);
}


- (Class) class
{
   Class  cls;

   cls = [super class];
   printf( "%s: %s\n", __PRETTY_FUNCTION__, cls == (void *) mulle_objc_object_get_isa( self) ? "SAME" : "DIFFERENT");
   return( cls);
}

@end


int   main( int argc, char *argv[])
{
   Foo  *foo;

   [Foo class];
   foo = [Foo new];
   [foo class];

   [foo release];
   return( 0);
}
